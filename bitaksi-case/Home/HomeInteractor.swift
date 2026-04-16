//
//  HomeInteractor.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 15.04.2026.
//

import Foundation
import API

protocol HomeInteractorInterface: AnyObject {
    func fetchToken()
    func fetchStates(bbox: BoundingBox?)
}

final class HomeInteractor {
    weak var presenter: HomePresenterInterface?
    let networkManager: NetworkManager<HomeEndpointItem> = NetworkManager(eventMonitors: [NetworkLogger()])
    private var accessToken: String?
}

extension HomeInteractor: HomeInteractorInterface {

    func fetchToken() {
        networkManager.request(endpoint: .getToken, type: TokenResponse.self) { [weak self] result in
            switch result {
            case .success(let tokenResponse):
                self?.accessToken = tokenResponse.accessToken
                self?.fetchStates(bbox: nil)
            case .failure(let error):
                self?.presenter?.didFailWithError(error)
            }
        }
    }

    func fetchStates(bbox: BoundingBox?) {
        guard let token = accessToken else {
            LogManager.warning("no token")
            fetchToken()
            return
        }
        LogManager.debug("fetchStates | bbox: \(bbox.map { "lamin:\($0.lamin) lomin:\($0.lomin) lamax:\($0.lamax) lomax:\($0.lomax)" } ?? "nil (world)")")
        networkManager.request(
            endpoint: .states(token: token, bbox: bbox),
            type: HomeResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let response):
                LogManager.info("fetchStates success → \(response.states.count) flights")
                self?.presenter?.didFetchFlights(response.states)
            case .failure(let error):
                LogManager.error("fetchStates error → \(error)")
                self?.presenter?.didFailWithError(error)
            }
        }
    }
}
