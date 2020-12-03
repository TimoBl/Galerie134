//
//  Painting.swift
//  hackathon
//
//  Created by Timo Blattner on 04.04.20.
//  Copyright © 2020 Timo Blattner. All rights reserved.
//

import SwiftUI

struct Painting: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var imageName: String
    var description: String
    var artist: String
    var artistID: Int
    var galleryID: Int
    var category: Category
    var width: Int //real width in cm
    var height: Int //real height in cm
    
    enum Category: String, CaseIterable, Codable, Hashable {
        case expressionism = "Expressionism"
        case abstract = "Abstract"
        case symbolism = "Symbolism"
    }
    
}

