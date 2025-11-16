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
struct CarTypesFeatureTests {
    
    // MARK: - Tests
    
    @Test("onAppear loads first page")
    @MainActor
    func test_onAppear_loadsFirstPage() async throws {
        let manufacturer = TestDataHelpers.makeTestManufacturer()
        let firstPageItems = TestDataHelpers.makeTestMainTypes(page: 0)
        let firstPageResult = PagedResult(
            items: firstPageItems,
            currentPage: 0,
            totalPages: 2
        )
        
        let mockUseCase = TestDataHelpers.makeMockUseCase(firstPageResult: firstPageResult)
        
        let store = TestStore(
            initialState: CarTypesFeature.State(manufacturer: manufacturer)
        ) {
            CarTypesFeature()
        } withDependencies: {
            $0.carsUseCase = mockUseCase
        }
        
        await store.send(.onAppear)
        
        await store.receive(.loadNextPage) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.mainTypesLoaded(firstPageResult)) {
            $0.isLoading = false
            $0.mainTypes = firstPageItems
            $0.currentPage = 1
            $0.hasMorePages = true
        }
    }
    
    @Test("loadNextPage pagination")
    @MainActor
    func test_loadNextPage_pagination() async throws {
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
        
        let mockUseCase = TestDataHelpers.makeMockUseCase(
            firstPageResult: firstPageResult,
            secondPageResult: secondPageResult
        )
        
        var initialState = CarTypesFeature.State(manufacturer: manufacturer)
        initialState.mainTypes = firstPageItems
        initialState.currentPage = 1
        initialState.hasMorePages = true
        
        let store = TestStore(initialState: initialState) {
            CarTypesFeature()
        } withDependencies: {
            $0.carsUseCase = mockUseCase
        }
        
        await store.send(.loadNextPage) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.mainTypesLoaded(secondPageResult)) {
            $0.isLoading = false
            $0.mainTypes = firstPageItems + secondPageItems
            $0.currentPage = 2
            $0.hasMorePages = false
        }
    }
    
    @Test("selectMainType sends delegate")
    @MainActor
    func test_selectMainType_sendsDelegate() async throws {
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
    @MainActor
    func test_loadFailed_showsToast() async throws {
        let manufacturer = TestDataHelpers.makeTestManufacturer()
        let testError = AppError.network(reason: "Network error")
        let mockUseCase = TestDataHelpers.makeMockUseCase(shouldThrowError: true, error: testError)
        
        let clock = TestClock()
        
        let store = TestStore(
            initialState: CarTypesFeature.State(manufacturer: manufacturer)
        ) {
            CarTypesFeature()
        } withDependencies: {
            $0.carsUseCase = mockUseCase
            $0.continuousClock = clock
        }
        
        await store.send(.loadNextPage) {
            $0.isLoading = true
            $0.errorMessage = nil
        }
        
        await store.receive(.loadFailed(testError.localizedDescription)) {
            $0.isLoading = false
            $0.errorMessage = testError.localizedDescription
            $0.showToast = true
        }
        
        await clock.advance(by: .seconds(3))
        
        await store.receive(.toastDismissed) {
            $0.showToast = false
        }
    }
}

