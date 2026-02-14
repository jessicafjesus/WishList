//
//  Attraction.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import Foundation

struct OfferingsResponse: Codable {
    let items: [AttractionResponse]
}

struct AttractionResponse: Codable {
    let type: String
    let id: String
    let name: String
    let image: String
    let priceCurrencyCode: String
    let price: String
    let starsRating: Double?
    let location: String?
    let startDate: String?
    let endDate: String?
    
    enum CodingKeys: String, CodingKey {
        case type, id, name, image, price, location
        case priceCurrencyCode = "price_currency_code"
        case starsRating = "stars_rating"
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

extension AttractionResponse {
    func attractionType() -> AttractionType {
        switch type.uppercased() {
        case "EXHIBITION": .exhibition
        case "VENUE": .venue
        default: .venue
        }
    }
    
    func currency() -> Currency {
        switch priceCurrencyCode {
        case "EUR": .eur
        case "USD": .usd
        case "GBP": .gbp
        default: .eur
        }
    }
}
