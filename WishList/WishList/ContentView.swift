//
//  ContentView.swift
//  WishList
//
//  Created by Jessica Jesus on 14/02/2026.
//

import SwiftUI

struct Place: Identifiable, Hashable {
    enum Category: String {
        case museum = "Museum"
        case attraction = "Attraction"

        var iconName: String {
            switch self {
            case .museum:
                return "building.columns"
            case .attraction:
                return "camera.macro"
            }
        }

        var iconColor: Color {
            switch self {
            case .museum:
                return .indigo
            case .attraction:
                return .orange
            }
        }
    }

    let id = UUID()
    let name: String
    let city: String
    let category: Category
}

struct ContentView: View {
    private let places: [Place] = [
        Place(name: "The Louvre", city: "Paris", category: .museum),
        Place(name: "The British Museum", city: "London", category: .museum),
        Place(name: "The Prado", city: "Madrid", category: .museum),
        Place(name: "Colosseum", city: "Rome", category: .attraction),
        Place(name: "Sagrada Família", city: "Barcelona", category: .attraction),
        Place(name: "Eiffel Tower", city: "Paris", category: .attraction)
    ]

    @State private var wishListIDs = Set<UUID>()

    private var wishListPlaces: [Place] {
        places.filter { wishListIDs.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Museums & Attractions") {
                    ForEach(places) { place in
                        PlaceCard(
                            place: place,
                            isInWishList: wishListIDs.contains(place.id),
                            onToggleWishList: { toggleWishList(for: place) }
                        )
                    }
                }

                WishListSection(places: wishListPlaces) { place in
                    toggleWishList(for: place)
                }
            }
            .navigationTitle("Travel Wish List")
        }
    }

    private func toggleWishList(for place: Place) {
        if wishListIDs.contains(place.id) {
            wishListIDs.remove(place.id)
        } else {
            wishListIDs.insert(place.id)
        }
    }
}

struct PlaceCard: View {
    let place: Place
    let isInWishList: Bool
    let onToggleWishList: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: place.category.iconName)
                .foregroundStyle(place.category.iconColor)
                .font(.title3)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(place.name)
                    .font(.headline)
                Text("\(place.city) • \(place.category.rawValue)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(isInWishList ? "Added" : "Add") {
                onToggleWishList()
            }
            .buttonStyle(.borderedProminent)
            .tint(isInWishList ? .green : .blue)
        }
        .padding(.vertical, 4)
    }
}

struct WishListSection: View {
    let places: [Place]
    let onRemove: (Place) -> Void

    var body: some View {
        Section("My Wish List") {
            if places.isEmpty {
                Label("No items yet. Tap Add to start building your list.", systemImage: "heart")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(places) { place in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(place.name)
                            Text(place.city)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Remove") {
                            onRemove(place)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
