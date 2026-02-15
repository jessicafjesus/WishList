//
//  EmptyWishListView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct EmptyWishListView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart.slash")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Your wishlist is empty")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Start exploring and add attractions to your wishlist")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
