//
//  BoundingBoxModel.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 16.04.2026.
//

import MapKit

struct BoundingBox {
    let lamin: Double // min latitude
    let lomin: Double // min longitude
    let lamax: Double // max latitude
    let lomax: Double // max longitude

    init(region: MKCoordinateRegion) {
        lamin = region.center.latitude  - region.span.latitudeDelta  / 2
        lomin = region.center.longitude - region.span.longitudeDelta / 2
        lamax = region.center.latitude  + region.span.latitudeDelta  / 2
        lomax = region.center.longitude + region.span.longitudeDelta / 2
    }
}
