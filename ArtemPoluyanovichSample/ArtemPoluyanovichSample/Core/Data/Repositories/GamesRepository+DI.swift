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
        
        return GamesRepository(
            fetchGenres: { page, pageSize in
                let request = ApiRequest(
                    path: "/genres",
                    queryParameters: [
                        "page": String(page + 1), // RAWG uses 1-based indexing
                        "page_size": String(pageSize),
                        "ordering": "name" // Sorted by genres name
                    ],
                    method: .GET
                )
                
                do {
                    let response: PaginatedResponse<GenreModel> = try await restService.send(request)
                    let entities = GenreModel.toDomain(response.results)
                    let totalPages = response.calculateTotalPages(pageSize: pageSize)
                    
                    return PagedResult(
                        items: entities,
                        currentPage: page,
                        totalPages: totalPages,
                        hasMorePages: response.hasMorePages
                    )
                } catch {
                    throw ErrorMapper.map(error)
                }
            },
            fetchGames: { genreId, page, pageSize in
                let request = ApiRequest(
                    path: "/games",
                    queryParameters: [
                        "genres": genreId,
                        "page": String(page + 1), // RAWG uses 1-based indexing
                        "page_size": String(pageSize)
                    ],
                    method: .GET
                )
                
                do {
                    let response: PaginatedResponse<GameModel> = try await restService.send(request)
                    let entities = GameModel.toDomain(response.results).sorted { $0.name < $1.name }
                    let totalPages = response.calculateTotalPages(pageSize: pageSize)
                    
                    return PagedResult(
                        items: entities,
                        currentPage: page,
                        totalPages: totalPages,
                        hasMorePages: response.hasMorePages
                    )
                } catch {
                    throw ErrorMapper.map(error)
                }
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
