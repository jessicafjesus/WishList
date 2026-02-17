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
    
    private let wishlistViewModel: WishListViewModelProtocol
    private let dataLoader: any AttractionDataLoaderProtocol
    
    init(wishlistViewModel: WishListViewModelProtocol, dataLoader: AttractionDataLoaderProtocol) {
        self.wishlistViewModel = wishlistViewModel
        self.dataLoader = dataLoader
    }
    
    var filteredAttractions: [Attraction] {
        let byType: [Attraction]
        if let selectedType = selectedType {
            byType = attractions.filter { $0.type == selectedType }
        } else {
            byType = attractions
        }

        guard !searchText.isEmpty else { return byType }

        let text = searchText
        let bySearch = byType.filter { attraction in
            let nameMatch = attraction.name.localizedCaseInsensitiveContains(text)
            let descMatch = attraction.description.localizedCaseInsensitiveContains(text)
            let typeMatch = attraction.type.rawValue.localizedCaseInsensitiveContains(text)
            return nameMatch || descMatch || typeMatch
        }
        return bySearch
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    statusBanner()
                    
                    HStack(spacing: 12) {
                        ForEach(attractionTypes(), id: \.self) { type in
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
            .background(Color.gray.opacity(0.05))
            .navigationTitle("Explore")
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search attractions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: WishListView(wishlistViewModel: wishlistViewModel)) {
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
    // We could add more but it would appear in a filter type of way. Since here it's only 2, I'm going to show all of them
    func attractionTypes() -> [AttractionType] {
        let types = attractions.map { $0.type }
        let unique = Set(types)
        return unique.sorted { $0.rawValue < $1.rawValue }
    }
    
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
                    wishlistViewModel: wishlistViewModel
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
                .buttonStyle(.plain)
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

