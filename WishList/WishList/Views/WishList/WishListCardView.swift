//
//  WishListCardView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct WishListCardView: View {
    let attraction: Attraction
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            AttractionImageView(imageURL: attraction.imageURL, icon: attraction.type.icon, height: 100)
            
            cardInformation()
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

private extension WishListCardView {
    func cardInformation() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(attraction.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                Spacer()
                Button(action: onRemove) {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
            HStack(spacing: 4) {
                Image(systemName: attraction.type.icon)
                    .font(.caption2)
                Text(attraction.type.rawValue)
                    .font(.caption)
            }
            .foregroundColor(.blue)
            .padding(.bottom, 10)
            
            HStack {
                if attraction.type == .venue, let rating = attraction.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
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
            }
        }
    }
}

struct WishListCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleAttraction = MockAttraction().makeVenueAttraction()
        
        WishListCardView(
            attraction: sampleAttraction,
            onRemove: {}
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

