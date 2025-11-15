//
//  AppView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        Group {
            IfLetStore(
                store.scope(state: \.manufacturers, action: \.manufacturers)
            ) { manufacturersStore in
                ManufacturersView(store: manufacturersStore)
            } else: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: store.currentRootScreen)
    }
}
