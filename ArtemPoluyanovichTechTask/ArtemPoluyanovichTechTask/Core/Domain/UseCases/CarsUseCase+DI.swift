//
//  CarsUseCase+DI.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

// MARK: - TCA Dependency
extension CarsUseCase: DependencyKey {
    static let liveValue: CarsUseCase = {
        let restService = NetworkServiceFactory.createCarsRestService()
        let repository = CarsRepositoryImpl(restService: restService)
        
        return CarsUseCase(
            fetchManufacturers: { page in
                return try await repository.fetchManufacturers(page: page, pageSize: 15)
            },
            fetchMainTypes: { manufacturerId, page in
                return try await repository.fetchMainTypes(manufacturerId: manufacturerId, page: page, pageSize: 15)
            }
        )
    }()
}
