//
//  AttractionDetailView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct AttractionDetailView: View {
    private let attraction: Attraction
    private let wishlistViewModel: WishListViewModelProtocol
    
    init(attraction: Attraction, wishlistViewModel: WishListViewModelProtocol) {
        self.attraction = attraction
        self.wishlistViewModel = wishlistViewModel
    }
    
    var isInWishlist: Bool {
        wishlistViewModel.isInWishlist(attraction)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AttractionImageView(imageURL: attraction.imageURL, icon: attraction.type.icon, height: 350)
                
                
                VStack(alignment: .leading, spacing: 20) {
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
                    
                    attractionInfo()
                    
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

                    wishButton()
                }
                .padding(20)
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

private extension AttractionDetailView {
    @ViewBuilder
    func attractionInfo() -> some View {
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
            // Rating if applicable
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
                Text("\(startDate) - \(endDate)")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.purple.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    func wishButton() -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                wishlistViewModel.toggleWishlist(attraction)
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
}

struct AttractionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAttraction = MockAttraction().makeExhibitionAttraction()
        
        NavigationView {
            AttractionDetailView(
                attraction: sampleAttraction,
                wishlistViewModel: WishListViewModel()
            )
        }
    }
}
