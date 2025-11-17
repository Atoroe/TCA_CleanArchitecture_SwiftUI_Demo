//
//  LoadingView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 17/11/2025.
//

import SwiftUI

struct LoadingView: View {
    enum Style {
        case inline
        case fullScreen
    }
    
    let style: Style
    
    init(style: Style = .inline) {
        self.style = style
    }
    
    var body: some View {
        Group {
            switch style {
            case .inline:
                HStack {
                    Spacer()
                    ProgressView()
                        .padding(SpacingToken.sm)
                    Spacer()
                }
            case .fullScreen:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
