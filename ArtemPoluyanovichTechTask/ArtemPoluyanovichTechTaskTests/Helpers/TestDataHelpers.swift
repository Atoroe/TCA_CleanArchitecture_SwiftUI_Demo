//
//  TestDataHelpers.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation

enum TestDataHelpers {
    
    nonisolated static func makeTestManufacturer() -> Manufacturer {
        Manufacturer(id: 1, name: "Test Manufacturer")
    }
    
    nonisolated static func makeTestMainTypes(page: Int) -> [MainType] {
        switch page {
        case 0:
            return [
                MainType(id: "1", name: "Type 1"),
                MainType(id: "2", name: "Type 2")
            ]
        case 1:
            return [
                MainType(id: "3", name: "Type 3"),
                MainType(id: "4", name: "Type 4")
            ]
        default:
            return []
        }
    }
    
    @MainActor
    static func makeMockUseCase(
        firstPageResult: PagedResult<MainType>? = nil,
        secondPageResult: PagedResult<MainType>? = nil,
        shouldThrowError: Bool = false,
        error: AppError? = nil
    ) -> CarsUseCase {
        return CarsUseCase(
            repository: MockCarsRepository(
                firstPageResult: firstPageResult,
                secondPageResult: secondPageResult,
                shouldThrowError: shouldThrowError,
                error: error
            )
        )
    }
}

