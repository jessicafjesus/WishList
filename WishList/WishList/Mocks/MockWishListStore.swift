//
//  MockWishListStore.swift
//  WishList
//
//  Created by Jessica Jesus on 17/2/26.
//

final class MockWishListStore: WishListStoreProtocol {
    var attractionsToLoad: [Attraction] = []
    var savedAttractions: [Attraction]?
    var shouldThrow = false

    func load() throws -> [Attraction] {
        if shouldThrow { throw AppError.fileOperationFailed(MockError.generic) }
        return attractionsToLoad
    }

    func save(_ attractions: [Attraction]) throws {
        if shouldThrow { throw AppError.fileOperationFailed(MockError.generic) }
        savedAttractions = attractions
    }

    enum MockError: Error {
        case generic
    }
}
