//
//  ManufacturersView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import SwiftUI

// MARK: - ManufacturersView
struct ManufacturersView: View {
    @Bindable var store: StoreOf<ManufacturersFeature>

    // MARK: Body
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            contentView
                .standardNavigationStyle(title: Localization.title)
                .toast(
                    errorMessage: store.errorMessage,
                    showToast: store.showToast,
                    onDismiss: { store.send(.toastDismissed) }
                )
                .onAppear {
                    store.send(.onAppear)
                }
        } destination: { store in
            CarTypesView(store: store)
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
    
    // MARK: Private properties
    @ViewBuilder
    private var contentView: some View {
        if store.isEmpty {
            EmptyStateView(
                title: String(localized: Localization.emptyTitle),
                message: String(localized: Localization.emptyMessage)
            )
        } else {
            listView
        }
    }
    
    private var indexedManufacturers: [(Int, Manufacturer)] {
        store.manufacturers.enumerated().map { ($0.offset, $0.element) }
    }
    
    private var listView: some View {
        List {
            ForEach(indexedManufacturers, id: \.1.id) { index, manufacturer in
                rowView(index: index, manufacturer: manufacturer)
            }

            if store.isLoading {
                LoadingView(style: .inline)
            }
        }
        .listStyle(.plain)
    }
    
    private func rowView(index: Int, manufacturer: Manufacturer) -> some View {
        let backgroundColor = index % 2 == 0 ? Palette.cellWhite : Palette.cellAlternate
        
        return Button {
            store.send(.selectManufacturer(manufacturer))
        } label: {
            ListCell(
                backgroundColor: backgroundColor,
                showChevron: true
            ) {
                Text(manufacturer.name)
                    .foregroundColor(.primary)
            }
        }
        .listRowBackground(backgroundColor)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .onAppear {
            if index == store.manufacturers.count - 2 && store.hasMorePages && !store.isLoading {
                store.send(.loadNextPage)
            }
        }
    }
    
}

// MARK: ManufacturersView Extension
extension ManufacturersView {
    enum Localization {
        static let title = LocalizedStringResource(
            "carSelection.manufacturers.title",
            defaultValue: "Select Manufacturer"
        )
        static let emptyTitle = LocalizedStringResource(
            "carSelection.manufacturers.emptyTitle",
            defaultValue: "No manufacturers available"
        )
        static let emptyMessage = LocalizedStringResource(
            "carSelection.manufacturers.emptyMessage",
            defaultValue: "There are no manufacturers to display"
        )
        static let ok = LocalizedStringResource("common.ok", defaultValue: "OK")
        static let cancel = LocalizedStringResource("common.cancel", defaultValue: "Cancel")
        static let loading = LocalizedStringResource("common.loading", defaultValue: "Loading…")
    }
}
