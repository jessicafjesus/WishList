//
//  WishlistView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct WishListView: View {
    var wishlistManager: WishListManager
    let attractions: [Attraction]
    
    var wishlistAttractions: [Attraction] {
        attractions.filter { wishlistManager.isInWishlist($0) }
    }
    
    var body: some View {
        Group {
            if wishlistAttractions.isEmpty {
                EmptyWishListView()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        // Header card
                        VStack(spacing: 12) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.red)
                            
                            Text("Your Wishlist")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("\(wishlistAttractions.count) attraction\(wishlistAttractions.count == 1 ? "" : "s") saved")
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
                }
            }
        }
        .navigationTitle("Wishlist")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func makeWishCards() -> some View {
        LazyVStack(spacing: 16) {
            ForEach(wishlistAttractions) { attraction in
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
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
        }
    .padding(.bottom, 20)
    }
}



struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAttractions = [
            Attraction(
                name: "Van Gogh Museum",
                type: .exhibition,
                description: "World-class art gallery",
                location: "Amsterdam, Netherlands",
                imageURL: "https://example.com/image.jpg",
                rating: 4.8,
                price: 10.0,
                priceCurrency: .eur,
                exhibitionEndDate: "10/03/2026"
            )
        ]
        
        NavigationView {
            //force unwrap the first sample bc it's a sample and I know the first element exists
            WishListView(
                wishlistManager: WishListManager(),
                attractions: sampleAttractions
            )
        }
    }
}
