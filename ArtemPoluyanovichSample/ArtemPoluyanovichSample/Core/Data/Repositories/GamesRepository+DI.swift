//
//  GamesRepository+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

private enum GamesRepositoryKey: DependencyKey {
    static let liveValue: GamesRepository = {
        let restService = NetworkServiceFactory.createRestService()
        return GamesRepositoryImpl(restService: restService)
    }()
    
    static let testValue: GamesRepository = UnimplementedGamesRepository()
    static let previewValue: GamesRepository = PreviewGamesRepository()
}

extension DependencyValues {
    var gamesRepository: GamesRepository {
        get { self[GamesRepositoryKey.self] }
        set { self[GamesRepositoryKey.self] = newValue }
    }
}

// MARK: - Test & Preview Implementations

private struct UnimplementedGamesRepository: GamesRepository {
    func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre> {
        reportIssue("UnimplementedGamesRepository.fetchGenres")
        return PagedResult(items: [], currentPage: 0, totalPages: 0)
    }
    
    func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game> {
        reportIssue("UnimplementedGamesRepository.fetchGames")
        return PagedResult(items: [], currentPage: 0, totalPages: 0)
    }
}

private struct PreviewGamesRepository: GamesRepository {
    func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre> {
        let genres = (1...pageSize).map { Genre(id: "\($0)", name: "Genre \($0)") }
        return PagedResult(items: genres, currentPage: page, totalPages: 5)
    }
    
    func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game> {
        let games = (1...pageSize).map { Game(id: "\($0)", name: "Game \($0) for \(genreId)") }
        return PagedResult(items: games, currentPage: page, totalPages: 5)
    }
}
