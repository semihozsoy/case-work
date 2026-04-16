//
//  RequestToken.swift
//  API
//
//  Created by Semih Özsoy on 16.04.2026.
//

import Alamofire

public final class RequestToken {
    private let dataRequest: DataRequest
    init(_ dataRequest: DataRequest) { self.dataRequest = dataRequest }
    public func cancel() { dataRequest.cancel() }
}
