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

#if canImport(WidgetKit)
import WidgetKit
#endif

@available(iOS 16.1, *)
public struct SearchView: View {
    private let store: StoreOf<SearchCompaniesReducer>
    @State private var selectedCompany: Company?
    @Binding private var searchText: String

    public init(store: StoreOf<SearchCompaniesReducer>, searchText: Binding<String>) {
        self.store = store
        self._searchText = searchText
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationSplitView {
                List(viewStore.companies, id: \.id, selection: $selectedCompany) { company in
                    NavigationLink(company.name, value: company)
                }
                .navigationTitle(String(localized: "Corporations", bundle: .module))
                .searchable(
                    text: $searchText,
                    placement: searchablePlacement,
                    prompt: Text("Enter company name", bundle: .module)
                )
                .onSubmit(of: .search) {
                    viewStore.send(.search(companyName: searchText))
                }
            } detail: {
                if let company = selectedCompany {
                    CompanyView(
                        store: Store(initialState: CompanyReducer.State(company: company)) {
                            CompanyReducer(userDefaults: UserDefaults.group)
                                .dependency(\.geocodeUseCase, GeocodeUseCase())
                        }
                    )
                }
            }
            .preference(key: SelectedCompanyPreferenceKey.self, value: selectedCompany)
            .errorAlert(error: viewStore.error, buttonTitle: String(localized: "OK", bundle: .module)) {
                viewStore.send(.confirmedError)
            }
        }
    }

    private var searchablePlacement: SearchFieldPlacement {
        #if os(iOS)
        return .navigationBarDrawer(displayMode: .always)
        #elseif os(macOS)
        return .automatic
        #elseif os(visionOS)
        return .navigationBarDrawer(displayMode: .always)
        #endif
    }
}

@available(iOS 16.1, *)
private struct SearchViewwPreviews: PreviewProvider {
    @available(iOS 16.1, *)
    static var previews: some View {
        SearchView(
            store: Store(initialState: SearchCompaniesReducer.State()) {
                SearchCompaniesReducer()
                    .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase(gateway: SearchCompaniesGatewayMock()))
            },
            searchText: .constant("")
        )
    }
}

@available(iOS 16.1, *)
extension CompanyReducer {
    init(userDefaults: UserDefaultsProtocol) {
        #if os(visionOS)
        struct Dummy: WidgetCenterProtocol {
            func reloadAllTimelines() {}
        }
        self.init(userDefaults: userDefaults, widgetCenter: Dummy())
        #else
        self.init(userDefaults: userDefaults, widgetCenter: WidgetCenter.shared)
        #endif
    }
}
