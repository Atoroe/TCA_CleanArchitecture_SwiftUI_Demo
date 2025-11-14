//
//  ManufacturerModel.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

struct ManufacturerModel: Codable, Equatable {
    let id: Int
    let name: String
    
    init?(key: String, value: String) {
        guard let id = Int(key) else {
            return nil
        }
        self.id = id
        self.name = value
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
