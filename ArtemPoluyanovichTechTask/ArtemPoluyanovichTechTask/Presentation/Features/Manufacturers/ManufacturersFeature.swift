//
//  ManufacturersFeature.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct ManufacturersFeature {
    @ObservableState
    struct State: Equatable {
        var manufacturers: [Manufacturer] = []
        var currentPage: Int = 0
        var isLoading: Bool = false
        var hasMorePages: Bool = true
        var errorMessage: String?

        var isEmpty: Bool {
            !isLoading && manufacturers.isEmpty && errorMessage == nil
        }

        init() {}
    }

    enum Action {
        case onAppear
        case loadNextPage
        case manufacturersLoaded(PagedResult<Manufacturer>)
        case loadFailed(String)
        case selectManufacturer(Manufacturer)
    }
    
    @Dependency(CarsUseCase.self) var useCase

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.manufacturers.isEmpty && !state.isLoading else { return .none }
                return .run { send in
                    await send(.loadNextPage)
                }

            case .loadNextPage:
                guard !state.isLoading && state.hasMorePages else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                let pageToLoad = state.currentPage
                return .run { send in
                    do {
                        let result = try await useCase.fetchManufacturers(pageToLoad)
                        await send(.manufacturersLoaded(result))
                    } catch let error as AppError {
                        // TODO: present toast
                    } catch {
                        // TODO: present toast
                    }
                }

            case let .manufacturersLoaded(result):
                state.isLoading = false
                state.manufacturers.append(contentsOf: result.items)
                state.currentPage = result.currentPage + 1
                state.hasMorePages = result.hasMorePages
                return .none

            case let .loadFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none

            case let .selectManufacturer(manufacturer):
                // TODO: - push car types screen
                return .none
            }
        }
    }
}
