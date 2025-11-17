//
//  MainType.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

struct MainType: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
}

extension MainType {
    nonisolated static func == (lhs: MainType, rhs: MainType) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
