//
//  GamesRepository+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

// MARK: - DependencyValues Extension
extension DependencyValues {
    var gamesRepository: GamesRepository {
        get { self[GamesRepositoryKey.self] }
        set { self[GamesRepositoryKey.self] = newValue }
    }
}

// MARK: - DependencyKey Implementation
private enum GamesRepositoryKey: DependencyKey {
    // MARK: - Live Value
    static var liveValue: GamesRepository {
        let restService = NetworkServiceFactory.createRestService()
        return GamesRepositoryImpl(restService: restService)
    }
    
    // MARK: - Test Value
    static var testValue: GamesRepository {
        MockGamesRepository()
    }
    
    // MARK: - Preview Value
    static var previewValue: GamesRepository {
        MockGamesRepository()
    }
}

// MARK: - Mock Repository
private struct MockGamesRepository: GamesRepository {
    func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre> {
        let genres = (1...min(pageSize, 10)).map { Genre(id: "\($0)", name: "Genre \($0)") }
        return PagedResult(items: genres, currentPage: page, totalPages: 5)
    }
    
    func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game> {
        let games = (1...min(pageSize, 10)).map { Game(id: "\($0)", name: "Game \($0) for \(genreId)") }
        return PagedResult(items: games, currentPage: page, totalPages: 5)
    }
}
