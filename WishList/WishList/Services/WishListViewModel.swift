//
//  WishListViewModel.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import Foundation
import os

@MainActor
@Observable
class WishListViewModel: WishListViewModelProtocol {
    private(set) var wishlistItems: [Attraction] = []
    private(set) var error: AppError?
    
    private let logger = Logger()
    private let store: any WishListStoreProtocol
    
    init(store: WishListStoreProtocol? = nil) {
        if let store {
            self.store = store
        } else {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let documentsDirectory else {
                fatalError("Could not get the documents directory.")
            }
            let fileURL = documentsDirectory.appendingPathComponent("wishlist.json")
            self.store = WishListStore(fileURL: fileURL)
        }
        
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
    
    func loadWishlist() {
        error = nil
        
        do {
            let items = try store.load()
            wishlistItems = items
            logger.info("Loaded \(items.count) items from wishlist")
        } catch {
            self.error = (error as? AppError) ?? AppError.fileOperationFailed(error)
            logger.info("Failed to load wishlist: \(error.localizedDescription)")
        }
    }
    
    func saveWishlist() {
        do {
            try store.save(wishlistItems)
            logger.debug("Saved \(self.wishlistItems.count) items to wishlist")
        } catch {
            self.error = (error as? AppError) ?? AppError.fileOperationFailed(error)
            logger.info("Failed to save wishlist: \(error.localizedDescription)")
        }
    }
}
