//
//  HomeResponse.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 15.04.2026.
//

import Foundation

public struct HomeResponse: Decodable {
    public let time: Int
    public let states: [FlightState]

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        time = try container.decode(Int.self, forKey: .time)
        let rawStates = try container.decode([[RawValue]].self, forKey: .states)
        states = rawStates.compactMap { FlightState(raw: $0) }
    }

    private enum CodingKeys: String, CodingKey {
        case time, states
    }
}

// MARK: - RawValue

enum RawValue: Decodable {
    case string(String)
    case double(Double)
    case int(Int)
    case bool(Bool)
    case null

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil()                          { self = .null }
        else if let v = try? c.decode(Bool.self)  { self = .bool(v) }
        else if let v = try? c.decode(Int.self)   { self = .int(v) }
        else if let v = try? c.decode(Double.self){ self = .double(v) }
        else if let v = try? c.decode(String.self){ self = .string(v) }
        else                                      { self = .null }
    }

    var string: String? {
        if case .string(let v) = self { return v }
        return nil
    }

    var double: Double? {
        switch self {
        case .double(let v): return v
        case .int(let v):    return Double(v)
        default:             return nil
        }
    }

    var bool: Bool? {
        if case .bool(let v) = self { return v }
        return nil
    }
}

// MARK: - FlightState

public struct FlightState {
    public let icao24:         String        // 0
    public let callsign:       String?       // 1  nullable
    public let originCountry:  String        // 2
    public let timePosition:   Int?          // 3  nullable
    public let lastContact:    Int           // 4
    public let longitude:      Double?       // 5  nullable
    public let latitude:       Double?       // 6  nullable
    public let baroAltitude:   Double?       // 7  nullable
    public let onGround:       Bool          // 8
    public let velocity:       Double?       // 9  nullable
    public let trueTrack:      Double?       // 10 nullable
    public let verticalRate:   Double?       // 11 nullable
    // 12: sensors [Int] — nullable, skip
    public let geoAltitude:    Double?       // 13 nullable
    public let squawk:         String?       // 14 nullable
    public let spi:            Bool          // 15
    public let positionSource: Int           // 16 (0=ADS-B, 1=ASTERIX, 2=MLAT, 3=FLARM)
    public let category:       Int?          // 17 bazı response'larda gelmeyebilir

    init?(raw: [RawValue]) {
        guard raw.count >= 17,
              let icao = raw[0].string,
              let country = raw[2].string
        else { return nil }

        icao24         = icao
        callsign       = raw[1].string?.trimmingCharacters(in: .whitespaces)
        originCountry  = country
        timePosition   = raw[3].double.map(Int.init)
        lastContact    = Int(raw[4].double ?? 0)
        longitude      = raw[5].double
        latitude       = raw[6].double
        baroAltitude   = raw[7].double
        onGround       = raw[8].bool ?? false
        velocity       = raw[9].double
        trueTrack      = raw[10].double
        verticalRate   = raw[11].double
        geoAltitude    = raw[13].double
        squawk         = raw[14].string
        spi            = raw[15].bool ?? false
        positionSource = raw[16].double.map(Int.init) ?? 0
        category       = raw.count > 17 ? raw[17].double.map(Int.init) : nil
    }
}
