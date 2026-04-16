//
//  MapManager.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 16.04.2026.
//

import MapKit
import UIKit

// MARK: - Delegate

protocol MapManagerDelegate: AnyObject {
    func mapManager(
        _ manager: MapManager,
        regionDidChange region: MKCoordinateRegion
    )
}

// MARK: - MapManagerProtocol
protocol MapManagerProtocol: AnyObject {
    func setup(mapView: MKMapView, delegate: MapManagerDelegate)
    func showFlights(_ flights: [FlightState])
    func zoomIn()
    func zoomOut()
    var currentRegion: MKCoordinateRegion { get }
}

// MARK: - MapManager
final class MapManager: NSObject {

    static let shared = MapManager()

    private weak var mapView: MKMapView?
    private weak var delegate: MapManagerDelegate?

    private let annotationReuseId = "FlightAnnotation"

    private override init() {}
}

// MARK: - MapManagerProtocol

extension MapManager: MapManagerProtocol {

    var currentRegion: MKCoordinateRegion {
        mapView?.region ?? MKCoordinateRegion()
    }

    func setup(mapView: MKMapView, delegate: MapManagerDelegate) {
        self.mapView = mapView
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.register(
            MKAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: annotationReuseId
        )

        // Dünya görünümüyle başlat — delegate'i sonradan set et ki
        // setRegion'ın tetiklediği regionDidChange callback'i yok sayılsın
        let worldRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 150)
        )
        mapView.setRegion(worldRegion, animated: false)
        self.delegate = delegate
    }

    func zoomIn() {
        guard let mapView else { return }
        var region = mapView.region
        region.span.latitudeDelta  = max(region.span.latitudeDelta  / 2, 0.002)
        region.span.longitudeDelta = max(region.span.longitudeDelta / 2, 0.002)
        mapView.setRegion(region, animated: true)
    }

    func zoomOut() {
        guard let mapView else { return }
        var region = mapView.region
        region.span.latitudeDelta  = min(region.span.latitudeDelta  * 2, 180)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2, 360)
        mapView.setRegion(region, animated: true)
    }

    func showFlights(_ flights: [FlightState]) {
        guard let mapView else { return }

        let existingAnnotations = mapView.annotations.compactMap { $0 as? FlightAnnotation }
        var existingDict = [String: FlightAnnotation]()
        existingAnnotations.forEach {
            if let id = $0.flight.icao24 { existingDict[id] = $0 }
        }

        var annotationsToAdd = [FlightAnnotation]()
        var identifiersToKeep = Set<String>()

        for flight in flights {
            guard flight.latitude != nil, flight.longitude != nil, let id = flight.icao24 else { continue }
            identifiersToKeep.insert(id)

            if let existingAnnotation = existingDict[id] {
                // Uçak haritada varsa, animasyonsuz olarak veriyi ve koordinatı güncelle.
                // @objc dynamic sayesinde MapKit pinin yerini otomatik kaydıracak.
                existingAnnotation.flight = flight
                existingAnnotation.coordinate = CLLocationCoordinate2D(latitude: flight.latitude!, longitude: flight.longitude!)
                
                // Eğer uçağın açısının (rotasyon) anlık güncellenmesini istiyorsan annotation view'ı bulup transform'unu güncelleyebilirsin:
                if let view = mapView.view(for: existingAnnotation) {
                    if let track = flight.trueTrack {
                        let radians = CGFloat(track) * .pi / 180
                        view.transform = CGAffineTransform(rotationAngle: radians)
                    }
                }
            } else {
                // Uçak haritada yoksa yeni pin yarat
                let newAnnotation = FlightAnnotation(flight: flight)
                annotationsToAdd.append(newAnnotation)
            }
        }

        let annotationsToRemove = existingAnnotations.filter {
            guard let id = $0.flight.icao24 else { return true }
            return !identifiersToKeep.contains(id)
        }

        mapView.removeAnnotations(annotationsToRemove)
        mapView.addAnnotations(annotationsToAdd)
    }
}

// MARK: - MKMapViewDelegate

extension MapManager: MKMapViewDelegate {

    func mapView(
        _ mapView: MKMapView,
        regionDidChangeAnimated animated: Bool
    ) {
        delegate?.mapManager(self, regionDidChange: mapView.region)
    }

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        guard let flightAnnotation = annotation as? FlightAnnotation else { return nil }

        let view = mapView.dequeueReusableAnnotationView(
            withIdentifier: annotationReuseId,
            for: annotation
        )

        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        view.image = UIImage(systemName: "airplane", withConfiguration: config)
        view.tintColor = .systemBlue
        view.canShowCallout = true

        // Gerçek yön açısına göre döndür
        if let track = flightAnnotation.flight.trueTrack {
            let radians = CGFloat(track) * .pi / 180
            view.transform = CGAffineTransform(rotationAngle: radians)
        }

        return view
    }
}
