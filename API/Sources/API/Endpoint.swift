//
//  Endpoint.swift
//  API
//
//  Created by Semih Özsoy on 15.04.2026.
//

import Alamofire

public protocol Endpoint {
    var baseUrl: String {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters:[String: Sendable] {get}
    var headers: [String: String] {get}
    var encoding: ParameterEncoding {get}
}

public extension Endpoint {
    var headers: [String: String] { [:] }
    var parameters: [String: Sendable] { [:] }
    var url: String {"\(baseUrl)\(path)"}
}
