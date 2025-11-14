//
//  CarsUseCase.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture

@DependencyClient
struct CarsUseCase {
    var fetchManufacturers: (Int) async throws -> PagedResult<Manufacturer>
    var fetchMainTypes: (Int, Int) async throws -> PagedResult<MainType>
}
