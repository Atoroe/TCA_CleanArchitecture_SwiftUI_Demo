//
//  GamesRepository.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture
import Foundation

// MARK: - GamesRepository Struct
@DependencyClient
struct GamesRepository: Sendable {
    var fetchGenres: @Sendable (_ page: Int, _ pageSize: Int) async throws -> PagedResult<Genre>
    var fetchGames: @Sendable (_ genreId: String, _ page: Int, _ pageSize: Int) async throws -> PagedResult<Game>
}
