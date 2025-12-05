//
//  NavigationStyling.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 17/11/2025.
//

import SwiftUI

struct StandardNavigationStyling: ViewModifier {
    let title: LocalizedStringResource
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.Background.secondary, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

extension View {
    func standardNavigationStyle(title: LocalizedStringResource) -> some View {
        modifier(StandardNavigationStyling(title: title))
    }
}
