//
//  HttpMethod.swift
//  API
//
//  Created by Semih Özsoy on 15.04.2026.
//

import Alamofire

public enum HTTPMethod {
    case get
    case post
    case put
    case patch
    case delete
}

public enum HTTPEncoding {
    case urlDefault
    case urlHttpBody
    case json
}

public extension Endpoint {
    var encoding: HTTPEncoding {
        switch method {
        case .get: return .urlDefault
        default:   return .json
        }
    }
}

extension HTTPMethod {
    var alamofireMethod: Alamofire.HTTPMethod {
        switch self {
        case .get:    return .get
        case .post:   return .post
        case .put:    return .put
        case .patch:  return .patch
        case .delete: return .delete
        }
    }
}

extension HTTPEncoding {
    var alamofireEncoding: Alamofire.ParameterEncoding {
        switch self {
        case .urlDefault:  return Alamofire.URLEncoding.default
        case .urlHttpBody: return Alamofire.URLEncoding.httpBody
        case .json:        return Alamofire.JSONEncoding.default
        }
    }
}
