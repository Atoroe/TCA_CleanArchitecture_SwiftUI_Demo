//
//  ManufacturerModel+Mapper.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

extension ManufacturerModel {
    func toDomain() -> Manufacturer {
        Manufacturer(id: self.id, name: self.name)
    }
    
    static func toDomain(_ models: [ManufacturerModel]) -> [Manufacturer] {
        models.map { $0.toDomain() }
    }

    static func fromWkdaDictionary(_ wkda: [String: String]) -> [ManufacturerModel] {
        wkda
            .compactMap { ManufacturerModel(key: $0.key, value: $0.value) }
            .sorted { $0.id < $1.id }
    }
}
