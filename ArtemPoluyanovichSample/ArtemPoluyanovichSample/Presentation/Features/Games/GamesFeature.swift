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
    @ObservableState
    struct State: Equatable, Hashable {
        let genre: Genre
        var games: [Game] = []
        var currentPage: Int = 0
        var isLoading: Bool = false
        var hasMorePages: Bool = true
        var errorMessage: String?
        var showToast: Bool = false

        var isEmpty: Bool {
            !isLoading && games.isEmpty && errorMessage == nil
        }

        init(genre: Genre) {
            self.genre = genre
        }
    }

    enum Action: Equatable {
        case onAppear

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
                guard state.games.isEmpty else { return .none }
                return .run { send in
                    await send(.loadNextPage)
                }

            case .loadNextPage:
                guard !state.isLoading && state.hasMorePages else {
                    return .none }
                state.isLoading = true
                state.errorMessage = nil
                let pageToLoad = state.currentPage
                let genreId = state.genre.id
                return .run { send in
                    do {
                        let result = try await useCase.fetchGames(genreId: genreId, page: pageToLoad)
                        await send(.gamesLoaded(result))
                    } catch is CancellationError {
                        return
                    } catch {
                        await send(.loadFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.loading, cancelInFlight: true) 

            case let .gamesLoaded(result):
                state.isLoading = false
                let existingIds = Set(state.games.map { $0.id })
                let newItems = result.items.filter { !existingIds.contains($0.id) }
                state.games.append(contentsOf: newItems)
                state.currentPage += 1
                state.hasMorePages = result.hasMorePages
                return .none

            case let .loadFailed(message):
                state.isLoading = false
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
}
