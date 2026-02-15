//
//  Attraction.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import Foundation

struct Attraction: Identifiable {
    let id: UUID
    let name: String
    let type: AttractionType
    let description: String
    let location: String?
    let imageURL: String
    let rating: Double?
    let price: Double
    let priceCurrency: Currency
    let exhibitionStartDate: String?
    let exhibitionEndDate: String?
    
    init(id: UUID = UUID(), name: String, type: AttractionType, description: String, location: String?, imageURL: String, rating: Double? = nil, price: Double = 0.0, priceCurrency: Currency = .eur, exhibitionStartDate: String? = nil, exhibitionEndDate: String? = nil) {
        self.id = id
        self.name = name
        self.type = type
        self.description = description
        self.location = location
        self.imageURL = imageURL
        self.rating = rating
        self.price = price
        self.priceCurrency = priceCurrency
        self.exhibitionStartDate = exhibitionStartDate
        self.exhibitionEndDate = exhibitionEndDate
    }
    
    var formattedPrice: String {
        if price == 0 {
            return "Free"
        }
        
        switch priceCurrency {
        case .eur:
            return "\(String(format: "%.2f", price)) \(priceCurrency.rawValue) "
        case .usd, .gbp:
            return "\(priceCurrency.rawValue) \(String(format: "%.2f", price))"
        }
    }
}
