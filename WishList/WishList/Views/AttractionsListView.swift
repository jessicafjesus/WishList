//
//  AttractionsListView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

struct AttractionsListView: View {
    @State private var wishlistManager = WishListManager()
    @State private var searchText = ""
    @State private var selectedType: AttractionType?
    
    let attractions: [Attraction] = AttractionDataLoader().loadAttractionsFromFile(named: "offerings")
    
    // We could add more but it would appear in a filter type of way. Since here it's only 2, I'm going to show all of them
    var attractionTypes: [AttractionType] {
        let typeCounts = Dictionary(grouping: attractions, by: { $0.type })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
        
        return typeCounts.prefix(2).map { $0.key }
    }
    
    var filteredAttractions: [Attraction] {
        var result = attractions
        
        // Filter by type
        if let selectedType = selectedType {
            result = result.filter { $0.type == selectedType }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            result = result.filter { attraction in
                attraction.name.localizedCaseInsensitiveContains(searchText) ||
                attraction.description.localizedCaseInsensitiveContains(searchText) ||
                attraction.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 12) {
                        ForEach(attractionTypes, id: \.self) { type in
                            filterChip(
                                type: type,
                                isSelected: selectedType == type,
                                onTap: {
                                    withAnimation {
                                        if selectedType == type {
                                            selectedType = nil
                                        } else {
                                            selectedType = type
                                        }
                                    }
                                }
                            )
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    attractionsList()
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Explore")
            .searchable(text: $searchText, prompt: "Search attractions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: WishListView(wishlistManager: wishlistManager)) {
                        Image(systemName: "heart.circle.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

// MARK: - Private Extensions
private extension AttractionsListView {
    func filterChip(type: AttractionType, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: type.icon)
                    .font(.caption)
                Text(type.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .indigo)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.indigo : Color.indigo.opacity(0.1))
            .cornerRadius(20)
        }
    }
    
    func attractionsList() -> some View {
        LazyVStack(spacing: 16) {
            ForEach(filteredAttractions) { attraction in
                NavigationLink(destination: AttractionDetailView(
                    attraction: attraction,
                    wishlistManager: wishlistManager
                )) {
                    AttractionCardView(
                        attraction: attraction,
                        isInWishlist: wishlistManager.isInWishlist(attraction),
                        onToggleWishlist: {
                            withAnimation(.spring(response: 0.3)) {
                                wishlistManager.toggleWishlist(attraction)
                            }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
    }
}

struct AttractionsListView_Previews: PreviewProvider {
    static var previews: some View {
        AttractionsListView()
    }
}
