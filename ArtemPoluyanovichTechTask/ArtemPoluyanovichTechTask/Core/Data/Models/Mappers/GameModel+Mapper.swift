//
//  GameModel+Mapper.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

extension GameModel {
    func toDomain() -> Game {
        Game(id: String(self.id), name: self.name)
    }
    
    static func toDomain(_ models: [GameModel]) -> [Game] {
        models.map { $0.toDomain() }
    }
}
