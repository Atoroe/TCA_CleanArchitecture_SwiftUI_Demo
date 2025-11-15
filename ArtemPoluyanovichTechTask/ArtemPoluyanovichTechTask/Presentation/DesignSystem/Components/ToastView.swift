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
                            .fill(Color.white.opacity(0.4))
                            .frame(width: 36, height: 5)
                            .padding(.top, SpacingToken.xxs)
                        
                        VStack(alignment: .leading, spacing: SpacingToken.xxs) {
                            HStack(spacing: SpacingToken.xxs) {
                                Image.SF.circleExclamationmark
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Text(Localization.error)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            
                            Text(message)
                                .font(.designSystemBody)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, SpacingToken.sm)
                        .padding(.top, SpacingToken.xs)
                        .padding(.bottom, SpacingToken.md + geometry.safeAreaInsets.bottom)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Palette.errorToastBackground)
                    .clipShape(TopRoundedRectangle(cornerRadius: CornerRadiusToken.toast))
                    .shadow(ShadowToken.toast)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .transition(TransitionToken.slideFromBottom)
            .animation(AnimationToken.Semantic.spring, value: isPresented)
        }
    }
}

struct TopRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addArc(
            center: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.closeSubpath()
        
        return path
    }
}

extension ToastView {
    enum Localization {
        static let error = LocalizedStringResource("common.error", defaultValue: "Error")
    }
}
