//
//  WishListViewModelTests.swift
//  WishList
//
//  Created by Jessica Jesus on 17/02/26.
//

import XCTest
@testable import WishList

@MainActor
final class WishListViewModelTests: XCTestCase {
    private var viewModel: WishListViewModel?
    private var mockStore: MockWishListStore?

    override func setUp() {
        super.setUp()
        mockStore = MockWishListStore()
        viewModel = WishListViewModel(store: mockStore)
    }

    override func tearDown() {
        viewModel = nil
        mockStore = nil
        super.tearDown()
    }
    
    private func makeviewModel() throws -> (viewModel: WishListViewModel, store: MockWishListStore) {
        let viewModel = try XCTUnwrap(viewModel)
        let store = try XCTUnwrap(mockStore)
        return (viewModel, store)
    }

    func testAttractionNotInList() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        XCTAssertFalse(viewModel.isInWishlist(attraction))
    }

    func testAttractionInList() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.addToWishlist(attraction)
        XCTAssertTrue(viewModel.isInWishlist(attraction))
    }

    func testAddsAttraction() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.addToWishlist(attraction)
        XCTAssertEqual(viewModel.wishlistItems.count, 1)
        XCTAssertEqual(viewModel.wishlistItems.first?.id, attraction.id)
    }

    func testNotAddDuplicate() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.addToWishlist(attraction)
        viewModel.addToWishlist(attraction)
        XCTAssertEqual(viewModel.wishlistItems.count, 1)
    }

    func testRemovesAttraction() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.addToWishlist(attraction)
        viewModel.removeFromWishlist(attraction)
        XCTAssertTrue(viewModel.wishlistItems.isEmpty)
    }

    func testRemoveAttractionNotInList() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.removeFromWishlist(attraction)
        XCTAssertTrue(viewModel.wishlistItems.isEmpty)
    }
    
    func testNotInListAddsAttraction() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.toggleWishlist(attraction)
        XCTAssertTrue(viewModel.isInWishlist(attraction))
    }

    func testInListRemovesAttraction() throws {
        let (viewModel, _) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.addToWishlist(attraction)
        viewModel.toggleWishlist(attraction)
        XCTAssertFalse(viewModel.isInWishlist(attraction))
    }

    func testLoadWishlistSuccess() async throws {
        let (viewModel, mockStore) = try makeviewModel()
        let attractions = [MockAttraction().makeVenueAttraction()]
        mockStore.attractionsToLoad = attractions

        await viewModel.loadWishlist()

        XCTAssertEqual(viewModel.wishlistItems.count, 1)
        XCTAssertNil(viewModel.error)
    }

    func testLoadWishlistFailure() async throws {
        let (viewModel, mockStore) = try makeviewModel()
        mockStore.shouldThrow = true

        await viewModel.loadWishlist()

        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.wishlistItems.isEmpty)
    }

    func testSaveWishlistSuccess() async throws {
        let (viewModel, mockStore) = try makeviewModel()
        let attraction = MockAttraction().makeVenueAttraction()
        viewModel.addToWishlist(attraction)

        await viewModel.saveWishlist()

        XCTAssertEqual(mockStore.savedAttractions?.count, 1)
        XCTAssertEqual(mockStore.savedAttractions?.first?.id, attraction.id)
    }

    func testSaveWishlistFailure() async throws {
        let (viewModel, mockStore) = try makeviewModel()
        mockStore.shouldThrow = true

        await viewModel.saveWishlist()

        XCTAssertNotNil(viewModel.error)
    }
}
