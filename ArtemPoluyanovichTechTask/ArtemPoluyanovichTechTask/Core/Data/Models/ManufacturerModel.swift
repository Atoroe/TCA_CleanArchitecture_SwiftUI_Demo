//
//  ManufacturerModel.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

struct ManufacturerModel: Codable, Equatable {
    let id: String
    let name: String
    
    init?(key: String, value: String) {
        // Filter out non-numeric keys (preserve leading zeros like "060")
        guard !key.isEmpty && key.allSatisfy({ $0.isNumber }) else {
            return nil
        }
        self.id = key
        self.name = value
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
