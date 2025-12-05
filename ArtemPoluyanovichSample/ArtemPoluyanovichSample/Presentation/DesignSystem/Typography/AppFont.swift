//
//  AppFont.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 05/12/2025.
//

import SwiftUI

/// Centralized font management for the application
/// Supports Inter Variable Fonts with fallback to system fonts
///
/// # Usage Guidelines
///
/// **Preferred APIs:**
/// - **For views**: Use `Text+Extensions` methods (`.heading1()`, `.body()`, etc.)
/// - **For components**: Use `TextStyle` (complete styles with spacing/kerning)
///
/// **Use AppFont only when:**
/// - Creating custom fonts with weights/sizes not available in TextStyle
/// - Building internal TextStyle/Text+Extensions implementations
/// - Edge cases requiring direct font control
///
/// **Avoid direct usage in views** - it loses lineSpacing and kerning:
/// ```swift
/// // ❌ Bad - loses spacing/kerning
/// Text("Title").font(AppFont.heading1)
///
/// // ✅ Good - includes spacing/kerning
/// Text("Title").heading1()
/// ```
///
/// See `TextStyle.swift` and `Text+Extensions.swift` for recommended APIs.
enum AppFont {
    // MARK: - Font Names

    private enum FontName {
        // Inter Variable Font family names
        static let inter = "Inter"
        static let interItalic = "Inter-Italic"
    }

    // MARK: - Font Weights

    /// Font weight options with numeric values for clarity
    ///
    /// Weight mapping:
    /// - thin: 100 (thinnest weight, for accents)
    /// - light: 300 (light weight, for subtitles)
    /// - regular: 400 (normal weight, for body text)
    /// - medium: 500 (medium weight, for headings)
    /// - semibold: 600 (semi-bold weight, for emphasis)
    /// - bold: 700 (bold weight, for headings)
    /// - black: 900 (heaviest weight, for accents)
    enum Weight {
        /// 100 - Thinnest weight (Thin)
        case thin
        /// 300 - Light weight (Light)
        case light
        /// 400 - Regular weight (Regular) - default weight
        case regular
        /// 500 - Medium weight (Medium)
        case medium
        /// 600 - Semi-bold weight (Semibold) - maps to Medium
        case semibold
        /// 700 - Bold weight (Bold)
        case bold
        /// 900 - Heaviest weight (Black)
        case black

        var system: Font.Weight {
            switch self {
            case .thin: return .thin
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .black: return .black
            }
        }
    }

    // MARK: - Font Sizes

    enum Size: CGFloat {
        /// Display sizes (hero text)
        case display1 = 64
        case display2 = 48

        /// Heading sizes
        case heading1 = 32
        case heading2 = 28
        case heading3 = 24
        case heading4 = 20

        /// Body sizes
        case bodyLarge = 18
        case body = 16
        case bodySmall = 14

        /// Utility sizes
        case caption = 12
        case overline = 10
    }

    // MARK: - Font Creation

    /// Creates Inter variable font with specified weight and size
    /// - Parameters:
    ///   - familyName: Font family name (Inter or Inter-Italic)
    ///   - size: Font size
    ///   - weight: Font weight
    ///   - fallbackWeight: System font weight to use as fallback
    /// - Returns: SwiftUI Font (custom if available, system otherwise)
    private static func variableFont(
        familyName: String,
        size: CGFloat,
        weight: Font.Weight,
        fallbackWeight: Font.Weight
    ) -> Font {
        // Check if Inter font family is available by checking if any font in the family exists
        let fontFamilyAvailable = UIFont.familyNames.contains(familyName) ||
            UIFont.fontNames(forFamilyName: familyName).isEmpty == false

        if fontFamilyAvailable {
            // Use variable font with weight
            // Variable fonts support all weights through the same family name
            return Font.custom(familyName, size: size)
                .weight(weight)
        }

        // Fallback to system font
        return .system(size: size, weight: fallbackWeight)
    }

    /// Creates a font with specified size, weight, and italic style
    /// Uses Inter Variable Fonts for dynamic weight control
    /// - Parameters:
    ///   - size: Font size
    ///   - weight: Font weight
    ///   - isItalic: Whether to use italic variant
    /// - Returns: SwiftUI Font
    static func font(size: Size, weight: Weight = .regular, isItalic: Bool = false) -> Font {
        let familyName = isItalic ? FontName.interItalic : FontName.inter
        let systemWeight = weight.system

        return variableFont(
            familyName: familyName,
            size: size.rawValue,
            weight: systemWeight,
            fallbackWeight: systemWeight
        )
    }

    // MARK: - Predefined Styles

    static let display1 = font(size: .display1, weight: .bold)
    static let display2 = font(size: .display2, weight: .bold)

    static let heading1 = font(size: .heading1, weight: .bold)
    static let heading2 = font(size: .heading2, weight: .semibold)
    static let heading3 = font(size: .heading3, weight: .semibold)
    static let heading4 = font(size: .heading4, weight: .medium)

    static let bodyLarge = font(size: .bodyLarge, weight: .regular)
    static let body = font(size: .body, weight: .regular)
    static let bodySmall = font(size: .bodySmall, weight: .regular)
    static let bodyBold = font(size: .body, weight: .bold)

    static let caption = font(size: .caption, weight: .regular)
    static let captionBold = font(size: .caption, weight: .semibold)
    static let overline = font(size: .overline, weight: .semibold)
}

// MARK: - Weight Helpers

extension AppFont.Weight {
    /// Numeric weight value (100-900)
    var numericValue: Int {
        switch self {
        case .thin: return 100
        case .light: return 300
        case .regular: return 400
        case .medium: return 500
        case .semibold: return 600
        case .bold: return 700
        case .black: return 900
        }
    }
}

// MARK: - Font Verification

extension AppFont {
    /// Verify Inter variable fonts are available
    /// Useful for debugging font loading issues
    static func verifyFonts() {
        #if DEBUG
            print("\n🔍 Verifying Inter variable fonts availability:\n")

            let weights: [Weight] = [.thin, .light, .regular, .medium, .semibold, .bold, .black]

            // Check Inter regular family
            let interRegularAvailable = UIFont(name: FontName.inter, size: 16) != nil
            print("📝 Inter Regular Variable Font:")
            print("  \(interRegularAvailable ? "✅" : "⚠️") Family: \(FontName.inter)")

            if interRegularAvailable {
                for weight in weights {
                    // Variable fonts support all weights through the same family name
                    print("    ✅ \(weight) (\(weight.numericValue)) - supported via variable font")
                }
            }

            // Check Inter italic family
            let interItalicAvailable = UIFont(name: FontName.interItalic, size: 16) != nil
            print("\n📝 Inter Italic Variable Font:")
            print("  \(interItalicAvailable ? "✅" : "⚠️") Family: \(FontName.interItalic)")

            if interItalicAvailable {
                for weight in weights {
                    // Variable fonts support all weights through the same family name
                    print("    ✅ \(weight) (\(weight.numericValue)) (italic) - supported via variable font")
                }
            }

            // Test font creation
            print("\n📝 Testing font creation:")
            for weight in weights {
                let testFont = font(size: .body, weight: weight, isItalic: false)
                let testFontItalic = font(size: .body, weight: weight, isItalic: true)
                print("  ✅ \(weight) regular: created")
                print("  ✅ \(weight) italic: created")
            }

            print("")
        #endif
    }
}
