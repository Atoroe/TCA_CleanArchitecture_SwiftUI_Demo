//
//  Manufacturer.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

struct Manufacturer: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    
    nonisolated static func == (lhs: Manufacturer, rhs: Manufacturer) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name
    }
}
