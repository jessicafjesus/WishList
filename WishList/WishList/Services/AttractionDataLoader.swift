//
//  AttractionDataLoader.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import Foundation

class AttractionDataLoader {
    static func loadAttractionsFromFile(named filename: String, bundle: Bundle = .main) -> [Attraction] {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            print("Failed to locate \(filename).json")
            return []
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Failed to load \(filename).json")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(OfferingsResponse.self, from: data)
            return response.items.map { $0.makeAttraction() }
        } catch {
            print("Failed to decode JSON: \(error)")
            if let decodingError = error as? DecodingError {
                print("   Details: \(decodingError)")
            }
            return []
        }
    }
}
