//
//  ToastModifier.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 17/11/2025.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    let errorMessage: String?
    let showToast: Bool
    let onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let errorMessage = errorMessage {
                    ToastView(
                        message: errorMessage,
                        isPresented: Binding(
                            get: { showToast },
                            set: { _ in onDismiss() }
                        )
                    )
                    .ignoresSafeArea(edges: .bottom)
                }
            }
    }
}

extension View {
    func toast(
        errorMessage: String?,
        showToast: Bool,
        onDismiss: @escaping () -> Void
    ) -> some View {
        modifier(ToastModifier(
            errorMessage: errorMessage,
            showToast: showToast,
            onDismiss: onDismiss
        ))
    }
}
