//
//  ManufacturerModelMapperTests.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation
import Testing

@Suite("ManufacturerModel+Mapper Tests")
struct ManufacturerModelMapperTests {
    
    @Test("toDomain converts single model to domain entity")
    func toDomainConvertsSingleModel() {
        let model = ManufacturerModel(id: "123", name: "BMW")
        let domain = model.toDomain()
        
        #expect(domain.id == "123")
        #expect(domain.name == "BMW")
    }
    
    @Test("toDomain converts array of models to domain entities")
    func toDomainConvertsArrayOfModels() {
        let models = [
            ManufacturerModel(id: "1", name: "BMW"),
            ManufacturerModel(id: "2", name: "Audi"),
            ManufacturerModel(id: "3", name: "Mercedes")
        ]
        
        let domains = ManufacturerModel.toDomain(models)
        
        #expect(domains.count == 3)
        #expect(domains[0].id == "1")
        #expect(domains[0].name == "BMW")
        #expect(domains[1].id == "2")
        #expect(domains[1].name == "Audi")
        #expect(domains[2].id == "3")
        #expect(domains[2].name == "Mercedes")
    }
    
    @Test("toDomain handles empty array")
    func toDomainHandlesEmptyArray() {
        let models: [ManufacturerModel] = []
        let domains = ManufacturerModel.toDomain(models)
        
        #expect(domains.isEmpty)
    }
    
    @Test("fromWkdaDictionary creates models from dictionary with valid keys")
    func fromWkdaDictionaryCreatesModelsWithValidKeys() {
        let wkda: [String: String] = [
            "3": "BMW",
            "1": "Audi",
            "2": "Mercedes"
        ]
        
        let models = ManufacturerModel.fromWkdaDictionary(wkda)
        
        #expect(models.count == 3)
        #expect(models[0].id == "1")
        #expect(models[0].name == "Audi")
        #expect(models[1].id == "2")
        #expect(models[1].name == "Mercedes")
        #expect(models[2].id == "3")
        #expect(models[2].name == "BMW")
    }
    
    @Test("fromWkdaDictionary filters out invalid keys")
    func fromWkdaDictionaryFiltersInvalidKeys() {
        let wkda: [String: String] = [
            "123": "Valid",
            "invalid": "Should be filtered",
            "456": "Also valid",
            "not-a-number": "Should be filtered too"
        ]
        
        let models = ManufacturerModel.fromWkdaDictionary(wkda)
        
        #expect(models.count == 2)
        #expect(models[0].id == "123")
        #expect(models[0].name == "Valid")
        #expect(models[1].id == "456")
        #expect(models[1].name == "Also valid")
    }
    
    @Test("fromWkdaDictionary sorts models by id ascending")
    func fromWkdaDictionarySortsByAscending() {
        let wkda: [String: String] = [
            "100": "Hundred",
            "10": "Ten",
            "1": "One"
        ]
        
        let models = ManufacturerModel.fromWkdaDictionary(wkda)
        
        #expect(models.count == 3)
        #expect(models[0].id == "1")
        #expect(models[1].id == "10")
        #expect(models[2].id == "100")
    }
    
    @Test("fromWkdaDictionary handles empty dictionary")
    func fromWkdaDictionaryHandlesEmptyDictionary() {
        let wkda: [String: String] = [:]
        let models = ManufacturerModel.fromWkdaDictionary(wkda)
        
        #expect(models.isEmpty)
    }
    
    @Test("fromWkdaDictionary handles only invalid keys")
    func fromWkdaDictionaryHandlesOnlyInvalidKeys() {
        let wkda: [String: String] = [
            "invalid": "Should be filtered",
            "also-invalid": "Should be filtered too"
        ]
        
        let models = ManufacturerModel.fromWkdaDictionary(wkda)
        
        #expect(models.isEmpty)
    }
    
    @Test("fromWkdaDictionary maps valid key to id and value to name")
    func fromWkdaDictionaryMapsKeyToIdAndValueToName() {
        let wkda: [String: String] = [
            "999": "Test Manufacturer"
        ]
        
        let models = ManufacturerModel.fromWkdaDictionary(wkda)
        
        #expect(models.count == 1)
        #expect(models[0].id == "999")
        #expect(models[0].name == "Test Manufacturer")
    }
}

