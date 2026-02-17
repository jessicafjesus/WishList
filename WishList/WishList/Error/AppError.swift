//
//  AppError.swift
//  WishList
//
//  Created by Jessica Jesus on 16/02/2026.
//

import Foundation

/// Application-wide error types
enum AppError: LocalizedError {
    case fileNotFound(String)
    case fileFailedToLoad(String)
    case decodingFailed(Error)
    case encodingFailed(Error)
    case fileOperationFailed(Error)
    case invalidData
    
    // note: I don't have anything for the internet unavailability because only the images require internet. When they don't load, a place holder is shown. For the case of switching to API calls to get the events information, I would add that error here.
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "Could not find file: \(filename).json"
        case .fileFailedToLoad(let filename):
            return "Could not load file: \(filename).json"
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode data: \(error.localizedDescription)"
        case .fileOperationFailed(let error):
            return "File operation failed: \(error.localizedDescription)"
        case .invalidData:
            return "The data received is invalid"
        }
    }
}
