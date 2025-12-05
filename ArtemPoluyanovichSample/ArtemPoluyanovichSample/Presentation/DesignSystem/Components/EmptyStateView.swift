//
//  EmptyStateView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: SpacingToken.sm) {
            Image.SFSymbol.car
                .font(.system(size: 64, weight: .light))
                .foregroundColor(Color.Text.secondary)
            
            Text(title)
                .textStyle(.heading3)
                .multilineTextAlignment(.center)
            
            Text(message)
                .textStyle(.bodySecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SpacingToken.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
