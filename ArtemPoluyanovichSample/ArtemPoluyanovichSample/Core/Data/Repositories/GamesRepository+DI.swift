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
