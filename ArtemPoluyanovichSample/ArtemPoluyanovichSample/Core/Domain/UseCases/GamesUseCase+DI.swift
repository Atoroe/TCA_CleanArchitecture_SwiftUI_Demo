//
//  GamesUseCase+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture
import Foundation

// MARK: - DependencyValues Extension
extension DependencyValues {
    var gamesUseCase: GamesUseCase {
        get { self[GamesUseCaseKey.self] }
        set { self[GamesUseCaseKey.self] = newValue }
    }
}

// MARK: - DependencyKey Implementation
private enum GamesUseCaseKey: DependencyKey {
    // MARK: - Live Value
    static let liveValue: GamesUseCase = {
        @Dependency(\.gamesRepository) var repository
        let impl = GamesUseCaseImpl(repository: repository)
        
        return GamesUseCase(
            fetchGenres: { page, pageSize in
                try await impl.fetchGenres(page: page, pageSize: pageSize)
            },
            fetchGames: { genreId, page, pageSize in
                try await impl.fetchGames(genreId: genreId, page: page, pageSize: pageSize)
            }
        )
    }()
    
    // MARK: - Test Value
    /// Test implementation of UseCase
    /// Returns empty results by default
    /// In tests, methods should be explicitly mocked using withDependencies for custom behavior
    static let testValue: GamesUseCase = GamesUseCase(
        fetchGenres: { _, _ in
            PagedResult(items: [], currentPage: 0, totalPages: 0)
        },
        fetchGames: { _, _, _ in
            PagedResult(items: [], currentPage: 0, totalPages: 0)
        }
    )
    
    // MARK: - Preview Value
    /// Preview implementation of UseCase for SwiftUI Previews
    /// Returns mock data for UI demonstration
    static let previewValue: GamesUseCase = {
        GamesUseCase(
            fetchGenres: { page, _ in
                let mockGenres = [
                    Genre(id: "1", name: "Action"),
                    Genre(id: "2", name: "Adventure"),
                    Genre(id: "3", name: "RPG")
                ]
                return PagedResult(
                    items: mockGenres,
                    currentPage: page,
                    totalPages: 1,
                    hasMorePages: false
                )
            },
            fetchGames: { _, page, _ in
                let mockGames = [
                    Game(id: "1", name: "The Witcher 3"),
                    Game(id: "2", name: "Cyberpunk 2077"),
                    Game(id: "3", name: "Red Dead Redemption 2")
                ]
                return PagedResult(
                    items: mockGames,
                    currentPage: page,
                    totalPages: 1,
                    hasMorePages: false
                )
            }
        )
    }()
}
