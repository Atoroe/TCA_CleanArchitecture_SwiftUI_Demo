//
//  CarTypesView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import SwiftUI

struct CarTypesView: View {
    let store: StoreOf<CarTypesFeature>

    var body: some View {
        contentView
            .navigationTitle("Select Model")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Palette.navigationBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                store.send(.onAppear)
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if store.isEmpty {
            EmptyStateView(
                imageName: "car.fill",
                title: "No car types available",
                message: "There are no car types for this manufacturer"
            )
        } else {
            listView
        }
    }
    
    private var indexedTypes: [(Int, MainType)] {
        store.mainTypes.enumerated().map { ($0.offset, $0.element) }
    }
    
    private var listView: some View {
        List {
            ForEach(indexedTypes, id: \.1.id) { index, mainType in
                rowView(index: index, mainType: mainType)
            }

            if store.isLoading {
                loadingView
            }
        }
        .listStyle(.plain)
    }
    
    private func rowView(index: Int, mainType: MainType) -> some View {
        let backgroundColor = index % 2 == 0 ? Palette.cellWhite : Palette.cellAlternate
        
        return Button {
            store.send(.selectMainType(mainType))
        } label: {
            ListCell(
                backgroundColor: backgroundColor,
                showChevron: false
            ) {
                Text(mainType.name)
                    .foregroundColor(.primary)
            }
        }
        .listRowBackground(backgroundColor)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .onAppear {
            if index == store.mainTypes.count - 2 && store.hasMorePages && !store.isLoading {
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
