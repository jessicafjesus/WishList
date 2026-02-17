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
    case decodingFailed(Error)
    case encodingFailed(Error)
    case fileOperationFailed(Error)
    case networkUnavailable
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "Could not find file: \(filename)"
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .encodingFailed(let error):
            return "Failed to encode data: \(error.localizedDescription)"
        case .fileOperationFailed(let error):
            return "File operation failed: \(error.localizedDescription)"
        case .networkUnavailable:
            return "Network connection unavailable"
        case .invalidData:
            return "The data received is invalid"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .fileNotFound:
            return "Please check that the file exists in your app bundle."
        case .networkUnavailable:
            return "Please check your internet connection and try again."
        case .decodingFailed, .invalidData:
            return "The data format may have changed. Please contact support."
        default:
            return "Please try again or contact support if the problem persists."
        }
    }
}
