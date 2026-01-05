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
    static let liveValue: GamesRepository = {
        let restService = NetworkServiceFactory.createRestService()
        let impl = GamesRepositoryImpl(restService: restService)
        
        return GamesRepository(
            fetchGenres: { page, pageSize in
                try await impl.fetchGenres(page: page, pageSize: pageSize)
            },
            fetchGames: { genreId, page, pageSize in
                try await impl.fetchGames(genreId: genreId, page: page, pageSize: pageSize)
            }
        )
    }()
    
    // MARK: - Test Value
    static let testValue: GamesRepository = GamesRepository(
        fetchGenres: { page, pageSize in
            let genres = (1...min(pageSize, 10)).map { Genre(id: "\($0)", name: "Genre \($0)") }
            return PagedResult(items: genres, currentPage: page, totalPages: 5)
        },
        fetchGames: { genreId, page, pageSize in
            let games = (1...min(pageSize, 10)).map { Game(id: "\($0)", name: "Game \($0) for \(genreId)") }
            return PagedResult(items: games, currentPage: page, totalPages: 5)
        }
    )
    
    // MARK: - Preview Value
    static let previewValue: GamesRepository = testValue
}
