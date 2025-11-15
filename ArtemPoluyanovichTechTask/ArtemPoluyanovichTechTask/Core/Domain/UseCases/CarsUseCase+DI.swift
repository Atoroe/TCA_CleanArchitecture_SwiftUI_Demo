//
//  CarsUseCase+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

// MARK: - TCA Dependency
extension CarsUseCase: DependencyKey {
    static let liveValue = CarsUseCase.create()
}

extension DependencyValues {
    var carsUseCase: CarsUseCase {
        get { self[CarsUseCase.self] }
        set { self[CarsUseCase.self] = newValue }
    }
}
