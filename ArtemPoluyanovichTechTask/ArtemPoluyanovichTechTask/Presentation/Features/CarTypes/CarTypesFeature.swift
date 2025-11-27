//
//  CarTypesFeature.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CarTypesFeature {
    @ObservableState
    struct State: Equatable, Hashable {
        let manufacturer: Manufacturer
        var mainTypes: [MainType] = []
        var currentPage: Int = 0
        var isLoading: Bool = false
        var hasMorePages: Bool = true
        var errorMessage: String?
        var showToast: Bool = false

        var isEmpty: Bool {
            !isLoading && mainTypes.isEmpty && errorMessage == nil
        }

        init(manufacturer: Manufacturer) {
            self.manufacturer = manufacturer
        }
    }

    enum Action: Equatable {
        case onAppear

        case loadNextPage
        case mainTypesLoaded(PagedResult<MainType>)
        case loadFailed(String)
        case toastDismissed
        case selectMainType(MainType)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case mainTypeSelected(manufacturer: Manufacturer, mainType: MainType)
        }
    }
    
    nonisolated enum CancelID: Hashable, Sendable {
        case loading
    }

    @Dependency(\.carsUseCase) var useCase
    @Dependency(\.continuousClock) var clock

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.mainTypes.isEmpty else { return .none }
                return .run { send in
                    await send(.loadNextPage)
                }

            case .loadNextPage:
                guard !state.isLoading && state.hasMorePages else { return .none }
                state.isLoading = true
                state.errorMessage = nil
                let pageToLoad = state.currentPage
                let manufacturerId = state.manufacturer.id
                return .run { send in
                    do {
                        let result = try await useCase.fetchMainTypes(manufacturerId: manufacturerId, page: pageToLoad)
                        await send(.mainTypesLoaded(result))
                    } catch is CancellationError {
                        return
                    } catch let error as AppError {
                        await send(.loadFailed(error.localizedDescription))
                    } catch {
                        await send(.loadFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.loading, cancelInFlight: true) 

            case let .mainTypesLoaded(result):
                state.isLoading = false
                let existingIds = Set(state.mainTypes.map { $0.id })
                let newItems = result.items.filter { !existingIds.contains($0.id) }
                state.mainTypes.append(contentsOf: newItems)
                state.currentPage += 1
                state.hasMorePages = result.hasMorePages
                return .none

            case let .loadFailed(message):
                state.isLoading = false
                state.errorMessage = message
                state.showToast = true
                return .run { send in
                    try? await clock.sleep(for: .seconds(3))
                    await send(.toastDismissed)
                }
            
            case .toastDismissed:
                state.showToast = false
                return .none

            case let .selectMainType(mainType):
                return .send(.delegate(.mainTypeSelected(manufacturer: state.manufacturer, mainType: mainType)))

            case .delegate:
                return .none

            }
        }
    }
}
