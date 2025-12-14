//
//  GamesRepository.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - GamesRepository Protocol
protocol GamesRepository: Sendable {
    func fetchGenres(page: Int, pageSize: Int) async throws -> PagedResult<Genre>
    func fetchGames(genreId: String, page: Int, pageSize: Int) async throws -> PagedResult<Game>
}
