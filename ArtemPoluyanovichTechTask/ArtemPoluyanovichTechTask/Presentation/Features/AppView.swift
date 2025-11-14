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
        VStack {
            Text("Hello, World!")
        }
    }
}
