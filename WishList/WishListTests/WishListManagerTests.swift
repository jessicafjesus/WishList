//
//  WishListManagerTests.swift
//  WishListTests
//
//  Created by Jessica Jesus on 17/02/2026.
//

import XCTest
@testable import WishList

final class WishListManagerTests: XCTestCase {
    var manager = WishListManager()
    var testAttractions: [Attraction] = []
    
    override func setUp() {
        super.setUp()
        manager = WishListManager()
        testAttractions = [MockAttraction().makeExhibitionAttraction(), MockAttraction().makeVenueAttraction()]

    }

    override func tearDown() {
        // Clean up saved file
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("wishlist.json")
        try? fileManager.removeItem(at: fileURL)

        super.tearDown()
    }
    
    func testInit_StartsWithEmptyWishlist() {
        XCTAssertTrue(manager.wishlistItems.isEmpty)
        XCTAssertNil(manager.error)
    }
    
    func testIsInWishlistEmpty() {
        let attraction = testAttractions[0]
        let result = manager.isInWishlist(attraction)
        
        XCTAssertFalse(result)
    }
    
    func testIsInWishlistAttractionExists() {
        let attraction = testAttractions[0]
        manager.addToWishlist(attraction)
        let result = manager.isInWishlist(attraction)
        
        XCTAssertTrue(result)
    }
    
    func testIsInWishlistDifferentAttraction() {
        manager.addToWishlist(testAttractions[0])
        let result = manager.isInWishlist(testAttractions[1])
        
        XCTAssertFalse(result)
    }
    
    func testAddToWishlistSuccess() async {
        let attraction = testAttractions[0]
        XCTAssertFalse(manager.isInWishlist(attraction))
        manager.addToWishlist(attraction)
        
        
        XCTAssertTrue(manager.isInWishlist(attraction))
        XCTAssertEqual(manager.wishlistItems.count, 1)
        XCTAssertEqual(manager.wishlistItems.first?.id, attraction.id)
    }
    
    func testAddToWishlistDuplicate() async {
        let attraction = testAttractions[0]
        manager.addToWishlist(attraction)
        
        manager.addToWishlist(attraction)
        
        
        XCTAssertEqual(manager.wishlistItems.count, 1)
    }
    
    func testRemoveFromWishlistSuccess() async {
        let attraction = testAttractions[0]
        manager.addToWishlist(attraction)
        
        XCTAssertTrue(manager.isInWishlist(attraction))
        manager.removeFromWishlist(attraction)
        
        XCTAssertFalse(manager.isInWishlist(attraction))
        XCTAssertTrue(manager.wishlistItems.isEmpty)
    }
    
    func testRemoveFromWishlistNonExistentAttraction() async {
        manager.addToWishlist(testAttractions[0])
        
        let initialCount = manager.wishlistItems.count
        manager.removeFromWishlist(testAttractions[1])
        
        
        XCTAssertEqual(manager.wishlistItems.count, initialCount)
    }
    
    func testToggleWishlist() async {
        // Add
        let attraction = testAttractions[0]
        XCTAssertFalse(manager.isInWishlist(attraction))
        
        manager.toggleWishlist(attraction)
        XCTAssertTrue(manager.isInWishlist(attraction))
        XCTAssertEqual(manager.wishlistItems.count, 1)
        
        // Remove
        manager.addToWishlist(attraction)
        XCTAssertTrue(manager.isInWishlist(attraction))
        
        manager.toggleWishlist(attraction)
        XCTAssertFalse(manager.isInWishlist(attraction))
        XCTAssertTrue(manager.wishlistItems.isEmpty)
    }
    
    func testSaveEmptyArray() async throws {
        manager.addToWishlist(testAttractions[0])
        manager.removeFromWishlist(testAttractions[0])
        
        Task {
            let loadedItems = try await manager.load()
            XCTAssertTrue(loadedItems.isEmpty)
        }
    }
    
    func testLoadFileDoesNotExist() async throws {
        let newManager = WishListManager()
        Task {
            let items = try await newManager.load()
            XCTAssertTrue(items.isEmpty)
        }
    }
    
    func testLoadCorruptedData() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent("wishlist.json")
        let invalidJSON = "{ invalid json }".data(using: .utf8)!
        Task {
            try invalidJSON.write(to: fileURL)
            let newManager = WishListManager()
            
            XCTAssertNotNil(newManager.error)
            XCTAssertTrue(newManager.wishlistItems.isEmpty)
        }
    }
    
    func testWishlistExhibitionDates() {
        let exhibition = testAttractions[1]
        manager.addToWishlist(exhibition)
        
        Task {
            let loadedItems = try await manager.load()
            let loadedExhibition = loadedItems.first { $0.id == exhibition.id }
            XCTAssertNotNil(loadedExhibition)
            XCTAssertEqual(loadedExhibition?.exhibitionStartDate, "20-02-2026")
            XCTAssertEqual(loadedExhibition?.exhibitionEndDate, "02-03-2026")
        }
    }
}
