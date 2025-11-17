//
//  Image+SF.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

extension Image {
    enum SFSymbol {
        static let chevronRight = Image(systemName: "chevron.right")
        static let car = Image(systemName: "car.fill")
        static let circleExclamationmark = Image(systemName: "exclamationmark.circle.fill")
    }
}

// MARK: - View Extension

extension View {
    func iconStyle(size: CGFloat = 24, color: Color = .primary) -> some View {
        self
            .font(.system(size: size))
            .foregroundColor(color)
    }
}
