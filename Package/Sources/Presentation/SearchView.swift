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
    @Binding private var searchText: String

    public init(store: StoreOf<SearchCompaniesReducer>, searchText: Binding<String>) {
        self.store = store
        self._searchText = searchText
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationSplitView {
                List(viewStore.companies, id: \.id, selection: $selectedCompany) { company in
                    NavigationLink(company.name, value: company)
                }
                .navigationTitle(L10n.NavigationTitle.corporations)
                .searchable(
                    text: $searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text(L10n.Placeholder.enterCompanyName)
                )
                .onSubmit(of: .search) {
                    viewStore.send(.search(companyName: searchText))
                }
            } detail: {
                if let company = selectedCompany {
                    Text(company.name)
                }
            }
            .errorAlert(error: viewStore.error) {
                viewStore.send(.confirmedError)
            }
        }
    }
}

private extension View {
    func errorAlert(error: LocalizedAlertError?, buttonTitle: String = L10n.Common.ok, action: @escaping () -> Void) -> some View {
        alert(isPresented: .constant(error != nil), error: error) { _ in
            Button(buttonTitle, action: action)
        } message: { error in
            Text(error.recoverySuggestion ?? "")
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
            ),
            searchText: .constant("")
        )
    }
}
