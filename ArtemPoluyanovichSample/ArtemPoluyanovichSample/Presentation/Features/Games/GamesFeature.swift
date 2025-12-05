//
//  GamesFeature.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct GamesFeature {
    // MARK: - LoadingState
    enum LoadingState: Equatable {
        case idle
        case initialLoading
        case loadingMore
        case refreshing
    }
    
    @ObservableState
    struct State: Equatable, Hashable {
        let genre: Genre
        var games: [Game] = []
        var currentPage: Int = 0
        var loadingState: LoadingState = .idle
        var hasMorePages: Bool = true
        var errorMessage: String?
        var showToast: Bool = false

        var isEmpty: Bool {
            loadingState == .idle && games.isEmpty && errorMessage == nil
        }
        
        var isInitialLoading: Bool {
            loadingState == .initialLoading && games.isEmpty
        }
        
        var isLoadingMore: Bool {
            loadingState == .loadingMore
        }

        init(genre: Genre) {
            self.genre = genre
        }
    }

    enum Action: Equatable {
        case onAppear
        case refresh
        case loadNextPage
        case gamesLoaded(PagedResult<Game>)
        case loadFailed(String)
        case toastDismissed
        case selectGame(Game)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case didSelectGame(Game)
        }
    }
    
    nonisolated enum CancelID: Hashable, Sendable {
        case loading
    }

    @Dependency(\.gamesUseCase) var useCase
    @Dependency(\.continuousClock) var clock

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.games.isEmpty, state.loadingState == .idle else { return .none }
                state.loadingState = .initialLoading
                return loadPage(state: &state, page: 0, isRefresh: false)

            case .refresh:
                guard state.loadingState != .refreshing else { return .none }
                state.loadingState = .refreshing
                state.currentPage = 0
                state.hasMorePages = true
                return loadPage(state: &state, page: 0, isRefresh: true)

            case .loadNextPage:
                guard state.loadingState == .idle, state.hasMorePages else { return .none }
                state.loadingState = .loadingMore
                return loadPage(state: &state, page: state.currentPage, isRefresh: false)

            case let .gamesLoaded(result):
                let wasRefreshing = state.loadingState == .refreshing
                state.loadingState = .idle
                
                if wasRefreshing {
                    state.games = result.items
                } else {
                    let existingIds = Set(state.games.map { $0.id })
                    let newItems = result.items.filter { !existingIds.contains($0.id) }
                    state.games.append(contentsOf: newItems)
                }
                state.currentPage += 1
                state.hasMorePages = result.hasMorePages
                return .none

            case let .loadFailed(message):
                state.loadingState = .idle
                state.errorMessage = message
                state.showToast = true
                return .run { send in
                    let duration = max(3, Double(message.count) / 20)
                    try? await clock.sleep(for: .seconds(duration))
                    await send(.toastDismissed)
                }
            
            case .toastDismissed:
                state.showToast = false
                return .none

            case let .selectGame(game):
                return .send(.delegate(.didSelectGame(game)))

            case .delegate:
                return .none

            }
        }
    }
    
    // MARK: - Private Helpers
    private func loadPage(state: inout State, page: Int, isRefresh: Bool) -> Effect<Action> {
        state.errorMessage = nil
        let genreId = state.genre.id
        return .run { send in
            do {
                let result = try await useCase.fetchGames(genreId: genreId, page: page)
                await send(.gamesLoaded(result))
            } catch is CancellationError {
                return
            } catch {
                await send(.loadFailed(error.localizedDescription))
            }
        }
        .cancellable(id: CancelID.loading, cancelInFlight: isRefresh)
    }
}
