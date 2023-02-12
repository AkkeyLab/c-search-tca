//
//  App.swift
//  c-search-clip
//
//  Created by AkkeyLab on 2023/02/12.
//

import ComposableArchitecture
import Domain
import SwiftUI

@main
struct SearchClipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: SearchCompaniesReducer.State(),
                    reducer: SearchCompaniesReducer()
                        .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase())
                )
            )
        }
    }
}
