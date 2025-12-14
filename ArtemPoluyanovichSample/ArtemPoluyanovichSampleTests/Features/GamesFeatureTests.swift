//
//  GamesFeatureTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 2/12/2025.
//

@testable import ArtemPoluyanovichSample
import ComposableArchitecture
import Testing
import Clocks

@MainActor
struct GamesFeatureTests {
    
    @Test("onAppear loads first page with initialLoading state")
    func onAppearLoadsFirstPage() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let games = TestDataHelpers.makeTestGames(page: 0)
        let result = PagedResult(
            items: games,
            currentPage: 0,
            totalPages: 2
        )
        
        let store = TestStore(initialState: GamesFeature.State(genre: genre)) {
            GamesFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { genreId, page, pageSize in
                    #expect(genreId == genre.id)
                    #expect(page == 0)
                    #expect(pageSize == 20)
                    return result
                }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        #expect(store.state.loadingState == .initialLoading)
        
        await store.receive(.gamesLoaded(result))
        
        #expect(store.state.games.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.hasMorePages == true)
        #expect(store.state.loadingState == .idle)
        #expect(store.state.isInitialLoading == false)
    }
    
    @Test("loadNextPage pagination with loadingMore state")
    func loadNextPagePagination() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let firstPageItems = TestDataHelpers.makeTestGames(page: 0)
        let secondPageItems = TestDataHelpers.makeTestGames(page: 1)
        
        let secondPageResult = PagedResult(
            items: secondPageItems,
            currentPage: 1,
            totalPages: 2
        )
        
        var initialState = GamesFeature.State(genre: genre)
        initialState.games = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GamesFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { genreId, page, pageSize in
                    #expect(genreId == genre.id)
                    #expect(page == 1)
                    #expect(pageSize == 20)
                    return secondPageResult
                }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        #expect(store.state.loadingState == .loadingMore)
        #expect(store.state.isLoadingMore == true)
        
        await store.receive(.gamesLoaded(secondPageResult))
        
        #expect(store.state.games.count == 4)
        #expect(store.state.currentPage == 2)
        #expect(store.state.hasMorePages == false)
        #expect(store.state.loadingState == .idle)
        #expect(store.state.isLoadingMore == false)
    }
    
    @Test("selectGame sends delegate")
    func selectGameSendsDelegate() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let game = TestDataHelpers.makeTestGame()
        
        let store = TestStore(initialState: GamesFeature.State(genre: genre)) {
            GamesFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        
        await store.send(.selectGame(game))
        await store.receive(.delegate(.didSelectGame(game)))
    }
    
    @Test("refresh resets state and loads first page")
    func refreshResetsStateAndLoadsFirstPage() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let firstPageItems = TestDataHelpers.makeTestGames(page: 0)
        let refreshedItems = TestDataHelpers.makeTestGames(page: 0)
        
        let refreshedResult = PagedResult(
            items: refreshedItems,
            currentPage: 0,
            totalPages: 2
        )
        
        var initialState = GamesFeature.State(genre: genre)
        initialState.games = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GamesFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { genreId, page, pageSize in
                    #expect(genreId == genre.id)
                    #expect(page == 0)
                    #expect(pageSize == 20)
                    return refreshedResult
                }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.refresh)
        #expect(store.state.loadingState == .refreshing)
        #expect(store.state.currentPage == 0)
        #expect(store.state.hasMorePages == true)
        
        await store.receive(.gamesLoaded(refreshedResult))
        
        #expect(store.state.games.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.loadingState == .idle)
    }
    
    @Test("loadNextPage ignores when already loading")
    func loadNextPageIgnoresWhenAlreadyLoading() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let games = TestDataHelpers.makeTestGames(page: 0)
        
        var initialState = GamesFeature.State(genre: genre)
        initialState.games = games
        initialState.currentPage = 1
        initialState.hasMorePages = true
        initialState.loadingState = .loadingMore
        
        let store = TestStore(initialState: initialState) {
            GamesFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        
        #expect(store.state.loadingState == .loadingMore)
    }
    
    @Test("loadNextPage ignores when no more pages")
    func loadNextPageIgnoresWhenNoMorePages() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let games = TestDataHelpers.makeTestGames(page: 0)
        
        var initialState = GamesFeature.State(genre: genre)
        initialState.games = games
        initialState.currentPage = 1
        initialState.hasMorePages = false
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GamesFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        
        #expect(store.state.loadingState == .idle)
        #expect(store.state.hasMorePages == false)
    }
    
    @Test("onAppear ignores when games already loaded")
    func onAppearIgnoresWhenGamesAlreadyLoaded() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        let games = TestDataHelpers.makeTestGames(page: 0)
        
        var initialState = GamesFeature.State(genre: genre)
        initialState.games = games
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GamesFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        
        #expect(store.state.loadingState == .idle)
        #expect(store.state.games.count == 2)
    }
}
