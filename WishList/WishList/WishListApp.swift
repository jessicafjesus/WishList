//
//  WishListApp.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import SwiftUI

@main
struct WishListApp: App {
    var body: some Scene {
        WindowGroup {
            AttractionsListView(wishlistViewModel: WishListViewModel(), dataLoader: AttractionDataLoader())
        }
    }
}
