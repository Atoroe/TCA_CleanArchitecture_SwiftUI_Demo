//
//  GenresFeature.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct GenresFeature {
    @ObservableState
    struct State: Equatable {
        var genres: [Genre] = []
        var currentPage: Int = 0
        var isLoading: Bool = false
        var hasMorePages: Bool = true
        var errorMessage: String?
        var showToast: Bool = false
        var path = StackState<GamesFeature.State>()

        @Presents var destination: Destination.State?

        var isEmpty: Bool {
            !isLoading && genres.isEmpty && errorMessage == nil
        }

        init() {}
    }

    enum Action: Equatable {
        case onAppear
        case loadNextPage
        case genresLoaded(PagedResult<Genre>)
        case loadFailed(String)
        case toastDismissed
        case selectGenre(Genre)
        case gameSelected(genre: Genre, game: Game)
        case destination(PresentationAction<Destination.Action>)
        case path(StackActionOf<GamesFeature>)
        
        enum Alert: Equatable {
            case dismissed
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
                guard state.genres.isEmpty && !state.isLoading else { return .none }
                return .run { send in
                    await send(.loadNextPage)
                }

            case .loadNextPage:
                guard !state.isLoading && state.hasMorePages else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                let pageToLoad = state.currentPage
                return .run { send in
                    do {
                        let result = try await useCase.fetchGenres(page: pageToLoad)
                        await send(.genresLoaded(result))
                    } catch is CancellationError {
                        return
                    } catch {
                        await send(.loadFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.loading, cancelInFlight: true)

            case let .genresLoaded(result):
                state.isLoading = false
                let existingIds = Set(state.genres.map { $0.id })
                let newItems = result.items.filter { !existingIds.contains($0.id) }
                state.genres.append(contentsOf: newItems)
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

            case let .selectGenre(genre):
                state.path.append(GamesFeature.State(genre: genre))
                return .none

            case let .gameSelected(genre, game):
                state.destination = .alert(
                    AlertState {
                        TextState(Localization.selectedTitle)
                    } actions: {
                        ButtonState(action: .dismissed) {
                            TextState(Localization.ok)
                        }
                    } message: {
                        TextState("\(genre.name), \(game.name)")
                    }
                )
                return .none

            case .destination(.presented(.alert(.dismissed))):
                state.destination = nil
                return .none
            
            case let .path(.element(id: _, action: .delegate(.didSelectGame(game)))):
                guard !state.path.isEmpty, let genre = state.path.last?.genre else { return .none }
                state.path.removeLast()
                return .send(.gameSelected(genre: genre, game: game))
            
            case .destination, .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
        .forEach(\.path, action: \.path) {
            GamesFeature()
        }
    }
}

extension GenresFeature {
    @Reducer
    enum Destination {
        case alert(AlertState<GenresFeature.Action.Alert>)
    }
}

extension GenresFeature.Destination.State: Equatable {}
extension GenresFeature.Destination.Action: Equatable {}

extension GenresFeature {
    enum Localization {
        static let selectedTitle = LocalizedStringResource(
            "carSelection.genres.selected",
            defaultValue: "Selected"
        )
        static let ok = LocalizedStringResource("common.ok", defaultValue: "OK")
    }
}
