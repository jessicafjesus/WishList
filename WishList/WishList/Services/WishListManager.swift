//
//  WishListManager.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import Foundation
import os

@Observable
class WishListManager: WishListManagerProtocol {
    // Singleton
    static let shared = WishListManager()
    
    private(set) var wishlistItems: [Attraction] = []
    private(set) var error: AppError?
    
    private let fileName = "wishlist.json"
    private let logger = Logger()
    
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    init() {
        Task {
            await loadWishlist()
        }
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
        Task {
            await saveWishlist()
        }
    }
    
    func addToWishlist(_ attraction: Attraction) {
        if !isInWishlist(attraction) {
            wishlistItems.append(attraction)
            Task {
                await saveWishlist()
            }
        }
    }
    
    func removeFromWishlist(_ attraction: Attraction) {
        if let index = wishlistItems.firstIndex(where: { $0.id == attraction.id }) {
            wishlistItems.remove(at: index)
            Task {
                await saveWishlist()
            }
        }
    }
    
    // In this case, I'm saving the information about the wish list in a json file, but this could be easily changed by an api call
    func save(_ attractions: [Attraction]) async throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(attractions)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch let error as EncodingError {
            throw AppError.encodingFailed(error)
        } catch {
            throw AppError.fileOperationFailed(error)
        }
    }
    
    func load() async throws -> [Attraction] {
        // File doesn't exist yet - return empty array (first launch)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode([Attraction].self, from: data)
        } catch let error as DecodingError {
            throw AppError.decodingFailed(error)
        } catch {
            throw AppError.fileOperationFailed(error)
        }
    }
}

private extension WishListManager {
    func loadWishlist() async {
        error = nil
        
        do {
            let items = try await load()
            wishlistItems = items
            logger.info("Loaded \(items.count) items from wishlist")
        } catch {
            self.error = AppError.fileOperationFailed(error)
            logger.info("Failed to load wishlist: \(error.localizedDescription)")
        }
    }
    
    func saveWishlist() async {
        do {
            try await save(wishlistItems)
            logger.debug("Saved \(wishlistItems.count) items to wishlist")
        } catch {
            self.error = AppError.fileOperationFailed(error)
            logger.info("Failed to save wishlist: \(error.localizedDescription)")
        }
    }
}
