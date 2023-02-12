//
//  ContentView.swift
//  c-search-clip
//
//  Created by AkkeyLab on 2023/02/12.
//

import ComposableArchitecture
import Domain
import SwiftUI

struct ContentView: View {
    private let store: StoreOf<SearchCompaniesReducer>

    public init(store: StoreOf<SearchCompaniesReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            if let company = viewStore.companies.first {
                Text(company.name)
            } else {
                Spacer()
                    .onAppear {
                        viewStore.send(.search(companyName: "AkkeyLab"))
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: SearchCompaniesReducer.State(),
                reducer: SearchCompaniesReducer()
                    .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase(gateway: SearchCompaniesGatewayMock()))
            )
        )
    }
}
