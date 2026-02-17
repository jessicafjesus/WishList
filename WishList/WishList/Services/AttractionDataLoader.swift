//
//  AttractionDataLoader.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import Foundation
import os

class AttractionDataLoader: AttractionDataLoaderProtocol {
    private let logger = Logger()
    private let mapper: AttractionMapperProtocol
    
    init(mapper: AttractionMapperProtocol = AttractionMapper()) {
        self.mapper = mapper
    }
    
    func loadAttractionsFromFile(named filename: String, bundle: Bundle = .main) -> [Attraction]? {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            let error = AppError.fileNotFound(filename)
            logger.error("Error: \(error.errorDescription ?? "Unknown error")")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(OfferingsResponse.self, from: data)
            return response.items.map { mapper.makeAttraction($0) }
        } catch let error as DecodingError {
            let appError = AppError.decodingFailed(error)
            logger.error("Error: \(appError.errorDescription ?? "Unknown error")")
        } catch {
            let appError = AppError.fileFailedToLoad(filename)
            logger.error("Error: \(appError.errorDescription ?? "Unknown error")")
        }
        
        return nil
    }
}
