//
//  Gallery.swift
//  hackathon
//
//  Created by Timo Blattner on 04.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI
import CoreLocation

struct Gallery: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var location: String
    var country: String
    var latitude: Float
    var longitude: Float
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: CLLocationDegrees(latitude),
            longitude: CLLocationDegrees(longitude))
    }
    var imageName: String
}


struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
