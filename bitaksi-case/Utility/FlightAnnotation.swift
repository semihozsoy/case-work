//
//  FlightAnnotation.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 16.04.2026.
//

import MapKit

final class FlightAnnotation: NSObject, MKAnnotation {
    var flight: FlightState
    
    // MapKit'in lokasyon değişimini dinleyebilmesi için @objc dynamic
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?
    
    init(flight: FlightState) {
        self.flight = flight
        self.coordinate = CLLocationCoordinate2D(
            latitude: flight.latitude ?? 0,
            longitude: flight.longitude ?? 0
        )
        self.title = flight.callsign?.isEmpty == false ? flight.callsign : flight.icao24
        self.subtitle = flight.originCountry
        super.init()
    }
}

