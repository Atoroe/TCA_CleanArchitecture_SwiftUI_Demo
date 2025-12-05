//
//  ListCell.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

struct ListCell<Content: View>: View {
    let content: Content
    let backgroundColor: Color
    let showChevron: Bool
    
    init(
        backgroundColor: Color,
        showChevron: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.showChevron = showChevron
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 0) {
            content
            if showChevron {
                Spacer()
                Image.SFSymbol.chevronRight
                    .foregroundColor(Color.Interactive.link)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.trailing, SpacingToken.sm)
            }
        }
        .padding(.vertical, SpacingToken.xxs)
        .padding(.leading, SpacingToken.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
