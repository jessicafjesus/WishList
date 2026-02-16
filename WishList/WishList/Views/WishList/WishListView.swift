//
//  WishlistView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct WishListView: View {
    private var wishlistManager: WishListManager
    @State private var selectedAttraction: Attraction?
    
    init(wishlistManager: WishListManager) {
        self.wishlistManager = wishlistManager
    }
    
    var body: some View {
        Group {
            if wishlistManager.wishlistItems.isEmpty {
                EmptyWishListView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        VStack(spacing: 12) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                            
                            Text("Your Wishlist")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("\(wishlistManager.wishlistItems.count) attraction\(wishlistManager.wishlistItems.count == 1 ? "" : "s") saved")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        makeWishCards()
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Wishlist")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func makeWishCards() -> some View {
        LazyVStack(spacing: 16) {
            ForEach(wishlistManager.wishlistItems) { attraction in
                NavigationLink(destination: AttractionDetailView(
                                    attraction: attraction,
                                    wishlistManager: wishlistManager
                )) {
                    WishListCardView(
                        attraction: attraction,
                        onRemove: {
                            withAnimation(.spring(response: 0.3)) {
                                wishlistManager.removeFromWishlist(attraction)
                            }
                        }
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedAttraction = attraction
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}


struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WishListView(wishlistManager: WishListManager())
        }
    }
}
