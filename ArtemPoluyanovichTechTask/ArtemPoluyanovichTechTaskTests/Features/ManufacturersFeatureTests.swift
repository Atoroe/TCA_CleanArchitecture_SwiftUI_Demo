//
//  ManufacturersFeatureTests.swift
//  ArtemPoluyanovichTechTaskTests
//
//  Created by Artiom Poluyanovich on 16/11/2025.
//

@testable import ArtemPoluyanovichTechTask
import ComposableArchitecture
import Clocks
import Foundation
import Testing

@Suite("ManufacturersFeature Tests")
@MainActor
struct ManufacturersFeatureTests {
    
    @Test("onAppear loads first page")
    func onAppearLoadsFirstPage() async throws {
        let firstPageItems = TestDataHelpers.makeTestManufacturers(page: 0)
        let firstPageResult = PagedResult(
            items: firstPageItems,
            currentPage: 0,
            totalPages: 5
        )
        
        let repository = MockCarsRepository()
            .withManufacturers(page: 0, result: firstPageResult)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let store = TestStore(initialState: ManufacturersFeature.State()) {
            ManufacturersFeature()
        } withDependencies: {
            $0.carsUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.onAppear)
        await store.receive(.manufacturersLoaded(firstPageResult))
        
        #expect(store.state.manufacturers.count == 2)
        #expect(store.state.currentPage == 1)
        #expect(store.state.hasMorePages == true)
        #expect(!store.state.isLoading)
    }
    
    @Test("loadNextPage pagination")
    func loadNextPagePagination() async throws {
        let page0Items = [Manufacturer(id: 1, name: "BMW")]
        let page1Items = [Manufacturer(id: 2, name: "Audi")]
        
        let page0Result = PagedResult(items: page0Items, currentPage: 0, totalPages: 3)
        let page1Result = PagedResult(items: page1Items, currentPage: 1, totalPages: 3)
        
        let repository = MockCarsRepository()
            .withManufacturers(page: 0, result: page0Result)
            .withManufacturers(page: 1, result: page1Result)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let store = TestStore(initialState: ManufacturersFeature.State()) {
            ManufacturersFeature()
        } withDependencies: {
            $0.carsUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        await store.receive(.manufacturersLoaded(page0Result))
        #expect(store.state.manufacturers.count == 1)
        #expect(store.state.currentPage == 1)
        
        await store.send(.loadNextPage)
        await store.receive(.manufacturersLoaded(page1Result))
        #expect(store.state.manufacturers.count == 2)
        #expect(store.state.currentPage == 2)
        #expect(store.state.hasMorePages == true)
    }
    
    @Test("loadNextPage deduplicates items")
    func loadNextPageDeduplicatesItems() async throws {
        let existing = Manufacturer(id: 1, name: "BMW")
        var state = ManufacturersFeature.State()
        state.manufacturers = [existing]
        state.currentPage = 1
        
        let duplicateAndNew = PagedResult(
            items: [
                Manufacturer(id: 1, name: "BMW"),
                Manufacturer(id: 2, name: "Audi")
            ],
            currentPage: 1,
            totalPages: 3
        )
        
        let repository = MockCarsRepository()
            .withManufacturers(page: 1, result: duplicateAndNew)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let store = TestStore(initialState: state) {
            ManufacturersFeature()
        } withDependencies: {
            $0.carsUseCase = useCase
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        await store.receive(.manufacturersLoaded(duplicateAndNew))
        
        #expect(store.state.manufacturers.count == 2)
        #expect(store.state.manufacturers.contains { $0.id == 1 })
        #expect(store.state.manufacturers.contains { $0.id == 2 })
    }
    
    @Test("loadFailed shows toast")
    func loadFailedShowsToast() async throws {
        let testError = AppError.network(reason: "Connection lost")
        let repository = MockCarsRepository().withError(testError)
        let useCase = TestDataHelpers.makeUseCase(from: repository)
        
        let clock = TestClock()
        let store = TestStore(initialState: ManufacturersFeature.State()) {
            ManufacturersFeature()
        } withDependencies: {
            $0.carsUseCase = useCase
            $0.continuousClock = clock
        }
        store.exhaustivity = .off
        
        await store.send(.loadNextPage)
        await store.receive(.loadFailed(testError.localizedDescription))
        
        #expect(store.state.errorMessage == testError.localizedDescription)
        #expect(store.state.showToast == true)
        
        await clock.advance(by: .seconds(3))
        await store.receive(.toastDismissed)
        
        #expect(store.state.showToast == false)
    }
    
    @Test("selectManufacturer navigates to CarTypes")
    func selectManufacturerNavigatesToCarTypes() async throws {
        let manufacturer = Manufacturer(id: 120, name: "BMW")
        var state = ManufacturersFeature.State()
        state.manufacturers = [manufacturer]
        
        let store = TestStore(initialState: state) {
            ManufacturersFeature()
        }
        
        await store.send(.selectManufacturer(manufacturer)) {
            $0.path.append(CarTypesFeature.State(manufacturer: manufacturer))
        }
    }
    
    @Test("child delegate shows alert and pops navigation")
    func childDelegateShowsAlertAndPopsNavigation() async throws {
        let manufacturer = Manufacturer(id: 120, name: "BMW")
        let mainType = MainType(id: "45", name: "X5")
        
        var state = ManufacturersFeature.State()
        state.path.append(CarTypesFeature.State(manufacturer: manufacturer))
        
        let store = TestStore(initialState: state) {
            ManufacturersFeature()
        }
        store.exhaustivity = .off
        
        let childId = store.state.path.ids.first!
        await store.send(.path(.element(
            id: childId,
            action: .delegate(.mainTypeSelected(manufacturer: manufacturer, mainType: mainType))
        )))
        
        await store.receive(.mainTypeSelected(manufacturer: manufacturer, mainType: mainType))
        await Task.yield()
        
        #expect(store.state.path.isEmpty)
        #expect(store.state.destination != nil)
        
        if case .alert = store.state.destination {
            await store.send(.destination(.presented(.alert(.dismissed)))) {
                $0.destination = nil
            }
        }
    }
}
