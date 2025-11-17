//
//  MainTypeModel+Mapper.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

extension MainTypeModel {
    func toDomain() -> MainType {
        MainType(id: self.id, name: self.name)
    }
    
    static func toDomain(_ models: [MainTypeModel]) -> [MainType] {
        models.map { $0.toDomain() }
    }
    
    static func fromWkdaDictionary(_ wkda: [String: String]) -> [MainTypeModel] {
        wkda
            .map { MainTypeModel(key: $0.key, value: $0.value) }
            .sorted { $0.id < $1.id }
    }
}
