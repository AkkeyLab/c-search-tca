//
//  ContentView.swift
//  c-search
//
//  Created by AkkeyLab on 2023/01/08.
//

import ComposableArchitecture
import Domain
import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        SearchView(
            store: Store(
                initialState: SearchCompaniesReducer.State(),
                reducer: SearchCompaniesReducer()
                    .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase())
            )
        )
    }
}
