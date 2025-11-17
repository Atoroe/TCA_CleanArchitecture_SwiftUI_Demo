//
//  CarsRepository.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

protocol CarsRepository {
    func fetchManufacturers(page: Int, pageSize: Int) async throws -> PagedResult<Manufacturer>
    func fetchMainTypes(manufacturerId: Int, page: Int, pageSize: Int) async throws -> PagedResult<MainType>
}
