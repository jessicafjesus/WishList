//
//  AttractionMapper.swift
//  WishList
//
//  Created by Jessica Jesus on 16/02/2026.
//

import Foundation

/// Handles mapping from API response models to domain models
struct AttractionMapper: AttractionMapperProtocol {
    /// Converts an AttractionResponse to an Attraction domain model
    func makeAttraction(_ response: AttractionResponse) -> Attraction {
        Attraction(
            id: response.id,
            name: response.name,
            type: attractionType(response.type),
            description: description(for: response),
            location: response.location,
            imageURL: response.image,
            rating: response.starsRating,
            price: Double(response.price) ?? 0.0,
            priceCurrency: currency(response.priceCurrencyCode),
            exhibitionStartDate: response.startDate,
            exhibitionEndDate: response.endDate
        )
    }
    
    func attractionType(_ type: String) -> AttractionType {
        switch type.uppercased() {
        case "EXHIBITION": .exhibition
        case "VENUE": .venue
        default: .venue
        }
    }
    
    func currency(_ currencyCode: String) -> Currency {
        switch currencyCode.uppercased() {
        case "EUR": .eur
        case "USD": .usd
        case "GBP": .gbp
        default: .eur
        }
    }
    
    func description(for response: AttractionResponse) -> String {
        if response.type == "EXHIBITION", let loc = response.location, let start = response.startDate, let end = response.endDate {
            return "Special exhibition at \(loc)."
        } else if response.type == "VENUE", let rating = response.starsRating {
            return "Very interesting attraction with a \(String(format: "%.1f", rating)) star rating."
        } else {
            return "Amazing attraction called \(response.name)."
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
