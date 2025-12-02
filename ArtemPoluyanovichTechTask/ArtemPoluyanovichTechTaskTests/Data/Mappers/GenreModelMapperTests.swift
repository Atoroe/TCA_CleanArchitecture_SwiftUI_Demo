//
//  GenreModelMapperTests.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 2/12/2025.
//

@testable import ArtemPoluyanovichTechTask
import Foundation
import Testing

@Suite("GenreModel+Mapper Tests")
struct GenreModelMapperTests {
    
    @Test("toDomain converts single model to domain entity")
    func toDomainConvertsSingleModel() {
        let model = GenreModel(id: 456, name: "Test Genre", slug: "test-genre")
        let domain = model.toDomain()
        
        #expect(domain.id == "456")
        #expect(domain.name == "Test Genre")
    }
    
    @Test("toDomain converts array of models to domain entities")
    func toDomainConvertsArrayOfModels() {
        let models = [
            GenreModel(id: 1, name: "Genre 1", slug: "genre-1"),
            GenreModel(id: 2, name: "Genre 2", slug: "genre-2"),
            GenreModel(id: 3, name: "Genre 3", slug: "genre-3")
        ]
        
        let domains = GenreModel.toDomain(models)
        
        #expect(domains.count == 3)
        #expect(domains[0].id == "1")
        #expect(domains[0].name == "Genre 1")
        #expect(domains[1].id == "2")
        #expect(domains[1].name == "Genre 2")
        #expect(domains[2].id == "3")
        #expect(domains[2].name == "Genre 3")
    }
    
    @Test("toDomain handles empty array")
    func toDomainHandlesEmptyArray() {
        let models: [GenreModel] = []
        let domains = GenreModel.toDomain(models)
        
        #expect(domains.isEmpty)
    }
}
