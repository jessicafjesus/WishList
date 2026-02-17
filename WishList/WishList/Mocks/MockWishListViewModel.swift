//
//  MockWishListViewModel.swift
//  WishList
//
//  Created by Jessica Jesus on 17/2/26.
//

import Foundation

final class MockWishListViewModel: WishListViewModelProtocol {
    var wishlistItems: [Attraction]
    var error: AppError? = nil
    
    init(store: WishListStoreProtocol? = nil) {
        wishlistItems = [
            MockAttraction().makeExhibitionAttraction(),
            MockAttraction().makeVenueAttraction()
        ]
    }
    
    func isInWishlist(_ attraction: Attraction) -> Bool {
        wishlistItems.contains(where: { $0.id == attraction.id })
    }
    
    func toggleWishlist(_ attraction: Attraction) {
        if let index = wishlistItems.firstIndex(where: { $0.id == attraction.id }) {
            wishlistItems.remove(at: index)
        } else {
            wishlistItems.append(attraction)
        }
    }
    
    func addToWishlist(_ attraction: Attraction) {
        if !isInWishlist(attraction) {
            wishlistItems.append(attraction)
        }
    }
    
    func removeFromWishlist(_ attraction: Attraction) {
        wishlistItems.removeAll(where: { $0.id == attraction.id })
    }
    
    func loadWishlist() async {}
    func saveWishlist() async {}
}
