//
//  ManufacturersView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import SwiftUI

struct ManufacturersView: View {
    @Bindable var store: StoreOf<ManufacturersFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            contentView
                .navigationTitle("Select Manufacturer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Palette.navigationBackground, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .onAppear {
                    store.send(.onAppear)
                }
        } destination: { store in
            CarTypesView(store: store)
        }
        .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    }
    
    @ViewBuilder
    private var contentView: some View {
        if store.isEmpty {
            EmptyStateView(
                imageName: "building.2.fill",
                title: "No manufacturers available",
                message: "There are no manufacturers to display"
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
                loadingView
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
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .padding(SpacingToken.sm)
            Spacer()
        }
    }
}
