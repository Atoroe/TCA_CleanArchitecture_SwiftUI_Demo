//
//  GamesView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import SwiftUI

// MARK: - GamesView
struct GamesView: View {
    @Bindable var store: StoreOf<GamesFeature>

    // MARK: Body
    var body: some View {
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
    }
    
    // MARK: Private properties
    
    @ViewBuilder
    private var contentView: some View {
        if store.isInitialLoading {
            LoadingView(style: .fullScreen)
        } else if store.isEmpty {
            EmptyStateView(
                title: String(localized: Localization.emptyTitle),
                message: String(localized: Localization.emptyMessage)
            )
        } else {
            listView
        }
    }
    
    private var indexedGames: [(Int, Game)] {
        store.games.enumerated().map { ($0.offset, $0.element) }
    }
    
    private var listView: some View {
        List {
            ForEach(indexedGames, id: \.1.id) { index, game in
                rowView(index: index, game: game)
            }

            if store.hasMorePages {
                PaginationFooter(
                    isLoading: store.isLoadingMore,
                    onLoadMore: { store.send(.loadNextPage) }
                )
            }
        }
        .listStyle(.plain)
        .refreshable {
            store.send(.refresh)
            while store.loadingState == .refreshing {
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            }
        }
    }
    
    private func rowView(index: Int, game: Game) -> some View {
        let backgroundColor = index % 2 == 0 ? Palette.cellWhite : Palette.cellAlternate
        
        return Button {
            store.send(.selectGame(game))
        } label: {
            ListCell(
                backgroundColor: backgroundColor,
                showChevron: false
            ) {
                Text(game.name)
                    .foregroundColor(.primary)
            }
        }
        .listRowBackground(backgroundColor)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
    
}

// MARK: GamesView Extension
extension GamesView {
    enum Localization {
        static let title = LocalizedStringResource(
            "carSelection.games.title",
            defaultValue: "Select Game"
        )
        static let emptyTitle = LocalizedStringResource(
            "carSelection.games.emptyTitle",
            defaultValue: "No games available"
        )
        static let emptyMessage = LocalizedStringResource(
            "carSelection.games.emptyMessage",
            defaultValue: "There are no games for this genre"
        )
    }
}

// MARK: Preview
#Preview {
    GamesView(
        store: Store(
            initialState: GamesFeature.State(
                genre: Genre(id: "1", name: "Action")
            ),
            reducer: { GamesFeature() }
        )
    )
}
