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
        
        var manufacturers: ManufacturersFeature.State?
        
        var currentRootScreen: RootScreen {
            if manufacturers != nil { return .manufacturers }
            return .manufacturers
        }
        
        init() {
            manufacturers = ManufacturersFeature.State()
        }
    }

    enum Action {
        case manufacturers(ManufacturersFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Reduce { _, action in
            switch action {
            
            case .manufacturers:
                return .none
            }
        }
        .ifLet(\.manufacturers, action: \.manufacturers) {
            ManufacturersFeature()
        }
    }
}
