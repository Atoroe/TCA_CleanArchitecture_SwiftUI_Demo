//
//  MockCarsRepository.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation

struct MockCarsRepository: CarsRepository {
    private var manufacturersPages: [Int: PagedResult<Manufacturer>] = [:]
    private var mainTypesPages: [Int: PagedResult<MainType>] = [:]
    private var error: AppError?
    
    init() {}
    
    func withManufacturers(page: Int, result: PagedResult<Manufacturer>) -> Self {
        var copy = self
        copy.manufacturersPages[page] = result
        return copy
    }
    
    func withMainTypes(page: Int, result: PagedResult<MainType>) -> Self {
        var copy = self
        copy.mainTypesPages[page] = result
        return copy
    }
    
    func withError(_ error: AppError) -> Self {
        var copy = self
        copy.error = error
        return copy
    }
    
    func fetchManufacturers(page: Int, pageSize: Int) async throws -> PagedResult<Manufacturer> {
        if let error {
            throw error
        }
        
        return manufacturersPages[page] ?? PagedResult(items: [], currentPage: page, totalPages: 0)
    }
    
    func fetchMainTypes(manufacturerId: String, page: Int, pageSize: Int) async throws -> PagedResult<MainType> {
        if let error {
            throw error
        }
        
        return mainTypesPages[page] ?? PagedResult(items: [], currentPage: page, totalPages: 0)
    }
}

