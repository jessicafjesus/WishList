//
//  AttractionsListView.swift
//  WishList
//
//  Created by Jessica Jesus on 15/02/2026.
//

import SwiftUI

@MainActor
struct AttractionsListView: View {
    @State private var searchText = ""
    @State private var selectedType: AttractionType?
    @State private var loadError: AppError? = nil
    @State private var isLoading = true
    @State private var attractions: [Attraction] = []
    
    private let wishlistViewModel: any WishListViewModelProtocol
    private let dataLoader: any AttractionDataLoaderProtocol
    
    init(wishlistViewModel: WishListViewModelProtocol, dataLoader: AttractionDataLoaderProtocol) {
        self.wishlistViewModel = wishlistViewModel
        self.dataLoader = dataLoader
    }
    
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
                    statusBanner()
                    
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
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search attractions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: WishListView(wishlistManager: wishlistViewModel)) {
                        Image(systemName: "heart.circle.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            loadAttractions()
        }
    }
}

// MARK: - Private Extensions
private extension AttractionsListView {
    func loadAttractions() {
        let filename = "offerings"
        let items = dataLoader.loadAttractionsFromFile(named: filename, bundle: .main)
        guard let items else {
            self.loadError = .fileFailedToLoad(filename)
            return
        }
        
        attractions = items
        isLoading = false
    }
    
    @ViewBuilder
    func statusBanner() -> some View {
        if isLoading {
            HStack(spacing: 8) {
                ProgressView()
                Text("Loading attractions...")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        } else if let loadError {
            Text(loadError.errorDescription ?? "Unknown error")
                .font(.footnote)
                .foregroundColor(.red)
                .padding(.horizontal)
        }
        
        if let wishlistError = wishlistViewModel.error {
            Text(wishlistError.errorDescription ?? "Unknown error")
                .font(.footnote)
                .foregroundColor(.red)
                .padding(.horizontal)
        }
    }
    
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
                    wishlistManager: wishlistViewModel
                )) {
                    AttractionCardView(
                        attraction: attraction,
                        isInWishlist: wishlistViewModel.isInWishlist(attraction),
                        onToggleWishlist: {
                            withAnimation(.spring(response: 0.3)) {
                                wishlistViewModel.toggleWishlist(attraction)
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
        AttractionsListView(wishlistViewModel: WishListViewModel(), dataLoader: AttractionDataLoader())
    }
}

