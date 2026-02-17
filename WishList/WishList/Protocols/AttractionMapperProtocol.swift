//
//  AttractionMapperProtocol.swift
//  WishList
//
//  Created by Jessica Jesus on 17/02/2026.
//

import Foundation

/// Protocol for mapping API responses to domain models
protocol AttractionMapperProtocol {
    func makeAttraction(_ response: AttractionResponse) -> Attraction
}
