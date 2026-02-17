//
//  WishListStoreProtocol.swift
//  WishList
//
//  Created by Jessica Jesus on 17/2/26.
//

protocol WishListStoreProtocol {
    func load() throws -> [Attraction]
    func save(_ attractions: [Attraction]) throws
}
