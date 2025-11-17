//
//  CarTypesView.swift
//  ArtemPoluyanovichTechTask
//
//  Created by Artiom Poluyanovich on 15/11/2025.
//

import ComposableArchitecture
import SwiftUI

// MARK: - CarTypesView
struct CarTypesView: View {
    let store: StoreOf<CarTypesFeature>

    // MARK: Body
    var body: some View {
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
    
    private var indexedTypes: [(Int, MainType)] {
        store.mainTypes.enumerated().map { ($0.offset, $0.element) }
    }
    
    private var listView: some View {
        List {
            ForEach(indexedTypes, id: \.1.id) { index, mainType in
                rowView(index: index, mainType: mainType)
            }

            if store.isLoading {
                LoadingView(style: .inline)
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
    
}

// MARK: CarTypesView Extension
extension CarTypesView {
    enum Localization {
        static let title = LocalizedStringResource(
            "carSelection.carTypes.title",
            defaultValue: "Select Model"
        )
        static let emptyTitle = LocalizedStringResource(
            "carSelection.carTypes.emptyTitle",
            defaultValue: "No car types available"
        )
        static let emptyMessage = LocalizedStringResource(
            "carSelection.carTypes.emptyMessage",
            defaultValue: "There are no car types for this manufacturer"
        )
    }
}
