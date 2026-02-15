//
//  WishListManager.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import Foundation

@Observable
class WishListManager {
    private(set) var wishlistItems: Set<UUID>
    
    private let userDefaultsKey = "wishlistItems"
    
    init(wishlistItems: Set<UUID> = []) {
        self.wishlistItems = wishlistItems
        loadWishlist()
    }
    
    func isInWishlist(_ attraction: Attraction) -> Bool {
        wishlistItems.contains(attraction.id)
    }
    
    func toggleWishlist(_ attraction: Attraction) {
        if wishlistItems.contains(attraction.id) {
            wishlistItems.remove(attraction.id)
        } else {
            wishlistItems.insert(attraction.id)
        }
        saveWishlist()
    }
    
    func addToWishlist(_ attraction: Attraction) {
        wishlistItems.insert(attraction.id)
        saveWishlist()
    }
    
    func removeFromWishlist(_ attraction: Attraction) {
        wishlistItems.remove(attraction.id)
        saveWishlist()
    }
    
    private func saveWishlist() {
        let idsArray = Array(wishlistItems).map { $0.uuidString }
        UserDefaults.standard.set(idsArray, forKey: userDefaultsKey)
    }
    
    private func loadWishlist() {
        guard let idsArray = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] else {
            return
        }
        wishlistItems = Set(idsArray.compactMap { UUID(uuidString: $0) })
    }
}
