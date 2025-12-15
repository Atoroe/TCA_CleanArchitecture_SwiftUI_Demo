//
//  GamesUseCase.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture
import Foundation

// MARK: - GamesUseCase Interface
/// UseCase for working with genres and games
/// Uses the closure pattern for flexible mocking in tests
@DependencyClient
struct GamesUseCase: Sendable {
    // MARK: - Methods (Actions)
    
    /// Load list of genres with pagination
    /// - Parameters:
    ///   - page: Page number (starting from 0)
    ///   - pageSize: Number of items per page (default is 20)
    /// - Returns: PagedResult with genres
    var fetchGenres: @Sendable (
        _ page: Int,
        _ pageSize: Int
    ) async throws -> PagedResult<Genre>
    
    /// Load list of games for a specific genre with pagination
    /// - Parameters:
    ///   - genreId: Genre ID
    ///   - page: Page number (starting from 0)
    ///   - pageSize: Number of items per page (default is 20)
    /// - Returns: PagedResult with games
    var fetchGames: @Sendable (
        _ genreId: String,
        _ page: Int,
        _ pageSize: Int
    ) async throws -> PagedResult<Game>
}
