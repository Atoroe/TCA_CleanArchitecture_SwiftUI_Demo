//
//  ArtemPoluyanovichSampleApp.swift
//  ArtemPoluyanovichSample
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture
import SwiftUI

@main
struct ArtemPoluyanovichSampleApp: App {
    
    let appStore: StoreOf<AppFeature>
    
    init() {
        appStore = Store(initialState: AppFeature.State(), reducer: {
            AppFeature()._printChanges()
        })
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: appStore)
        }
    }
}
