//
//  GamesRepository+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

private enum GamesRepositoryKey: DependencyKey {
    static let liveValue: GamesRepository = {
        let restService = NetworkServiceFactory.createRestService()
        return GamesRepositoryImpl(restService: restService)
    }()
}

extension DependencyValues {
    var gamesRepository: GamesRepository {
        get { self[GamesRepositoryKey.self] }
        set { self[GamesRepositoryKey.self] = newValue }
    }
}
