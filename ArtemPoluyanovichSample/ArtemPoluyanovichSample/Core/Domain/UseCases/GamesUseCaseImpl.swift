//
//  GamesUseCaseImpl.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - GamesUseCaseImpl
/// Live implementation of GamesUseCase
/// Delegates to GamesRepository for data fetching
final class GamesUseCaseImpl: @unchecked Sendable {
    // MARK: - Properties
    private let repository: GamesRepository
    
    // MARK: - Initializer
    nonisolated init(repository: GamesRepository) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    nonisolated func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre> {
        try await repository.fetchGenres(page: page, pageSize: pageSize)
    }
    
    nonisolated func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game> {
        try await repository.fetchGames(genreId: genreId, page: page, pageSize: pageSize)
    }
}
