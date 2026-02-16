//
//  WishListManager.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import Foundation

@Observable
class WishListManager {
    private(set) var wishlistItems: [Attraction]
    
    private let fileName = "wishlist.json"
    
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    init(wishlistItems: [Attraction] = []) {
        self.wishlistItems = wishlistItems
        loadWishlist()
    }
    
    func isInWishlist(_ attraction: Attraction) -> Bool {
        wishlistItems.contains(where: { $0.id == attraction.id })
    }
    
    /// When the user presses it and it's not selected, it's added, if it's selected, it's removed
    ///
    /// - Parameter attraction: Attraction associated with the action
    func toggleWishlist(_ attraction: Attraction) {
        if let index = wishlistItems.firstIndex(where: { $0.id == attraction.id }) {
            wishlistItems.remove(at: index)
        } else {
            wishlistItems.append(attraction)
        }
        saveWishlist()
    }
    
    func addToWishlist(_ attraction: Attraction) {
        if !isInWishlist(attraction) {
            wishlistItems.append(attraction)
            saveWishlist()
        }
    }
    
    func removeFromWishlist(_ attraction: Attraction) {
        if let index = wishlistItems.firstIndex(where: { $0.id == attraction.id }) {
            wishlistItems.remove(at: index)
            saveWishlist()
        }
    }
    
    private func saveWishlist() {
        do {
            let data = try JSONEncoder().encode(wishlistItems)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save wishlist: \(error.localizedDescription)")
        }
    }
    
    private func loadWishlist() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            wishlistItems = try JSONDecoder().decode([Attraction].self, from: data)
        } catch {
            print("Failed to load wishlist: \(error.localizedDescription)")
        }
    }
}
