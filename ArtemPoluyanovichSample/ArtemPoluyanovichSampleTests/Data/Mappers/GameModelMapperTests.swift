//
//  GameModelMapperTests.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 2/12/2025.
//

@testable import ArtemPoluyanovichSample
import Foundation
import Testing

@Suite("GameModel+Mapper Tests")
struct GameModelMapperTests {
    
    @Test("toDomain converts single model to domain entity")
    func toDomainConvertsSingleModel() {
        let model = GameModel(id: 123, name: "Test Game", slug: "test-game")
        let domain = model.toDomain()
        
        #expect(domain.id == "123")
        #expect(domain.name == "Test Game")
    }
    
    @Test("toDomain converts array of models to domain entities")
    func toDomainConvertsArrayOfModels() {
        let models = [
            GameModel(id: 1, name: "Game 1", slug: "game-1"),
            GameModel(id: 2, name: "Game 2", slug: "game-2"),
            GameModel(id: 3, name: "Game 3", slug: "game-3")
        ]
        
        let domains = GameModel.toDomain(models)
        
        #expect(domains.count == 3)
        #expect(domains[0].id == "1")
        #expect(domains[0].name == "Game 1")
        #expect(domains[1].id == "2")
        #expect(domains[1].name == "Game 2")
        #expect(domains[2].id == "3")
        #expect(domains[2].name == "Game 3")
    }
    
    @Test("toDomain handles empty array")
    func toDomainHandlesEmptyArray() {
        let models: [GameModel] = []
        let domains = GameModel.toDomain(models)
        
        #expect(domains.isEmpty)
    }
}
