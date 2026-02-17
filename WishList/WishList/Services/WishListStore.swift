//
//  WishListStore.swift
//  WishList
//
//  Created by Jessica Jesus on 17/02/2026.
//

import Foundation

actor WishListStore: WishListStoreProtocol {
    private let fileURL: URL
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func load() throws -> [Attraction] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Attraction].self, from: data)
        } catch let error as DecodingError {
            throw AppError.decodingFailed(error)
        } catch {
            throw AppError.fileOperationFailed(error)
        }
    }
    
    func save(_ attractions: [Attraction]) throws {
        do {
            let data = try JSONEncoder().encode(attractions)
            try data.write(to: fileURL, options: [.atomic])
        } catch let error as EncodingError {
            throw AppError.encodingFailed(error)
        } catch {
            throw AppError.fileOperationFailed(error)
        }
    }
}
