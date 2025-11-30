//
//  Game.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

struct Game: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
}

extension Game {
    nonisolated static func == (lhs: Game, rhs: Game) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
