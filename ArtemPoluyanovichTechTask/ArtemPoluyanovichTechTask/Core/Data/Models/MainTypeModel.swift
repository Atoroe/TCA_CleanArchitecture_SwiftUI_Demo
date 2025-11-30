//
//  MainTypeModel.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

struct MainTypeModel: Codable, Equatable {
    let id: String
    let name: String
    
    init(key: String, value: String) {
        self.id = key
        self.name = value
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
