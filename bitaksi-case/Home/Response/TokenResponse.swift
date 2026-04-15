//
//  TokenResponse.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 16.04.2026.
//

import Foundation

public struct TokenResponse: Codable {
    public let accessToken: String?
    public let expiresIn, refreshExpiresIn: Int?
    public let tokenType: String?
    public let notBeforePolicy: Int?
    public let scope: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshExpiresIn = "refresh_expires_in"
        case tokenType = "token_type"
        case notBeforePolicy = "not-before-policy"
        case scope
    }
}
