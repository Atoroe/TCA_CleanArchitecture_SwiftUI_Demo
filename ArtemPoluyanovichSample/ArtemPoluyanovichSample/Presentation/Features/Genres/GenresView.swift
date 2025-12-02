//
//  GenresView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import SwiftUI

// MARK: - GenresView
struct GenresView: View {
    @Bindable var store: StoreOf<GenresFeature>

    // MARK: Body
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            contentView
                .standardNavigationStyle(title: Localization.title)
                .toast(
                    errorMessage: store.errorMessage,
                    showToast: store.showToast,
                    onDismiss: { store.send(.toastDismissed) }
                )
                .onAppear {
                    store.send(.onAppear)
                }
        } destination: { store in
            GamesView(store: store)
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
    
    // MARK: Private properties
    @ViewBuilder
    private var contentView: some View {
        if store.isEmpty {
            EmptyStateView(
                title: String(localized: Localization.emptyTitle),
                message: String(localized: Localization.emptyMessage)
            )
        } else {
            listView
        }
    }
    
    private var indexedGenres: [(Int, Genre)] {
        store.genres.enumerated().map { ($0.offset, $0.element) }
    }
    
    private var listView: some View {
        List {
            ForEach(indexedGenres, id: \.1.id) { index, genre in
                rowView(index: index, genre: genre)
            }

            if store.isLoading {
                LoadingView(style: .inline)
            }
        }
        .listStyle(.plain)
    }
    
    private func rowView(index: Int, genre: Genre) -> some View {
        let backgroundColor = index % 2 == 0 ? Palette.cellWhite : Palette.cellAlternate
        
        return Button {
            store.send(.selectGenre(genre))
        } label: {
            ListCell(
                backgroundColor: backgroundColor,
                showChevron: true
            ) {
                Text(genre.name)
                    .foregroundColor(.primary)
            }
        }
        .listRowBackground(backgroundColor)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .onAppear {
            let threshold = max(3, store.genres.count / 10)
            if index >= store.genres.count - threshold && store.hasMorePages && !store.isLoading {
                store.send(.loadNextPage)
            }
        }
    }
    
}

// MARK: GenresView Extension
extension GenresView {
    enum Localization {
        static let title = LocalizedStringResource(
            "carSelection.genres.title",
            defaultValue: "Select Genre"
        )
        static let emptyTitle = LocalizedStringResource(
            "carSelection.genres.emptyTitle",
            defaultValue: "No genres available"
        )
        static let emptyMessage = LocalizedStringResource(
            "carSelection.genres.emptyMessage",
            defaultValue: "There are no genres to display"
        )
        static let ok = LocalizedStringResource("common.ok", defaultValue: "OK")
        static let cancel = LocalizedStringResource("common.cancel", defaultValue: "Cancel")
        static let loading = LocalizedStringResource("common.loading", defaultValue: "Loading…")
    }
}
