//
//  SearchView.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import ComposableArchitecture
import Domain
import SwiftUI

public struct SearchView: View {
    private let store: StoreOf<SearchCompaniesReducer>
    @State private var selectedCompany: Company?
    @State private var searchText: String = ""

    public init(store: StoreOf<SearchCompaniesReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationSplitView {
                List(viewStore.companies, id: \.id, selection: $selectedCompany) { company in
                    NavigationLink(company.name, value: company)
                }
                .navigationTitle("Corporations")
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Enter company name")
                )
                .onSubmit(of: .search) {
                    viewStore.send(.search(companyName: searchText))
                }
            } detail: {
                if let company = selectedCompany {
                    Text(company.name)
                }
            }
        }
    }
}

private struct SearchViewwPreviews: PreviewProvider {
    static var previews: some View {
        SearchView(
            store: Store(
                initialState: SearchCompaniesReducer.State(),
                reducer: SearchCompaniesReducer()
                    .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase(gateway: SearchCompaniesGatewayMock()))
            )
        )
    }
}
