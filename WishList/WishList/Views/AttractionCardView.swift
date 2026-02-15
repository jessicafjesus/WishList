//
//  AttractionCard.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct AttractionCardView: View {
    let attraction: Attraction
    let isInWishlist: Bool
    let onToggleWishlist: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
                getImage()
                
                Button(action: onToggleWishlist) {
                    Image(systemName: isInWishlist ? "heart.fill" : "heart")
                        .font(.system(size: 22))
                        .foregroundColor(isInWishlist ? .red : .white)
                        .padding(12)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            cardInformation()
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

private extension AttractionCardView {
    func getImage() -> some View {
        AsyncImage(url: URL(string: attraction.imageURL)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            case .failure, .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: attraction.type.icon)
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.5))
                    )
            @unknown default:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .frame(height: 180)
    }
    
    func cardInformation() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: attraction.type.icon)
                    .font(.caption)
                Text(attraction.type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.blue)
            
            Text(attraction.name)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(2)
            if attraction.type == .exhibition, let location = attraction.location {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                    Text(location)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            Text(attraction.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .padding(.top, 4)
            
            HStack {
                if attraction.type == .venue, let rating = attraction.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                        .foregroundColor(.orange)
                } else if let endDate = attraction.exhibitionEndDate {
                    Text("Until \(endDate)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Text(attraction.formattedPrice)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.top, 4)
        }
        .padding(16)
    }
}

struct AttractionCard_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAttraction = Attraction(
            name: "Van Gogh Museum",
            type: .venue,
            description: "One of the world's premier art galleries",
            location: "Amsterdam, Netherlands",
            imageURL: "https://example.com/image.jpg",
            rating: 4.8,
            price: 10.0,
            priceCurrency: .eur,
            exhibitionEndDate: "10/03/2026"
        )
        
        AttractionCardView(
            attraction: sampleAttraction,
            isInWishlist: false,
            onToggleWishlist: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
