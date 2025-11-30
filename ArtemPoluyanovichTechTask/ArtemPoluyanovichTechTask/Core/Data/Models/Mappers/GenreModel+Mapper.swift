//
//  GenreModel+Mapper.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

extension GenreModel {
    func toDomain() -> Genre {
        Genre(id: String(self.id), name: self.name)
    }
    
    static func toDomain(_ models: [GenreModel]) -> [Genre] {
        models.map { $0.toDomain() }
    }
}
