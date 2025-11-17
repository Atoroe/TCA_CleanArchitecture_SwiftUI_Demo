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
    
    nonisolated static func makeTestManufacturers(page: Int) -> [Manufacturer] {
        switch page {
        case 0:
            return [
                Manufacturer(id: 1, name: "BMW"),
                Manufacturer(id: 2, name: "Audi")
            ]
        case 1:
            return [
                Manufacturer(id: 3, name: "Mercedes"),
                Manufacturer(id: 4, name: "Volkswagen")
            ]
        default:
            return []
        }
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
    static func makeUseCase(from repository: MockCarsRepository) -> CarsUseCase {
        return CarsUseCase(repository: repository)
    }
}

