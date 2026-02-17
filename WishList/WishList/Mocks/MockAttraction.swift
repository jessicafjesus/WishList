//
//  MockAttraction.swift
//  WishList
//
//  Created by Jessica Jesus on 17/02/2026.
//

import Foundation

struct MockAttraction {
    func makeVenueAttraction(price: Double? = nil, currency: Currency = .eur) -> Attraction {
        Attraction(
            id: "id1",
            name: "Van Gogh Museum",
            type: .venue,
            description: "Art museum with masterpieces",
            location: "Amsterdam",
            imageURL: "https://example.com/id1.jpg",
            rating: 4.8,
            price: 10.0,
            priceCurrency: .eur
        )
    }
    
    func makeExhibitionAttraction() -> Attraction {
        Attraction(
            id: "id2",
            name: "Surinamese School: Painting from Paramaribo to Amsterdam",
            type: .exhibition,
            description: "Art museum with masterpieces",
            imageURL: "https://example.com/id2.jpg",
            price: 10.0,
            priceCurrency: .eur,
            exhibitionStartDate: "20-02-2026",
            exhibitionEndDate: "02-03-2026"
        )
    }
}
