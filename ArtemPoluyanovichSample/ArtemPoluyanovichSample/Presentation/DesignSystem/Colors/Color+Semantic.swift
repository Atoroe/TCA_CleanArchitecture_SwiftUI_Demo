//
//  Color+Semantic.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 05/12/2025.
//

import SwiftUI

// MARK: - Semantic Color Tokens

extension Color {
    // MARK: - Background

    /// Background colors for different interface hierarchy levels.
    /// Used to create visual depth and content separation.
    enum Background {
        /// Primary background color for screens.
        /// Used for the main application container, creates the base interface layer.
        static let primary = Palette.secondary100

        /// Secondary background color (cards, elevated surfaces).
        /// Used to create visual separation between the main background and content.
        static let secondary = Palette.secondary200

        /// Tertiary background color (subtle elevation).
        /// Used for an additional level of visual hierarchy.
        static let tertiary = Palette.neutral200
    }

    // MARK: - Surface

    /// Surface colors for different types of containers and modal windows.
    /// Used to create visual hierarchy between content and background.
    enum Surface {
        /// Card surface color.
        /// Used for cards, lists, and content containers.
        static let card = Palette.neutral200

        /// Elevated surface color (modal windows, sheets).
        /// Used to create visual emphasis of modal windows over main content.
        static let elevated = Palette.neutral300

        /// Semi-transparent overlay surface color.
        /// Used to darken the background under modal windows and dialogs.
        static let overlay = Palette.primaryBlack.opacity(0.6)
    }

    // MARK: - Text

    /// Text colors for different hierarchy levels and states.
    /// Used to ensure readability and visual structure of textual content.
    public enum Text {
        /// Primary text color with maximum contrast.
        /// Used for headings, important content, and primary text requiring high readability.
        /// Automatically adapts to theme (black in light mode, white in dark mode).
        public static let primary = Palette.textPrimary

        /// Secondary text color (medium emphasis, 80% opacity).
        /// Used for subheadings and text of medium importance level.
        static let secondary = Palette.primaryWhite.opacity(0.8)

        /// Tertiary text color (low emphasis, 50% opacity).
        /// Used for auxiliary text, captions, and text with low priority.
        static let tertiary = Palette.primaryWhite.opacity(0.5)

        /// Disabled text color.
        /// Used for text in inactive interface elements.
        static let disabled = Palette.neutral500

        /// Text color on colored backgrounds.
        /// Used for text on buttons and colored surfaces to ensure contrast.
        static let onPrimaryColor = Palette.secondary200

        /// Text color on colored backgrounds.
        /// Used for text on buttons and colored surfaces to ensure contrast.
        static let onColor = Palette.primaryWhite

        /// Input placeholder text color.
        /// Used for placeholder text in input fields.
        static let inputPlaceholder = Palette.primaryWhite.opacity(0.5)

        /// Input error text color.
        /// Used for error text in input fields.
        static let inputError = Palette.error400
    }

    // MARK: - Interactive

    /// Colors for interactive interface elements.
    /// Used for buttons, links, and other elements that users can interact with.
    enum Interactive {
        /// Color for primary interactive elements (CTA buttons).
        /// Used to draw attention to main user actions.
        static let neutral = Palette.neutral200

        /// Primary interactive element color in pressed state.
        /// Used for visual feedback when interacting with buttons.
        static let primaryPressed = Palette.primary300

        /// Primary interactive element color in disabled state.
        /// Used for inactive buttons and control elements.
        static let primaryDisabled = Palette.primary200

        /// Color for secondary interactive elements.
        /// Used for second-level importance buttons and alternative actions.
        static let secondary = Palette.secondary400

        /// Secondary interactive element color in pressed state.
        /// Used for visual feedback when interacting with secondary buttons.
        static let secondaryPressed = Palette.secondary300

        /// Secondary interactive element color in disabled state.
        /// Used for inactive buttons and control elements.
        static let secondaryDisabled = Palette.secondary200

        /// Color for tertiary/ghost buttons.
        /// Used for buttons with minimal visual emphasis when avoiding interface clutter.
        static let tertiary = Palette.neutral400

        /// Link color.
        /// Used for text links and navigation elements.
        static let link = Palette.secondary800
    }

    // MARK: - Border

    /// Border colors for different states and element types.
    /// Used to separate interface elements and provide visual framing.
    enum Border {
        /// Primary border color.
        /// Used for standard interface element borders.
        static let primary = Palette.neutral400

        /// Secondary border color (thin).
        /// Used for thin borders and delicate dividers.
        static let secondary = Palette.neutral300

        /// Border color in focus state.
        /// Used to highlight active input elements or selected components.
        static let focus = Palette.secondary400

        /// Error border color.
        /// Used to visually indicate validation errors and incorrect input.
        static let error = Palette.error400
    }

    // MARK: - Status

    /// Colors for displaying system statuses and states.
    /// Used to inform users about operation results and current state.
    enum Status {
        /// Success status color.
        /// Used to display successful operations, confirmations, and positive results.
        static let success = Palette.success400

        /// Background color for success status.
        /// Used for background indicators of successful operations.
        static let successBackground = Palette.success100

        /// Warning status color.
        /// Used to display warnings and important notifications requiring attention.
        static let warning = Palette.warning400

        /// Background color for warning status.
        /// Used for background indicators of warnings.
        static let warningBackground = Palette.warning100

        /// Error status color.
        /// Used to display errors, critical states, and failed operations.
        static let error = Palette.error400

        /// Background color for error status.
        /// Used for background indicators of errors.
        static let errorBackground = Palette.error100

        /// Info status color.
        /// Used to display informational messages and reference information.
        static let info = Palette.secondary400

        /// Background color for info status.
        /// Used for background indicators of informational messages.
        static let infoBackground = Palette.secondary100
    }

    // MARK: - Special

    /// Special colors for additional interface effects.
    /// Used for shadows, dividers, and loading effects.
    enum Special {
        /// Shadow color.
        /// Used to create shadows on interface elements for depth effect.
        static let shadow = Palette.primaryBlack.opacity(0.25)

        /// Divider color.
        /// Used for visual separation of elements in lists and containers.
        static let divider = Palette.neutral200

        /// Color for shimmer/loading effect.
        /// Used for loading animations and placeholder effects.
        static let shimmer = Palette.neutral400
    }
}
