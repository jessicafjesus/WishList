//
//  AttractionDataLoader.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import Foundation
import os

class AttractionDataLoader {
    private let logger = Logger()
    
    func loadAttractionsFromFile(named filename: String, bundle: Bundle = .main) -> [Attraction] {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            let error = AppError.fileNotFound(filename)
            logger.error("Error: \(error.errorDescription)")
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            let error = AppError.fileFailedToLoad(filename)
            logger.error("Error: \(error.errorDescription)")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(OfferingsResponse.self, from: data)
            return response.items.map { $0.makeAttraction() }
        } catch let error as DecodingError {
            logger.error("Details: \(error.localizedDescription)")
        } catch {
            let error = AppError.fileOperationFailed(error)
            logger.error("Details: \(error.localizedDescription)")
        }
        return []
    }
}
