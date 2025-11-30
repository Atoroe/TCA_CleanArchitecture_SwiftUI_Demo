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
                store.scope(state: \.genres, action: \.genres)
            ) { genresStore in
                GenresView(store: genresStore)
            } else: {
                LoadingView(style: .fullScreen)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: store.currentRootScreen)
    }
}
