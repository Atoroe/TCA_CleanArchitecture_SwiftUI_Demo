//
//  GamesRepositoryImpl.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - GamesRepositoryImpl
struct GamesRepositoryImpl: GamesRepository, Sendable {
    private let restService: RestServiceProtocol
    
    init(restService: RestServiceProtocol) {
        self.restService = restService
    }
    
    // MARK: - Fetch Genres
    @concurrent func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre> {
        let request = ApiRequest(
            path: UrlPaths.genres,
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
    }
    
    // MARK: - Fetch Games
    @concurrent func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game> {
        let request = ApiRequest(
            path: UrlPaths.games,
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
}

// MARK: - URL Paths
private extension GamesRepositoryImpl {
    enum UrlPaths {
        static let genres = "/genres"
        static let games = "/games"
    }
}
