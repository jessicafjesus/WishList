//
//  AttractionDetailView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct AttractionDetailView: View {
    let attraction: Attraction
    var wishlistManager: WishListManager
    
    var isInWishlist: Bool {
        wishlistManager.isInWishlist(attraction)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image
                AsyncImage(url: URL(string: attraction.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: attraction.type.icon)
                                    .font(.system(size: 80))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Type badge
                    HStack {
                        Image(systemName: attraction.type.icon)
                            .font(.caption)
                        Text(attraction.type.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                    
                    // Title
                    Text(attraction.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if attraction.type == .venue, let location = attraction.location {
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            Text(location)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack(spacing: 24) {
                        if attraction.type == .venue, let rating = attraction.rating {
                            HStack(spacing: 6) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.orange)
                                Text(String(format: "%.1f", rating))
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "banknote.fill")
                                .foregroundColor(.green)
                            Text(attraction.formattedPrice)
                                .fontWeight(.semibold)
                        }
                    }
                    .font(.subheadline)
                    
                    // Exhibition dates if applicable
                    if attraction.type == .exhibition,
                       let startDate = attraction.exhibitionStartDate,
                       let endDate = attraction.exhibitionEndDate {
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .foregroundColor(.purple)
                            Text("\(formatDate(startDate)) - \(formatDate(endDate))")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(attraction.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    // Wishlist button
                    Button(action: {
                        withAnimation(.spring(response: 0.3)) {
                            wishlistManager.toggleWishlist(attraction)
                        }
                    }) {
                        HStack {
                            Image(systemName: isInWishlist ? "heart.fill" : "heart")
                                .font(.title3)
                            Text(isInWishlist ? "Remove from Wishlist" : "Add to Wishlist")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isInWishlist ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.top, 8)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }
}

struct AttractionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAttraction = Attraction(
            name: "Van Gogh Museum",
            type: .exhibition,
            description: "One of the world's premier art galleries",
            location: "Amsterdam, Netherlands",
            imageURL: "https://example.com/image.jpg",
            rating: 4.8,
            price: 10.0,
            priceCurrency: .eur
        )
        
        NavigationView {
            AttractionDetailView(
                attraction: sampleAttraction,
                wishlistManager: WishListManager()
            )
        }
    }
}
