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
    func makeAttraction() -> Attraction {
        Attraction(
            id: id,
            name: name,
            type: attractionType(),
            description: description(),
            location: location,
            imageURL: image,
            rating: starsRating,
            price: Double(price) ?? 0.0,
            priceCurrency: currency(),
            exhibitionStartDate: startDate,
            exhibitionEndDate: endDate
        )
    }
}

private extension AttractionResponse {
    func attractionType() -> AttractionType {
        switch type.uppercased() {
        case "EXHIBITION": .exhibition
        case "VENUE": .venue
        default: .venue
        }
    }
    
    func currency() -> Currency {
        switch priceCurrencyCode.uppercased() {
        case "EUR": .eur
        case "USD": .usd
        case "GBP": .gbp
        default: .eur
        }
    }
    
    func description() -> String {
        if type == "EXHIBITION", let loc = location, let start = startDate, let end = endDate {
            return "Special exhibition at \(loc)."
        } else if type == "VENUE", let rating = starsRating {
            return "Very interesting attraction with a \(String(format: "%.1f", rating)) star rating."
        } else {
            return "Amazing attraction called \(name)."
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}
