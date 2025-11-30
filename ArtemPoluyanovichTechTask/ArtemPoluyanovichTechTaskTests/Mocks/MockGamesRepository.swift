//
//  MockGamesRepository.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation

struct MockGamesRepository: GamesRepository {
    private var genresPages: [Int: PagedResult<Genre>] = [:]
    private var gamesPages: [Int: PagedResult<Game>] = [:]
    private var error: AppError?
    
    init() {}
    
    func withGenres(page: Int, result: PagedResult<Genre>) -> Self {
        var copy = self
        copy.genresPages[page] = result
        return copy
    }
    
    func withGames(page: Int, result: PagedResult<Game>) -> Self {
        var copy = self
        copy.gamesPages[page] = result
        return copy
    }
    
    func withError(_ error: AppError) -> Self {
        var copy = self
        copy.error = error
        return copy
    }
    
    func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre> {
        if let error {
            throw error
        }
        
        return genresPages[page] ?? PagedResult(items: [], currentPage: page, totalPages: 0)
    }
    
    func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game> {
        if let error {
            throw error
        }
        
        return gamesPages[page] ?? PagedResult(items: [], currentPage: page, totalPages: 0)
    }
}

