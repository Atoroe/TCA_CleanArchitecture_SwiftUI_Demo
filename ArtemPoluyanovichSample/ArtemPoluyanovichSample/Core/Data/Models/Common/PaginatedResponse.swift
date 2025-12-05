//
//  PaginatedResponse.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

struct PaginatedResponse<T: Codable & Equatable>: Codable, Equatable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [T]
    
    var hasMorePages: Bool {
        next != nil
    }
    
    func calculateTotalPages(pageSize: Int) -> Int {
        guard pageSize > 0 else { return 0 }
        return Int(ceil(Double(count) / Double(pageSize)))
    }
}
