//
//  PaginatedResponse.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

// MARK: - Paginated Response
struct PaginatedResponse<T: Codable & Equatable>: Codable, Equatable {
    let page: Int
    let pageSize: Int
    let totalPageCount: Int
    let wkda: T
    
    var hasMorePages: Bool {
        page < totalPageCount - 1
    }
    
    init(page: Int, pageSize: Int, totalPageCount: Int, wkda: T) {
        self.page = page
        self.pageSize = pageSize
        self.totalPageCount = totalPageCount
        self.wkda = wkda
    }
}
