//
//  SearchView.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Company
import ComposableArchitecture
import Domain
import SwiftUI
import WidgetKit

@available(iOS 16.2, *)
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
                    placement: searchablePlacement,
                    prompt: Text(L10n.Placeholder.enterCompanyName)
                )
                .onSubmit(of: .search) {
                    viewStore.send(.search(companyName: searchText))
                }
            } detail: {
                if let company = selectedCompany {
                    CompanyView(
                        store: Store(
                            initialState: CompanyReducer.State(company: company),
                            reducer: CompanyReducer(userDefaults: UserDefaults.group, widgetCenter: WidgetCenter.shared)
                                .dependency(\.geocodeUseCase, GeocodeUseCase())
                        )
                    )
                }
            }
            .errorAlert(error: viewStore.error, buttonTitle: L10n.Common.ok) {
                viewStore.send(.confirmedError)
            }
        }
    }

    private var searchablePlacement: SearchFieldPlacement {
        #if os(iOS)
        return .navigationBarDrawer(displayMode: .always)
        #elseif os(macOS)
        return .automatic
        #endif
    }
}

@available(iOS 16.2, *)
private struct SearchViewwPreviews: PreviewProvider {
    @available(iOS 16.2, *)
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
