//
//  ImageView.swift
//  WishList
//
//  Created by Jessica Jesus on 16/02/2026.
//

import SwiftUI

struct AttractionImageView: View {
    private let imageURL: String
    private let icon: String
    private let height: CGFloat
    
    init(imageURL: String, icon: String, height: CGFloat) {
        self.imageURL = imageURL
        self.icon = icon
        self.height = height
    }
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
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
                        Image(systemName: icon)
                            .font(.system(size: 80))
                            .foregroundColor(.gray.opacity(0.5))
                    )
            @unknown default:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .frame(height: height)
    }
}
