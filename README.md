# WishList

A SwiftUI iOS app for browsing and saving Amsterdam attractions and exhibitions to a personal wishlist.

## Features

- Browse venues and exhibitions loaded from a local JSON file
- Filter by type (Venue or Exhibition) and search by name or description
- View attraction details including price, rating, location, and exhibition dates
- Add and remove attractions from your wishlist
- Wishlist is persisted locally between sessions

## Requirements

- iOS 16+
- Xcode 15+
- Swift 5.9+

## Architecture

The app is built on MVVM-ish, with extra separation for data loading, mapping, and persistence.

`WishListViewModel` owns the wishlist state and is marked `@Observable` so SwiftUI picks up changes automatically. Views just render state and forward actions — no business logic lives there.

Dependencies are injected via protocols (`WishListStoreProtocol`, `AttractionDataLoaderProtocol`, `AttractionMapperProtocol`), so nothing is tightly coupled to a concrete implementation. This makes testing straightforward and swapping the local JSON for a network call in the future pretty painless.

`AttractionDataLoader` reads the bundled JSON and hands off mapping to `AttractionMapper`, which converts raw response models into domain `Attraction` objects. `WishListStore` handles persistence separately, reading and writing a JSON file in the app's documents directory.

## Testing

Unit tests cover the three core components:

- `AttractionMapperTests` — type mapping, currency mapping, description logic for all branches, and date reformatting.
- `AttractionTests` — composite ID generation and formatted price output across all currencies.
- `WishListViewModelTests` — all wishlist operations (add, remove, toggle, duplicate prevention) and load/save behaviour against a `MockWishListStore`, including failure paths.

## Data

Attractions come from offerings.json bundled with the app. Each item is either a VENUE or an EXHIBITION. Since the source data can have the same numeric ID across different types, the app builds a composite ID in the format TYPE-id (e.g. VENUE-123, EXHIBITION-123) to avoid collisions. Ideally this would be handled upstream, either by the API sending unique IDs or by using UUIDs, but kept simple for now.

## Notes

- Images are fetched remotely via `AsyncImage`. No internet just means a placeholder icon — the rest of the app works fine since attraction data is local.
- Wishlist data lives in the app's documents directory as `wishlist.json`.
- I also didn't add localisables, but in a normal app, it would have them.
