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
            case genres
        }
        
        var genres: GenresFeature.State?
        
        var currentRootScreen: RootScreen {
            if genres != nil { return .genres }
            return .genres
        }
        
        init() {
            genres = GenresFeature.State()
        }
    }

    enum Action {
        case genres(GenresFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Reduce { _, action in
            switch action {
            
            case .genres:
                return .none
            }
        }
        .ifLet(\.genres, action: \.genres) {
            GenresFeature()
        }
    }
}
