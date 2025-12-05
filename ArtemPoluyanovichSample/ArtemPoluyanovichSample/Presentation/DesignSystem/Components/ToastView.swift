//
//  ToastView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        if isPresented {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    Spacer()
                    
                    VStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: CornerRadiusToken.toastIndicator)
                            .fill(Color.Text.onColor.opacity(0.4))
                            .frame(width: 36, height: 5)
                            .padding(.top, SpacingToken.xxs)
                        
                        VStack(alignment: .leading, spacing: SpacingToken.xxs) {
                            HStack(spacing: SpacingToken.xxs) {
                                Image.SFSymbol.circleExclamationmark
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(Color.Text.onColor)
                                
                                Text(Localization.error)
                                    .font(.headline)
                                    .foregroundColor(Color.Text.onColor)
                            }
                            
                            Text(message)
                                .textStyle(.body.withColor(Color.Text.onColor.opacity(0.9)))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, SpacingToken.sm)
                        .padding(.top, SpacingToken.xs)
                        .padding(.bottom, SpacingToken.md + geometry.safeAreaInsets.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.Status.errorBackground)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: CornerRadiusToken.toast,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: CornerRadiusToken.toast
                        )
                    )
                    .shadow(ShadowToken.toast)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .transition(TransitionToken.slideFromBottom)
            .animation(AnimationToken.Semantic.spring, value: isPresented)
        }
    }
}

extension ToastView {
    enum Localization {
        static let error = LocalizedStringResource("common.error", defaultValue: "Error")
    }
}
