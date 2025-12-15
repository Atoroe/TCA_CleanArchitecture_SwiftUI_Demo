//
//  TransitionToken.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

// MARK: - Basic Transitions
@MainActor
enum TransitionToken {
    
    static let slideFromBottom = AnyTransition.move(edge: .bottom)
        .combined(with: AnyTransition.opacity)
}

// MARK: - View Convenience Extensions
extension View {
    
    func animatedTransition(_ transition: AnyTransition) -> some View {
        self.transition(transition)
    }
}
