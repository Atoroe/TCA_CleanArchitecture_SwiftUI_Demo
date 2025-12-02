//
//  GamesFeatureTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 2/12/2025.
//

@testable import ArtemPoluyanovichSample
import ComposableArchitecture
import Testing

@MainActor
struct GamesFeatureTests {
    
    @Test("onAppear loads first page")
    func onAppearLoadsFirstPage() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let games = TestDataHelpers.makeTestGames(page: 0)
        let result = PagedResult(
            items: games,
            currentPage: 0,
            totalPages: 2
        )
        
        let repository = MockGamesRepository()
            .withGames(page: 0, result: result)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let store = TestStore(initialState: GamesFeature.State(genre: genre)) {
            GamesFeature()
        } withDependencies: {
            $0.gamesUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(.loadNextPage)
        await store.receive(.gamesLoaded(result))
        
        #expect(store.state.games.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.hasMorePages == true)
    }
    
    @Test("loadNextPage pagination")
    func loadNextPagePagination() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let firstPageItems = TestDataHelpers.makeTestGames(page: 0)
        let secondPageItems = TestDataHelpers.makeTestGames(page: 1)
        
        let firstPageResult = PagedResult(
            items: firstPageItems,
            currentPage: 0,
            totalPages: 2
        )
        let secondPageResult = PagedResult(
            items: secondPageItems,
            currentPage: 1,
            totalPages: 2
        )
        
        let repository = MockGamesRepository()
            .withGames(page: 0, result: firstPageResult)
            .withGames(page: 1, result: secondPageResult)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        var initialState = GamesFeature.State(genre: genre)
        initialState.games = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        
        let store = TestStore(initialState: initialState) {
            GamesFeature()
        } withDependencies: {
            $0.gamesUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        await store.receive(.gamesLoaded(secondPageResult))
        
        #expect(store.state.games.count == 4)
        #expect(store.state.currentPage == 2)
        #expect(store.state.hasMorePages == false)
    }
    
    @Test("selectGame sends delegate")
    func selectGameSendsDelegate() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let game = TestDataHelpers.makeTestGame()
        
        let store = TestStore(initialState: GamesFeature.State(genre: genre)) {
            GamesFeature()
        }
        
        await store.send(.selectGame(game))
        await store.receive(.delegate(.didSelectGame(game)))
    }
}
