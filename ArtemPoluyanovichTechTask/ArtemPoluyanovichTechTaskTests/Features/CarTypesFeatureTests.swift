//
//  CarTypesFeatureTests.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import ComposableArchitecture
import Clocks
import Foundation
import Testing

@Suite("CarTypesFeature Tests")
@MainActor
struct CarTypesFeatureTests {
    
    @Test("onAppear loads first page")
    func onAppearLoadsFirstPage() async throws {
        let manufacturer = TestDataHelpers.makeTestManufacturer()
        let firstPageItems = TestDataHelpers.makeTestMainTypes(page: 0)
        let firstPageResult = PagedResult(
            items: firstPageItems,
            currentPage: 0,
            totalPages: 2
        )
        
        let repository = MockCarsRepository()
            .withMainTypes(page: 0, result: firstPageResult)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let store = TestStore(
            initialState: CarTypesFeature.State(manufacturer: manufacturer)
        ) {
            CarTypesFeature()
        } withDependencies: {
            $0.carsUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(.mainTypesLoaded(firstPageResult))
        
        #expect(store.state.mainTypes.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.hasMorePages == true)
        #expect(!store.state.isLoading)
    }
    
    @Test("loadNextPage pagination")
    func loadNextPagePagination() async throws {
        let manufacturer = TestDataHelpers.makeTestManufacturer()
        let firstPageItems = TestDataHelpers.makeTestMainTypes(page: 0)
        let secondPageItems = TestDataHelpers.makeTestMainTypes(page: 1)
        
        let firstPageResult = PagedResult(
            items: firstPageItems,
            currentPage: 0,
            totalPages: 2
        )
        let secondPageResult = PagedResult(
            items: secondPageItems,
            currentPage: 1,
            totalPages: 2
        )
        
        let repository = MockCarsRepository()
            .withMainTypes(page: 0, result: firstPageResult)
            .withMainTypes(page: 1, result: secondPageResult)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        var initialState = CarTypesFeature.State(manufacturer: manufacturer)
        initialState.mainTypes = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        
        let store = TestStore(initialState: initialState) {
            CarTypesFeature()
        } withDependencies: {
            $0.carsUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        await store.receive(.mainTypesLoaded(secondPageResult))
        
        #expect(store.state.mainTypes.count == 4)
        #expect(store.state.currentPage == 2)
        #expect(store.state.hasMorePages == false)
    }
    
    @Test("selectMainType sends delegate")
    func selectMainTypeSendsDelegate() async throws {
        let manufacturer = TestDataHelpers.makeTestManufacturer()
        let mainType = MainType(id: "1", name: "Type 1")
        
        var initialState = CarTypesFeature.State(manufacturer: manufacturer)
        initialState.mainTypes = [mainType]
        
        let store = TestStore(initialState: initialState) {
            CarTypesFeature()
        }
        
        await store.send(.selectMainType(mainType))
        
        await store.receive(.delegate(.mainTypeSelected(manufacturer: manufacturer, mainType: mainType)))
    }
    
    @Test("loadFailed shows toast")
    func loadFailedShowsToast() async throws {
        let manufacturer = TestDataHelpers.makeTestManufacturer()
        let testError = AppError.network(reason: "Network error")
        let repository = MockCarsRepository().withError(testError)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let clock = TestClock()
        let store = TestStore(
            initialState: CarTypesFeature.State(manufacturer: manufacturer)
        ) {
            CarTypesFeature()
        } withDependencies: {
            $0.carsUseCase = useCase
            $0.continuousClock = clock
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        await store.receive(.loadFailed(testError.localizedDescription))
        
        #expect(store.state.errorMessage == testError.localizedDescription)
        #expect(store.state.showToast == true)
        
        let expectedDuration = max(3, Double(testError.localizedDescription.count) / 20)
        await clock.advance(by: .seconds(expectedDuration))
        await store.receive(.toastDismissed)
        
        #expect(store.state.showToast == false)
    }
}
