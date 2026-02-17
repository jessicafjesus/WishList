//
//  AttractionDataLoaderProtocol.swift
//  WishList
//
//  Created by Jessica Jesus on 17/02/2026.
//

import Foundation

/// Protocol for loading attraction data from various sources
protocol AttractionDataLoaderProtocol {
    func loadAttractionsFromFile(named filename: String, bundle: Bundle) -> [Attraction]
}
