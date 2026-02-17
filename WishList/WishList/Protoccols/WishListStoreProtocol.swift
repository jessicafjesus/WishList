//
//  WishListStoreProtocol.swift
//  WishList
//
//  Created by Jessica Jesus on 17/2/26.
//

protocol WishListStoreProtocol {
    func load() async throws -> [Attraction]
    func save(_ attractions: [Attraction]) async throws
}
