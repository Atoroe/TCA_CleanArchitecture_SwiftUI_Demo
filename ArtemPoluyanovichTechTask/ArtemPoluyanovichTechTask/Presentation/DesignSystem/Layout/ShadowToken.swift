//
//  ShadowToken.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

// MARK: - Shadow
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    init(color: Color = .black.opacity(0.2), radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - Predefined Shadows
enum ShadowToken {
    /// Medium shadow - moderate elevation (4dp elevation)
    static let md = Shadow(
        radius: 8,
        y: 4
    )

    // MARK: - Semantic Shadows

    /// Toast shadow (from bottom, so y is negative)
    static let toast = Shadow(
        radius: 8,
        y: -4
    )
}

// MARK: - View Extensions
extension View {
    @MainActor
    func shadow(_ shadow: Shadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}
