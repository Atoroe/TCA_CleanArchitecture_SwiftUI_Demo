//
//  Text+Extensions.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 05/12/2025.
//

import SwiftUI

// MARK: - Text Style Application

/// Primary Typography API for Feature Views
///
/// # Usage Guidelines
///
/// **✅ PRIMARY API** - Use these methods in feature views (`Features/`)
///
/// This is the **recommended way** to style text in your views. It provides:
/// - Complete styling (font + color + spacing + kerning)
/// - SwiftUI-like syntax (`.heading1()`, `.body()`, etc.)
/// - Consistency across the app
/// - Automatic updates when design tokens change
///
/// **Usage Examples:**
/// ```swift
/// // ✅ Primary API - Use in feature views
/// Text("Welcome")
///     .heading1()
///
/// Text("Description")
///     .bodySecondary()
///
/// Text("Label")
///     .caption()
///
/// // ✅ Color override if needed
/// Text("Custom Color")
///     .heading1()
///     .foregroundColor(.red)
///
/// // ✅ Style customization
/// Text("Error")
///     .body()
///     .textStyle(.body.withColor(Color.Status.error))
/// ```
///
/// **Alternative APIs:**
/// - **For components**: Use `TextStyle` when accepting style as parameter
/// - **For edge cases**: Use `AppFont` only for custom weights/sizes
///
/// **See Also:**
/// - `TextStyle.swift` - Component API for style parameters
/// - `AppFont.swift` - Low-level font API (edge cases only)
extension Text {
    /// Applies a complete text style (font, color, spacing, kerning)
    /// - Parameter style: TextStyle to apply
    /// - Returns: Styled Text view
    func textStyle(_ style: TextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .lineSpacing(style.lineSpacing)
            .kerning(style.kerning)
    }
}

// MARK: - Convenience Modifiers

extension Text {
    // MARK: - Display

    func display1() -> some View {
        textStyle(.display1)
    }

    func display2() -> some View {
        textStyle(.display2)
    }

    // MARK: - Headings

    func heading1() -> some View {
        textStyle(.heading1)
    }

    func heading2() -> some View {
        textStyle(.heading2)
    }

    func heading3() -> some View {
        textStyle(.heading3)
    }

    func heading4() -> some View {
        textStyle(.heading4)
    }

    // MARK: - Body

    func bodyLarge() -> some View {
        textStyle(.bodyLarge)
    }

    func body() -> some View {
        textStyle(.body)
    }

    func bodySecondary() -> some View {
        textStyle(.bodySecondary)
    }

    func bodySmall() -> some View {
        textStyle(.bodySmall)
    }

    func bodyBold() -> some View {
        textStyle(.bodyBold)
    }

    // MARK: - Caption

    func caption() -> some View {
        textStyle(.caption)
    }

    func captionBold() -> some View {
        textStyle(.captionBold)
    }

    func overline() -> some View {
        textStyle(.overline)
    }
}

// MARK: - Color Variants

extension Text {
    /// Applies primary text color
    func primaryText() -> some View {
        foregroundColor(Color.Text.primary)
    }

    /// Applies secondary text color
    func secondaryText() -> some View {
        foregroundColor(Color.Text.secondary)
    }

    /// Applies tertiary text color
    func tertiaryText() -> some View {
        foregroundColor(Color.Text.tertiary)
    }

    /// Applies disabled text color
    func disabledText() -> some View {
        foregroundColor(Color.Text.disabled)
    }
}

// MARK: - TextField Style Support

extension TextField {
    /// Applies a complete text style (font, color, spacing, kerning) to TextField
    /// - Parameter style: TextStyle to apply
    /// - Returns: Styled TextField view
    func textStyle(_ style: TextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .kerning(style.kerning)
    }
}

extension SecureField {
    /// Applies a complete text style (font, color, spacing, kerning) to SecureField
    /// - Parameter style: TextStyle to apply
    /// - Returns: Styled SecureField view
    func textStyle(_ style: TextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .kerning(style.kerning)
    }
}

extension TextEditor {
    /// Applies a complete text style (font, color, spacing, kerning) to TextEditor
    /// - Parameter style: TextStyle to apply
    /// - Returns: Styled TextEditor view
    func textStyle(_ style: TextStyle) -> some View {
        self
            .font(style.font)
            .foregroundColor(style.color)
            .kerning(style.kerning)
    }
}

// MARK: - Preview

#Preview("Text Styles") {
    ScrollView {
        VStack(alignment: .leading, spacing: 24) {
            Group {
                Text("Display 1")
                    .display1()
                Text("Display 2")
                    .display2()
            }

            Divider()

            Group {
                Text("Heading 1")
                    .heading1()
                Text("Heading 2")
                    .heading2()
                Text("Heading 3")
                    .heading3()
                Text("Heading 4")
                    .heading4()
            }

            Divider()

            Group {
                Text("Body Large")
                    .bodyLarge()
                Text("Body")
                    .body()
                Text("Body Secondary")
                    .bodySecondary()
                Text("Body Small")
                    .bodySmall()
                Text("Body Bold")
                    .bodyBold()
            }

            Divider()

            Group {
                Text("Caption")
                    .caption()
                Text("Caption Bold")
                    .captionBold()
                Text("OVERLINE")
                    .overline()
            }
        }
        .padding()
    }
    .background(Color.Background.primary)
}
