//
//  Palette.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

enum Palette {
    // MARK: - Existing Colors
    
    /// Light: #F5F7F8, Dark: #1E2326
    static let navigationBackground = Color("NavigationBackground")
    
    /// Light: #FFFFFF, Dark: #282D32
    static let cellWhite = Color("CellWhite")
    
    /// Light: #F2F2F7, Dark: #32373C
    static let cellAlternate = Color("CellAlternate")
    
    /// Light & Dark: #DC3545
    static let errorToastBackground = Color("ErrorToastBackground")
    
    // MARK: - Primary Colors
    
    static let primaryWhite = Color("PrimaryWhite")
    static let primaryBlack = Color("PrimaryBlack")
    static let primary200 = Color("Primary200")
    static let primary300 = Color("Primary300")
    static let primary400 = Color("Primary400")
    /// Light: Black, Dark: White - Adapts to theme for primary text
    static let textPrimary = Color("TextPrimary")
    
    // MARK: - Secondary Colors
    
    static let secondary100 = Color("Secondary100")
    static let secondary200 = Color("Secondary200")
    static let secondary300 = Color("Secondary300")
    static let secondary400 = Color("Secondary400")
    static let secondary800 = Color("Secondary800")
    
    // MARK: - Neutral Colors
    
    static let neutral200 = Color("Neutral200")
    static let neutral300 = Color("Neutral300")
    static let neutral400 = Color("Neutral400")
    static let neutral500 = Color("Neutral500")
    
    // MARK: - Status Colors
    
    static let error100 = Color("Error100")
    static let error400 = Color("Error400")
    static let success100 = Color("Success100")
    static let success400 = Color("Success400")
    static let warning100 = Color("Warning100")
    static let warning400 = Color("Warning400")
}
