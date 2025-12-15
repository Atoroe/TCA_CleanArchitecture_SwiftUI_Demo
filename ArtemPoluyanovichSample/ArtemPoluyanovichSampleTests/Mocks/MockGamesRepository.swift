//
//  MockGamesRepository.swift
//  ArtemPoluyanovichSampleTests
//
//  Created by Artiom Poluyanovich on 11/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation

// MARK: - MockGamesRepository
/// Mock implementation of GamesRepository for tests
final class MockGamesRepository: GamesRepository, @unchecked Sendable {
    // MARK: - Closures for mocking
    var fetchGenresHandler: ((Int, Int) async throws -> PagedResult<Genre>)?
    var fetchGamesHandler: ((String, Int, Int) async throws -> PagedResult<Game>)?
    
    // MARK: - GamesRepository Implementation
    @concurrent func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre> {
        guard let handler = fetchGenresHandler else {
            fatalError("fetchGenresHandler not set in MockGamesRepository")
        }
        return try await handler(page, pageSize)
    }
    
    @concurrent func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game> {
        guard let handler = fetchGamesHandler else {
            fatalError("fetchGamesHandler not set in MockGamesRepository")
        }
        return try await handler(genreId, page, pageSize)
    }
}
