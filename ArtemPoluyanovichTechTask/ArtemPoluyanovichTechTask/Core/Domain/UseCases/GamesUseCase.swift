//
//  GamesUseCase.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

struct GamesUseCase {
    let repository: GamesRepository
    
    func fetchGenres(page: Int) async throws -> PagedResult<Genre> {
        return try await repository.fetchGenres(page: page, pageSize: 20)
    }
    
    func fetchGames(genreId: String, page: Int) async throws -> PagedResult<Game> {
        return try await repository.fetchGames(genreId: genreId, page: page, pageSize: 20)
    }
}

extension GamesUseCase {
    static func create() -> GamesUseCase {
        let restService = NetworkServiceFactory.createRestService()
        let repository = GamesRepositoryImpl(restService: restService)
        return GamesUseCase(repository: repository)
    }
}
