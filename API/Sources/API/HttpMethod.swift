//
//  HttpMethod.swift
//  API
//
//  Created by Semih Özsoy on 15.04.2026.
//

import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod

public extension Endpoint {
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

}
