//
//  AttractionMapperTests.swift
//  WishList
//
//  Created by Jessica Jesus on 17/02/26.
//

import XCTest
@testable import WishList

final class AttractionMapperTests: XCTestCase {
    private var mapper: AttractionMapper!
    
    override func setUp() {
        super.setUp()
        mapper = AttractionMapper()
    }
    
    override func tearDown() {
        mapper = nil
        super.tearDown()
    }
    
    func testMakeAttractionVenue() {
        let response = makeVenueResponse()
        let attraction = mapper.makeAttraction(response)
        
        XCTAssertEqual(attraction.id, "venue-123")
        XCTAssertEqual(attraction.name, "Van Gogh Museum")
        XCTAssertEqual(attraction.type, .venue)
        XCTAssertEqual(attraction.location, "Amsterdam")
        XCTAssertEqual(attraction.imageURL, "https://example.com/image.jpg")
        XCTAssertEqual(attraction.rating, 4.8)
        XCTAssertEqual(attraction.price, 10.0)
        XCTAssertEqual(attraction.priceCurrency, .eur)
        XCTAssertNil(attraction.exhibitionStartDate)
        XCTAssertNil(attraction.exhibitionEndDate)
    }
    
    func testMakeAttractionExhibition() {
        let response = makeExhibitionResponse()
        let attraction = mapper.makeAttraction(response)
        
        XCTAssertEqual(attraction.id, "exhibition-321")
        XCTAssertEqual(attraction.name, "Erratic Growth")
        XCTAssertEqual(attraction.type, .exhibition)
        XCTAssertEqual(attraction.exhibitionStartDate, "01-02-2025")
        XCTAssertEqual(attraction.exhibitionEndDate, "30-06-2025")
    }
    
    func testAttractionType() {
        XCTAssertEqual(mapper.attractionType("EXHIBITION"), .exhibition)
        XCTAssertEqual(mapper.attractionType("VENUE"), .venue)
    }
    
    func testCurrency() {
        XCTAssertEqual(mapper.currency("EUR"), .eur)
        XCTAssertEqual(mapper.currency("USD"), .usd)
        XCTAssertEqual(mapper.currency("GBP"), .gbp)
    }
    
    func testFormatDate() {
        XCTAssertEqual(mapper.formatDate("2025-06-30"), "30-06-2025")
    }
}

private extension AttractionMapperTests {
    func makeVenueResponse(starsRating: Double? = 4.8) -> AttractionResponse {
        AttractionResponse(
            type: "VENUE",
            id: "123",
            name: "Van Gogh Museum",
            image: "https://example.com/image.jpg",
            priceCurrencyCode: "EUR",
            price: "10.00",
            starsRating: starsRating,
            location: "Amsterdam",
            startDate: nil,
            endDate: nil
        )
    }

    func makeExhibitionResponse(location: String? = "Van Gogh Museum") -> AttractionResponse {
        AttractionResponse(
            type: "EXHIBITION",
            id: "321",
            name: "Erratic Growth",
            image: "https://example.com/image.jpg",
            priceCurrencyCode: "EUR",
            price: "5.5",
            starsRating: nil,
            location: location,
            startDate: "2025-02-01",
            endDate: "2025-06-30"
        )
    }
}
