//
//  AttractionType.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import Foundation

enum AttractionType: String, Codable {
    case exhibition = "Exhibition"
    case venue = "Venue"
    
    var icon: String {
        switch self {
        case .exhibition: return "photo.fill"
        case .venue: return "mappin.circle.fill"
        }
    }
}
