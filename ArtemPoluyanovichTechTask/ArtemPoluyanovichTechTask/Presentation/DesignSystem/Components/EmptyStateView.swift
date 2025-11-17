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
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.designSystemTitle3)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.designSystemBody)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SpacingToken.xl)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
