//
//  GenresFeatureTests.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Testing

struct GenresFeatureTests {
    
    @Test("onAppear loads first page")
    func onAppearLoadsFirstPage() async throws {
        let genres = TestDataHelpers.makeTestGenres(page: 0)
        let result = PagedResult(
            items: genres,
            currentPage: 0,
            totalPages: 2
        )
        
        let repository = MockGamesRepository()
            .withGenres(page: 0, result: result)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let store = TestStore(initialState: GenresFeature.State()) {
            GenresFeature()
        } withDependencies: {
            $0.gamesUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(.loadNextPage)
        await store.receive(.genresLoaded(result))
        
        #expect(store.state.genres.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.hasMorePages == true)
    }
    
    @Test("loadNextPage pagination")
    func loadNextPagePagination() async throws {
        let firstPageItems = TestDataHelpers.makeTestGenres(page: 0)
        let secondPageItems = TestDataHelpers.makeTestGenres(page: 1)
        
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
            .withGenres(page: 0, result: firstPageResult)
            .withGenres(page: 1, result: secondPageResult)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        var initialState = GenresFeature.State()
        initialState.genres = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        
        let store = TestStore(initialState: initialState) {
            GenresFeature()
        } withDependencies: {
            $0.gamesUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        await store.receive(.genresLoaded(secondPageResult))
        
        #expect(store.state.genres.count == 4)
        #expect(store.state.currentPage == 2)
        #expect(store.state.hasMorePages == false)
    }
    
    @Test("selectGenre navigates to games")
    func selectGenreNavigatesToGames() async throws {
        let genre = TestDataHelpers.makeTestGenre()
        
        let store = TestStore(initialState: GenresFeature.State()) {
            GenresFeature()
        }
        store.exhaustivity = .off
        
        await store.send(.selectGenre(genre))
        
        #expect(store.state.path.count == 1)
    }
}
