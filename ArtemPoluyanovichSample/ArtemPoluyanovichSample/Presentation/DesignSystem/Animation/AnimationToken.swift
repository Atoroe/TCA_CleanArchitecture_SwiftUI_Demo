//
//  AnimationToken.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import SwiftUI

// MARK: - AnimationToken
enum AnimationToken {

    // MARK: Duration
    enum Duration {
        /// Standard animation (300ms)
        static let md: Double = 0.3
    }
    
    // MARK: Semantic
    enum Semantic {
        static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
}
