//
//  TestDataHelpers.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation

enum TestDataHelpers: Sendable {
    
    static func makeTestGenre() -> Genre {
        Genre(id: "4", name: "Action")
    }
    
    static func makeTestGame() -> Game {
        Game(id: "123", name: "Test Game")
    }
    
    static func makeTestGenres(page: Int) -> [Genre] {
        let baseId = page * 2
        return [
            Genre(id: "\(baseId + 1)", name: "Genre \(baseId + 1)"),
            Genre(id: "\(baseId + 2)", name: "Genre \(baseId + 2)")
        ]
    }
    
    static func makeTestGames(page: Int) -> [Game] {
        let baseId = page * 2
        return [
            Game(id: "\(baseId + 1)", name: "Game \(baseId + 1)"),
            Game(id: "\(baseId + 2)", name: "Game \(baseId + 2)")
        ]
    }
}

// MARK: - GamesUseCase Test Mock Extension
extension GamesUseCase {
    /// Creates a fully mocked GamesUseCase for testing
    /// All methods have default empty implementations to prevent unimplemented errors
    /// Override specific methods by passing custom closures
    static func testMock(
        fetchGenres: @escaping @Sendable (Int, Int) async throws -> PagedResult<Genre> = { _, _ in
            PagedResult(items: [], currentPage: 0, totalPages: 0)
        },
        fetchGames: @escaping @Sendable (String, Int, Int) async throws -> PagedResult<Game> = { _, _, _ in
            PagedResult(items: [], currentPage: 0, totalPages: 0)
        }
    ) -> Self {
        GamesUseCase(
            fetchGenres: fetchGenres,
            fetchGames: fetchGames
        )
    }
}

