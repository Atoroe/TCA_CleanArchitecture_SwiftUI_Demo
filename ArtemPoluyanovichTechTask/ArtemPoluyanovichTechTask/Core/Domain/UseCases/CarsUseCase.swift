//
//  CarsUseCase.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

struct CarsUseCase {
    let repository: CarsRepository
    
    func fetchManufacturers(page: Int) async throws -> PagedResult<Manufacturer> {
        return try await repository.fetchManufacturers(page: page, pageSize: 15)
    }
    
    func fetchMainTypes(manufacturerId: Int, page: Int) async throws -> PagedResult<MainType> {
        return try await repository.fetchMainTypes(manufacturerId: manufacturerId, page: page, pageSize: 15)
    }
}

extension CarsUseCase {
    static func create() -> CarsUseCase {
        let restService = NetworkServiceFactory.createCarsRestService()
        let repository = CarsRepositoryImpl(restService: restService)
        return CarsUseCase(repository: repository)
    }
}
