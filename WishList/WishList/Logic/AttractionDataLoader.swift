//
//  AttractionAPI.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import Foundation

class AttractionDataLoader {
    static func loadAttractionsFromFile(named filename: String, bundle: Bundle = .main) -> [AttractionResponse] {
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
            let response = try decoder.decode(AttractionResponse.self, from: data)
            return response
        } catch {
            print("Failed to decode JSON: \(error)")
            return []
        }
    }
}

private extension AttractionDataLoader {
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}
