//
//  CornerRadiusToken.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

enum CornerRadiusToken {
    // MARK: - Base tokens
    
    /// 4pt
    static let xs: CGFloat = 4

    /// 16pt
    static let lg: CGFloat = 16
    
    // MARK: - Semantic tokens
    
    /// 16pt - toast corner radius
    static let toast: CGFloat = lg
    
    /// 2pt - toast indicator corner radius
    static let toastIndicator: CGFloat = xs / 2
}
