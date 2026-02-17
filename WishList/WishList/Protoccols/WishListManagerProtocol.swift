//
//  WishListManagerProtocol.swift
//  WishList
//
//  Created by Jessica Jesus on 17/02/2026.
//

import Foundation

/// Protocol defining wishlist management operations
protocol WishListManagerProtocol {
    /// The current items in the wishlist
    var wishlistItems: [Attraction] { get }
    
    /// Any error that occurred during wishlist operations
    var error: AppError? { get }
    
    /// Checks if an attraction is in the wishlist
    /// - Parameter attraction: The attraction to check
    /// - Returns: True if the attraction is in the wishlist
    func isInWishlist(_ attraction: Attraction) -> Bool
    
    /// Toggles an attraction in/out of the wishlist
    /// - Parameter attraction: The attraction to toggle
    func toggleWishlist(_ attraction: Attraction)
    
    /// Adds an attraction to the wishlist
    /// - Parameter attraction: The attraction to add
    func addToWishlist(_ attraction: Attraction)
    
    /// Removes an attraction from the wishlist
    /// - Parameter attraction: The attraction to remove
    func removeFromWishlist(_ attraction: Attraction)
    
    /// Saves attractions to persistent storage
    /// - Parameter attractions: The attractions to save
    func save(_ attractions: [Attraction]) async throws
    
    /// Loads attractions from persistent storage
    /// - Returns: Array of saved attractions
    func load() async throws -> [Attraction]
}
