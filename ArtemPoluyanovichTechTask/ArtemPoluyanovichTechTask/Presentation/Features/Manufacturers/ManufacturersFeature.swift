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
        var showToast: Bool = false
        var path = StackState<CarTypesFeature.State>()

        @Presents var destination: Destination.State?

        var isEmpty: Bool {
            !isLoading && manufacturers.isEmpty && errorMessage == nil
        }

        init() {}
    }

    enum Action: Equatable {
        case onAppear
        case loadNextPage
        case manufacturersLoaded(PagedResult<Manufacturer>)
        case loadFailed(String)
        case toastDismissed
        case selectManufacturer(Manufacturer)
        case mainTypeSelected(manufacturer: Manufacturer, mainType: MainType)
        case destination(PresentationAction<Destination.Action>)
        case path(StackActionOf<CarTypesFeature>)
        
        enum Alert: Equatable {
            case dismissed
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
                        let result = try await useCase.fetchManufacturers(page: pageToLoad)
                        await send(.manufacturersLoaded(result))
                    } catch is CancellationError {
                        return
                    } catch let error as AppError {
                        await send(.loadFailed(error.localizedDescription))
                    } catch {
                        await send(.loadFailed(error.localizedDescription))
                    }
                }
                .cancellable(id: CancelID.loading, cancelInFlight: true)

            case let .manufacturersLoaded(result):
                state.isLoading = false
                let existingIds = Set(state.manufacturers.map { $0.id })
                let newItems = result.items.filter { !existingIds.contains($0.id) }
                state.manufacturers.append(contentsOf: newItems)
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

            case let .selectManufacturer(manufacturer):
                state.path.append(CarTypesFeature.State(manufacturer: manufacturer))
                return .none

            case let .mainTypeSelected(manufacturer, mainType):
                state.destination = .alert(
                    AlertState {
                        TextState(Localization.selectedTitle)
                    } actions: {
                        ButtonState(action: .dismissed) {
                            TextState(Localization.ok)
                        }
                    } message: {
                        TextState("\(manufacturer.name), \(mainType.name)")
                    }
                )
                return .none

            case .destination(.presented(.alert(.dismissed))):
                state.destination = nil
                return .none
            
            case let .path(.element(id: _, action: .delegate(.mainTypeSelected(manufacturer, mainType)))):
                guard !state.path.isEmpty else { return .none }
                state.path.removeLast()
                return .send(.mainTypeSelected(manufacturer: manufacturer, mainType: mainType))
            
            case .destination, .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination.body
        }
        .forEach(\.path, action: \.path) {
            CarTypesFeature()
        }
    }
}

extension ManufacturersFeature {
    @Reducer
    enum Destination {
        case alert(AlertState<ManufacturersFeature.Action.Alert>)
    }
}

extension ManufacturersFeature.Destination.State: Equatable {}
extension ManufacturersFeature.Destination.Action: Equatable {}

extension ManufacturersFeature {
    enum Localization {
        static let selectedTitle = LocalizedStringResource(
            "carSelection.manufacturers.selected",
            defaultValue: "Selected"
        )
        static let ok = LocalizedStringResource("common.ok", defaultValue: "OK")
    }
}
