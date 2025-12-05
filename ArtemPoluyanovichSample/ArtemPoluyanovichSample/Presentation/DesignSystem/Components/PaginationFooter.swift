//
//  PaginationFooter.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 17/11/2025.
//

import SwiftUI

// MARK: - PaginationFooter
struct PaginationFooter: View {
    let isLoading: Bool
    let onLoadMore: () -> Void
    
    var body: some View {
        Group {
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(.vertical, SpacingToken.md)
                    Spacer()
                }
            } else {
                Color.clear
                    .frame(height: 1)
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .id("pagination-footer-\(isLoading)")
        .onAppear {
            if !isLoading {
                onLoadMore()
            }
        }
    }
}
