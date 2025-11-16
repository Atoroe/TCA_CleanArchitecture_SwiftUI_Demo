//
//  MockCarsRepository.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation

struct MockCarsRepository: CarsRepository {
    let firstPageResult: PagedResult<MainType>?
    let secondPageResult: PagedResult<MainType>?
    let shouldThrowError: Bool
    let error: AppError?
    
    func fetchManufacturers(page: Int, pageSize: Int) async throws -> PagedResult<Manufacturer> {
        throw AppError.unknown(message: "Not implemented in mock")
    }
    
    func fetchMainTypes(manufacturerId: Int, page: Int, pageSize: Int) async throws -> PagedResult<MainType> {
        if shouldThrowError {
            throw error ?? AppError.network(reason: "Test error")
        }
        
        if page == 0, let result = firstPageResult {
            return result
        } else if page == 1, let result = secondPageResult {
            return result
        }
        
        return PagedResult(items: [], currentPage: page, totalPages: 0)
    }
}

