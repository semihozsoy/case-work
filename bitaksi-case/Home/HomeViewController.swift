//
//  HomeViewController.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 15.04.2026.
//

import UIKit
import MapKit

protocol HomeViewInterface: AnyObject {
    func showFlights(_ flights: [FlightState])
    func showLoading()
    func hideLoading()
    func showCountryPicker(countries: [String], selected: String?)
    func updateFilterButton(isActive: Bool)
}

final class HomeViewController: UIViewController {
    var presenter: HomePresenterInterface?

    @IBOutlet weak var mapView: MKMapView!
    private let indicator = UIActivityIndicatorView(style: .large)

    private lazy var zoomInButton: UIButton  = {
        let b = makeZoomButton(systemName: "plus.magnifyingglass")
        b.addTarget(self, action: #selector(zoomInTapped), for: .touchUpInside)
        return b
    }()
    private lazy var zoomOutButton: UIButton = {
        let b = makeZoomButton(systemName: "minus.magnifyingglass")
        b.addTarget(self, action: #selector(zoomOutTapped), for: .touchUpInside)
        return b
    }()
    private lazy var filterButton: UIButton = {
        let b = makeZoomButton(systemName: "line.3.horizontal.decrease.circle")
        b.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        setupZoomButtons()
        MapManager.shared.setup(mapView: mapView, delegate: self)
        presenter?.notifyViewLoaded()
    }

    private func setupIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupZoomButtons() {
        let stack = UIStackView(arrangedSubviews: [filterButton, zoomInButton, zoomOutButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func makeZoomButton(systemName: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: systemName)
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        return button
    }

    @objc private func zoomInTapped() {
        MapManager.shared.zoomIn()
    }

    @objc private func zoomOutTapped() {
        MapManager.shared.zoomOut()
    }

    @objc private func filterTapped() {
        presenter?.notifyFilterTapped()
    }
}

// MARK: - AlertShowable
extension HomeViewController: AlertShowable {
    func showCountryPicker(
        countries: [String],
        selected: String?
    ) {
        showActionSheet(
            title: "Kalkış Ülkesi",
            options: countries,
            selected: selected
        ) { [weak self] country in
            self?.presenter?.notifyCountrySelected(country)
        }
    }
}

// MARK: - HomeViewInterface
extension HomeViewController: HomeViewInterface {

    func showFlights(_ flights: [FlightState]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            MapManager.shared.showFlights(flights)
        }
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.indicator.startAnimating()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.indicator.stopAnimating()
        }
    }

    func updateFilterButton(isActive: Bool) {
        DispatchQueue.main.async { [weak self] in
            let color = isActive ? UIColor.systemOrange : UIColor.systemBlue
            var config = self?.filterButton.configuration
            config?.baseBackgroundColor = color.withAlphaComponent(0.9)
            self?.filterButton.configuration = config
        }
    }
}

// MARK: - MapManagerDelegate
extension HomeViewController: MapManagerDelegate {
    func mapManager(
        _ manager: MapManager,
        regionDidChange region: MKCoordinateRegion
    ) {
        presenter?.notifyRegionChanged(region: region)
    }
}
