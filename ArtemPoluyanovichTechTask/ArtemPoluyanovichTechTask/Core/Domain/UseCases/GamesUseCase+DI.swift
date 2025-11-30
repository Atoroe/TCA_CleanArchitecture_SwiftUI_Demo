//
//  GamesUseCase+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

// MARK: - TCA Dependency
extension GamesUseCase: DependencyKey {
    static let liveValue = GamesUseCase.create()
}

extension DependencyValues {
    var gamesUseCase: GamesUseCase {
        get { self[GamesUseCase.self] }
        set { self[GamesUseCase.self] = newValue }
    }
}
