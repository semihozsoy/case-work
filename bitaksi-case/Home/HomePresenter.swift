//
//  HomePresenter.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 15.04.2026.
//

import Foundation
import Combine
import MapKit

protocol HomePresenterInterface: AnyObject {
    func notifyViewLoaded()
    func notifyRegionChanged(region: MKCoordinateRegion)
    func didFetchFlights(_ flights: [FlightState])
    func didFailWithError(_ error: Error)
    func notifyFilterTapped()
    func notifyCountrySelected(_ country: String?)
}

final class HomePresenter {
    weak var view: HomeViewInterface?
    var router: HomeRouterInterface?
    var interactor: HomeInteractorInterface?

    private let regionSubject = PassthroughSubject<MKCoordinateRegion, Never>()
    private var cancellables = Set<AnyCancellable>()

    private var allFlights: [FlightState] = []
    private var selectedCountry: String?
}

extension HomePresenter: HomePresenterInterface {

    func notifyViewLoaded() {
        setupAutoRefresh()
        view?.showLoading()
        interactor?.fetchToken()
    }

    func notifyRegionChanged(region: MKCoordinateRegion) {
        LogManager.debug("[HomePresenter] Region changed → center: \(region.center.latitude), \(region.center.longitude)")
        regionSubject.send(region)
    }

    func didFetchFlights(_ flights: [FlightState]) {
        allFlights = flights
        view?.hideLoading()
        applyFilter()
    }

    func notifyFilterTapped() {
        let countries = Array(Set(allFlights.compactMap { $0.originCountry })).sorted()
        view?.showCountryPicker(countries: countries, selected: selectedCountry)
    }

    func notifyCountrySelected(_ country: String?) {
        selectedCountry = country
        applyFilter()
    }

    func didFailWithError(_ error: Error) {
        view?.hideLoading()
        LogManager.error("[HomePresenter] \(error)")
    }
}

// MARK: - Private

private extension HomePresenter {

    func applyFilter() {
        let filtered: [FlightState]
        if let country = selectedCountry {
            filtered = allFlights.filter { $0.originCountry == country }
        } else {
            filtered = allFlights
        }
        view?.showFlights(filtered)
        view?.updateFilterButton(isActive: selectedCountry != nil)
    }

    func setupAutoRefresh() {
        regionSubject
            .map { region -> AnyPublisher<MKCoordinateRegion, Never> in
                Just(region)
                    .delay(for: .seconds(5), scheduler: RunLoop.main)
                    .flatMap { region in
                        Timer.publish(every: 5, on: .main, in: .common)
                            .autoconnect()
                            .map { _ in region }
                            .prepend(region)
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { [weak self] region in
                LogManager.info("[HomePresenter] ⏱ Auto-refresh triggered → bbox: \(BoundingBox(region: region))")
                let bbox = BoundingBox(region: region)
                self?.interactor?.fetchStates(bbox: bbox)
            }
            .store(in: &cancellables)
    }
}
