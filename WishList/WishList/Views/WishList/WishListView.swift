//
//  WishlistView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct WishListView: View {
    private var wishlistViewModel: WishListViewModelProtocol
    
    init(wishlistViewModel: WishListViewModelProtocol) {
        self.wishlistViewModel = wishlistViewModel
    }
    
    var body: some View {
        Group {
            if wishlistViewModel.wishlistItems.isEmpty {
                VStack(spacing: 12) {
                    if let wishlistError = wishlistViewModel.error {
                        Text(wishlistError.errorDescription ?? "Unknown error")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    EmptyWishListView()
                }
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        if let wishlistError = wishlistViewModel.error {
                            Text(wishlistError.errorDescription ?? "Unknown error")
                                .font(.footnote)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }
                        
                        VStack(spacing: 12) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                            
                            Text("Your Wishlist")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("\(wishlistViewModel.wishlistItems.count) attraction\(wishlistViewModel.wishlistItems.count == 1 ? "" : "s") saved")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        makeWishCards()
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.gray.opacity(0.05))
        .navigationTitle("Wishlist")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func makeWishCards() -> some View {
        LazyVStack(spacing: 16) {
            ForEach(wishlistViewModel.wishlistItems) { attraction in
                NavigationLink(destination: AttractionDetailView(
                    attraction: attraction,
                    wishlistViewModel: wishlistViewModel
                )) {
                    WishListCardView(
                        attraction: attraction,
                        onRemove: {
                            withAnimation(.spring(response: 0.3)) {
                                wishlistViewModel.removeFromWishlist(attraction)
                            }
                        }
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}


struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WishListView(wishlistViewModel: WishListViewModel())
        }
    }
}
