//
//  HomeEndpointItem.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 15.04.2026.
//


import Foundation
import API


// MARK: - HomeEndpointItem

enum HomeEndpointItem {
    case getToken
    case states(token: String, bbox: BoundingBox? = nil)
}

extension HomeEndpointItem: Endpoint {

    var baseUrl: String {
        switch self {
        case .getToken:
            return "https://auth.opensky-network.org"
        case .states:
            return "https://opensky-network.org/api"
        }
    }

    var path: String {
        switch self {
        case .getToken:
            return "/auth/realms/opensky-network/protocol/openid-connect/token"
        case .states:
            return "/states/all"
        }
    }

    var parameters: [String: Sendable] {
        switch self {
        case .getToken:
            return [
                "grant_type": "client_credentials",
                "client_id": "semihozsoy-api-client",
                "client_secret": "zjBrHOAtsPukbMh5jbNK1CqeSFMVSX83"
            ]
        case .states(_, let bbox):
            guard let bbox else { return [:] }
            return [
                "lamin": bbox.lamin,
                "lomin": bbox.lomin,
                "lamax": bbox.lamax,
                "lomax": bbox.lomax
            ]
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .getToken: return .urlHttpBody
        case .states:   return .urlDefault
        }
    }

    var headers: [String: String] {
        switch self {
        case .getToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .states(let token, _):
            return ["Authorization": "Bearer \(token)"]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getToken: return .post
        case .states:   return .get
        }
    }
}
