//
//  Genre.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

struct Genre: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
}

extension Genre {
    nonisolated static func == (lhs: Genre, rhs: Genre) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
