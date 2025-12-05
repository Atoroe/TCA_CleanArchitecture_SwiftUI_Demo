//
//  TestStyle.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 05/12/2025.
//

import SwiftUI

/// Typography style tokens with font, color, line height and letter spacing
/// Provides complete text styling in a single token
///
/// # Usage Guidelines
///
/// **Primary use case**: Component API for accepting text styles as parameters
///
/// **When to use TextStyle:**
/// - In Design System components that accept style as parameter
/// - When customizing existing styles (`.body.withColor(...)`)
/// - When building TextStyle-based components
///
/// **When NOT to use TextStyle directly:**
/// - In feature views - use `Text+Extensions` methods instead (`.heading1()`, `.body()`, etc.)
///
/// **Examples:**
/// ```swift
/// // ✅ Component API - passing style as parameter
/// struct CustomInput: View {
///     func textStyle(_ style: TextStyle) -> some View {
///         TextField("", text: $text)
///             .textStyle(style)
///     }
/// }
///
/// // ✅ Style customization
/// Text("Error")
///     .textStyle(.body.withColor(Color.Status.error))
///
/// // ❌ In views - prefer Text+Extensions instead
/// Text("Title").textStyle(.heading1)  // Use .heading1() instead
/// ```
///
/// See `Text+Extensions.swift` for the primary API used in feature views.
public struct TextStyle: Sendable {
    public let font: Font
    public let color: Color
    public let lineSpacing: CGFloat
    public let kerning: CGFloat

    public init(
        font: Font,
        color: Color = Color.Text.primary,
        lineSpacing: CGFloat = 0,
        kerning: CGFloat = 0
    ) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
        self.kerning = kerning
    }
}

// MARK: - Predefined Text Styles

extension TextStyle {
    // MARK: - Display Styles

    public static let display1 = TextStyle(
        font: AppFont.display1,
        color: Color.Text.primary,
        lineSpacing: 8,
        kerning: -0.5
    )

    public static let display2 = TextStyle(
        font: AppFont.display2,
        color: Color.Text.primary,
        lineSpacing: 6,
        kerning: -0.3
    )

    // MARK: - Heading Styles

    public static let heading1 = TextStyle(
        font: AppFont.heading1,
        color: Color.Text.primary,
        lineSpacing: 4,
        kerning: -0.3
    )

    public static let heading2 = TextStyle(
        font: AppFont.heading2,
        color: Color.Text.primary,
        lineSpacing: 4,
        kerning: -0.2
    )

    public static let heading3 = TextStyle(
        font: AppFont.heading3,
        color: Color.Text.primary,
        lineSpacing: 3,
        kerning: -0.1
    )

    public static let heading4 = TextStyle(
        font: AppFont.heading4,
        color: Color.Text.primary,
        lineSpacing: 2,
        kerning: 0
    )

    // MARK: - Body Styles

    public static let bodyLarge = TextStyle(
        font: AppFont.bodyLarge,
        color: Color.Text.primary,
        lineSpacing: 4
    )

    public static let body = TextStyle(
        font: AppFont.body,
        color: Color.Text.primary,
        lineSpacing: 4
    )

    public static let bodySecondary = TextStyle(
        font: AppFont.body,
        color: Color.Text.secondary,
        lineSpacing: 4
    )

    public static let bodySmall = TextStyle(
        font: AppFont.bodySmall,
        color: Color.Text.primary,
        lineSpacing: 3
    )

    public static let bodyBold = TextStyle(
        font: AppFont.bodyBold,
        color: Color.Text.primary,
        lineSpacing: 4
    )

    // MARK: - Caption Styles

    public static let caption = TextStyle(
        font: AppFont.caption,
        color: Color.Text.secondary,
        lineSpacing: 2
    )

    public static let captionBold = TextStyle(
        font: AppFont.captionBold,
        color: Color.Text.primary,
        lineSpacing: 2,
        kerning: 0.3
    )

    public static let overline = TextStyle(
        font: AppFont.overline,
        color: Color.Text.secondary,
        lineSpacing: 1,
        kerning: 1.0
    )
}

// MARK: - Style Modification

extension TextStyle {
    /// Creates a new TextStyle with modified color
    /// - Parameter color: New color to apply
    /// - Returns: New TextStyle with updated color
    public func withColor(_ color: Color) -> TextStyle {
        TextStyle(
            font: self.font,
            color: color,
            lineSpacing: self.lineSpacing,
            kerning: self.kerning
        )
    }

    /// Creates a new TextStyle with modified font
    /// - Parameter font: New font to apply
    /// - Returns: New TextStyle with updated font
    public func withFont(_ font: Font) -> TextStyle {
        TextStyle(
            font: font,
            color: self.color,
            lineSpacing: self.lineSpacing,
            kerning: self.kerning
        )
    }

    /// Creates a new TextStyle with modified line spacing
    /// - Parameter lineSpacing: New line spacing to apply
    /// - Returns: New TextStyle with updated line spacing
    public func withLineSpacing(_ lineSpacing: CGFloat) -> TextStyle {
        TextStyle(
            font: self.font,
            color: self.color,
            lineSpacing: lineSpacing,
            kerning: self.kerning
        )
    }

    /// Creates a new TextStyle with modified kerning
    /// - Parameter kerning: New kerning to apply
    /// - Returns: New TextStyle with updated kerning
    public func withKerning(_ kerning: CGFloat) -> TextStyle {
        TextStyle(
            font: self.font,
            color: self.color,
            lineSpacing: self.lineSpacing,
            kerning: kerning
        )
    }
}
