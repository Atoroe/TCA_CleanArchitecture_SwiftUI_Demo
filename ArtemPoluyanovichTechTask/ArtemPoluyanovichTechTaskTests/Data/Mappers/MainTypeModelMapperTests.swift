//
//  MainTypeModelMapperTests.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation
import Testing

@Suite("MainTypeModel+Mapper Tests")
struct MainTypeModelMapperTests {
    
    @Test("toDomain converts single model to domain entity")
    func toDomainConvertsSingleModel() {
        let model = MainTypeModel(id: "123", name: "Sedan")
        let domain = model.toDomain()
        
        #expect(domain.id == "123")
        #expect(domain.name == "Sedan")
    }
    
    @Test("toDomain converts array of models to domain entities")
    func toDomainConvertsArrayOfModels() {
        let models = [
            MainTypeModel(id: "1", name: "Type 1"),
            MainTypeModel(id: "2", name: "Type 2"),
            MainTypeModel(id: "3", name: "Type 3")
        ]
        
        let domains = MainTypeModel.toDomain(models)
        
        #expect(domains.count == 3)
        #expect(domains[0].id == "1")
        #expect(domains[0].name == "Type 1")
        #expect(domains[1].id == "2")
        #expect(domains[1].name == "Type 2")
        #expect(domains[2].id == "3")
        #expect(domains[2].name == "Type 3")
    }
    
    @Test("toDomain handles empty array")
    func toDomainHandlesEmptyArray() {
        let models: [MainTypeModel] = []
        let domains = MainTypeModel.toDomain(models)
        
        #expect(domains.isEmpty)
    }
    
    @Test("fromWkdaDictionary creates models from dictionary")
    func fromWkdaDictionaryCreatesModels() {
        let wkda: [String: String] = [
            "type3": "SUV",
            "type1": "Sedan",
            "type2": "Coupe"
        ]
        
        let models = MainTypeModel.fromWkdaDictionary(wkda)
        
        #expect(models.count == 3)
        #expect(models[0].id == "type1")
        #expect(models[0].name == "Sedan")
        #expect(models[1].id == "type2")
        #expect(models[1].name == "Coupe")
        #expect(models[2].id == "type3")
        #expect(models[2].name == "SUV")
    }
    
    @Test("fromWkdaDictionary sorts models by id ascending")
    func fromWkdaDictionarySortsByAscending() {
        let wkda: [String: String] = [
            "z": "Zebra",
            "a": "Alpha",
            "m": "Middle"
        ]
        
        let models = MainTypeModel.fromWkdaDictionary(wkda)
        
        #expect(models.count == 3)
        #expect(models[0].id == "a")
        #expect(models[1].id == "m")
        #expect(models[2].id == "z")
    }
    
    @Test("fromWkdaDictionary handles empty dictionary")
    func fromWkdaDictionaryHandlesEmptyDictionary() {
        let wkda: [String: String] = [:]
        let models = MainTypeModel.fromWkdaDictionary(wkda)
        
        #expect(models.isEmpty)
    }
    
    @Test("fromWkdaDictionary maps key to id and value to name")
    func fromWkdaDictionaryMapsKeyToIdAndValueToName() {
        let wkda: [String: String] = [
            "test-key": "Test Name"
        ]
        
        let models = MainTypeModel.fromWkdaDictionary(wkda)
        
        #expect(models.count == 1)
        #expect(models[0].id == "test-key")
        #expect(models[0].name == "Test Name")
    }
}

