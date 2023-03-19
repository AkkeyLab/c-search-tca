//
//  ContentView.swift
//  c-search
//
//  Created by AkkeyLab on 2023/01/08.
//

import ComposableArchitecture
import Domain
import SwiftUI

@available(iOS 16.1, *)
public struct ContentView: View {
    @Binding private var searchText: String

    public init(searchText: Binding<String>) {
        _searchText = searchText
    }

    public var body: some View {
        SearchView(
            store: Store(
                initialState: SearchCompaniesReducer.State(),
                reducer: SearchCompaniesReducer()
                    .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase())
            ),
            searchText: $searchText
        )
    }
}
