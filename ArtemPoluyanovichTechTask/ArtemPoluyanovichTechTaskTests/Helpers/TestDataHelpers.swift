//
//  TestDataHelpers.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation

enum TestDataHelpers {
    
    nonisolated static func makeTestGenre() -> Genre {
        Genre(id: "4", name: "Action")
    }
    
    nonisolated static func makeTestGame() -> Game {
        Game(id: "123", name: "Test Game")
    }
    
    nonisolated static func makeTestGenres(page: Int) -> [Genre] {
        let baseId = page * 2
        return [
            Genre(id: "\(baseId + 1)", name: "Genre \(baseId + 1)"),
            Genre(id: "\(baseId + 2)", name: "Genre \(baseId + 2)")
        ]
    }
    
    nonisolated static func makeTestGames(page: Int) -> [Game] {
        let baseId = page * 2
        return [
            Game(id: "\(baseId + 1)", name: "Game \(baseId + 1)"),
            Game(id: "\(baseId + 2)", name: "Game \(baseId + 2)")
        ]
    }
    
    @MainActor
    static func makeUseCase(from repository: GamesRepository) -> GamesUseCase {
        GamesUseCase(repository: repository)
    }
}

