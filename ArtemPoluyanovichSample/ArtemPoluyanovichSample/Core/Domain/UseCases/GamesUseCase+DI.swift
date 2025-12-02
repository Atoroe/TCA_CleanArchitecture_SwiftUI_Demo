//
//  GamesUseCase+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

// MARK: - TCA Dependency
extension GamesUseCase: DependencyKey {
    static var liveValue: GamesUseCase {
        @Dependency(\.gamesRepository) var repository
        return GamesUseCase(repository: repository)
    }
}

extension DependencyValues {
    var gamesUseCase: GamesUseCase {
        get { self[GamesUseCase.self] }
        set { self[GamesUseCase.self] = newValue }
    }
}
