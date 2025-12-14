//
//  PagedResult.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

nonisolated struct PagedResult<T: Equatable & Sendable>: Equatable, Sendable {
    let items: [T]
    let currentPage: Int
    let totalPages: Int
    
    let hasMorePages: Bool
    
    var isFirstPage: Bool {
        currentPage == 0
    }
    
    var isLastPage: Bool {
        currentPage >= totalPages - 1
    }
    
    init(items: [T], currentPage: Int, totalPages: Int, hasMorePages: Bool? = nil) {
        self.items = items
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.hasMorePages = hasMorePages ?? (currentPage < totalPages - 1)
    }
}
