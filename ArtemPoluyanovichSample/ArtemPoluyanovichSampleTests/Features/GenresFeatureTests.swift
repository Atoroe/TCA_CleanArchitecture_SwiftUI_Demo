//
//  GenresFeatureTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 2/12/2025.
//

@testable import ArtemPoluyanovichSample
import ComposableArchitecture
import Testing
import Clocks

@MainActor
struct GenresFeatureTests {
    
    @Test("onAppear loads first page with initialLoading state")
    func onAppearLoadsFirstPage() async throws {
        let genres = TestDataHelpers.makeTestGenres(page: 0)
        let result = PagedResult(
            items: genres,
            currentPage: 0,
            totalPages: 2
        )
        
        let store = TestStore(initialState: GenresFeature.State()) {
            GenresFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { page, pageSize in
                    #expect(page == 0)
                    #expect(pageSize == 20)
                    return result
                },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        #expect(store.state.loadingState == .initialLoading)
        
        await store.receive(.genresLoaded(result))
        
        #expect(store.state.genres.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.hasMorePages == true)
        #expect(store.state.loadingState == .idle)
        #expect(store.state.isInitialLoading == false)
    }
    
    @Test("loadNextPage pagination with loadingMore state")
    func loadNextPagePagination() async throws {
        let firstPageItems = TestDataHelpers.makeTestGenres(page: 0)
        let secondPageItems = TestDataHelpers.makeTestGenres(page: 1)
        
        let secondPageResult = PagedResult(
            items: secondPageItems,
            currentPage: 1,
            totalPages: 2
        )
        
        var initialState = GenresFeature.State()
        initialState.genres = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GenresFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { page, pageSize in
                    #expect(page == 1)
                    #expect(pageSize == 20)
                    return secondPageResult
                },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        #expect(store.state.loadingState == .loadingMore)
        #expect(store.state.isLoadingMore == true)
        
        await store.receive(.genresLoaded(secondPageResult))
        
        #expect(store.state.genres.count == 4)
        #expect(store.state.currentPage == 2)
        #expect(store.state.hasMorePages == false)
        #expect(store.state.loadingState == .idle)
        #expect(store.state.isLoadingMore == false)
    }
    
    @Test("selectGenre navigates to games")
    func selectGenreNavigatesToGames() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        
        let store = TestStore(initialState: GenresFeature.State()) {
            GenresFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.selectGenre(genre))
        
        #expect(store.state.path.count == 1)
    }
    
    @Test("refresh resets state and loads first page")
    func refreshResetsStateAndLoadsFirstPage() async throws {
        let firstPageItems = TestDataHelpers.makeTestGenres(page: 0)
        let refreshedItems = TestDataHelpers.makeTestGenres(page: 0)
        
        let refreshedResult = PagedResult(
            items: refreshedItems,
            currentPage: 0,
            totalPages: 2
        )
        
        var initialState = GenresFeature.State()
        initialState.genres = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GenresFeature()
        } withDependencies: {
            $0.continuousClock = ImmediateClock()
            $0.gamesUseCase = .testMock(
                fetchGenres: { page, pageSize in
                    #expect(page == 0)
                    #expect(pageSize == 20)
                    return refreshedResult
                },
                fetchGames: { _, _, _ in PagedResult(items: [], currentPage: 0, totalPages: 0) }
            )
        }
        store.exhaustivity = .off
        
        await store.send(.refresh)
        #expect(store.state.loadingState == .refreshing)
        #expect(store.state.currentPage == 0)
        #expect(store.state.hasMorePages == true)
        
        await store.receive(.genresLoaded(refreshedResult))
        
        #expect(store.state.genres.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.loadingState == .idle)
    }
    
    @Test("loadNextPage ignores when already loading")
    func loadNextPageIgnoresWhenAlreadyLoading() async throws {
        let genres = TestDataHelpers.makeTestGenres(page: 0)
        
        var initialState = GenresFeature.State()
        initialState.genres = genres
        initialState.currentPage = 1
        initialState.hasMorePages = true
        initialState.loadingState = .loadingMore
        
        let store = TestStore(initialState: initialState) {
            GenresFeature()
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
        let genres = TestDataHelpers.makeTestGenres(page: 0)
        
        var initialState = GenresFeature.State()
        initialState.genres = genres
        initialState.currentPage = 1
        initialState.hasMorePages = false
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GenresFeature()
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
    
    @Test("onAppear ignores when genres already loaded")
    func onAppearIgnoresWhenGenresAlreadyLoaded() async throws {
        let genres = TestDataHelpers.makeTestGenres(page: 0)
        
        var initialState = GenresFeature.State()
        initialState.genres = genres
        initialState.loadingState = .idle
        
        let store = TestStore(initialState: initialState) {
            GenresFeature()
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
        #expect(store.state.genres.count == 2)
    }
}
