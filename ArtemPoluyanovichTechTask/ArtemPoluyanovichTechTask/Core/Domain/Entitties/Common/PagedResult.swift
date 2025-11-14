//
//  PagedResult.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import Foundation

struct PagedResult<T: Equatable>: Equatable {
    let items: [T]
    let currentPage: Int
    let totalPages: Int
    
    var hasMorePages: Bool {
        currentPage < totalPages - 1
    }
    
    var isFirstPage: Bool {
        currentPage == 0
    }
    
    var isLastPage: Bool {
        currentPage >= totalPages - 1
    }
    
    init(items: [T], currentPage: Int, totalPages: Int) {
        self.items = items
        self.currentPage = currentPage
        self.totalPages = totalPages
    }
}
