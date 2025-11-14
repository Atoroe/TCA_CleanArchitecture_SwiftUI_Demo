//
//  AppFeature.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 14/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        enum RootScreen {
            case manufacturers
        }
    }

    enum Action {
        case manufacturers
    }

    var body: some Reducer<State, Action> {
        Reduce { _, action in
            switch action {
            
            case .manufacturers:
                return .none
            }
        }
    }
}
