//
//  ClipView.swift
//  
//
//  Created by AkkeyLab on 2023/02/12.
//

import Company
import ComposableArchitecture
import Domain
import SwiftUI

public struct ClipView: View {
    private let store: StoreOf<SearchCompaniesReducer>
    private let companyName: String

    public init(
        store: StoreOf<SearchCompaniesReducer> = Store(
            initialState: SearchCompaniesReducer.State(),
            reducer: SearchCompaniesReducer()
                .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase())
        ),
        companyName: String
    ) {
        self.store = store
        self.companyName = companyName
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Color(uiColor: .systemBackground)
                .onAppear {
                    viewStore.send(.search(companyName: companyName))
                }
                .overlay {
                    if let company = viewStore.companies.first {
                        CompanyView(
                            store: Store(
                                initialState: CompanyReducer.State(company: company),
                                reducer: CompanyReducer()
                            )
                        )
                    }
                }
        }
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ClipView(
            store: Store(
                initialState: SearchCompaniesReducer.State(),
                reducer: SearchCompaniesReducer()
                    .dependency(\.searchCompaniesUseCase, SearchCompaniesUseCase(gateway: SearchCompaniesGatewayMock()))
            ),
            companyName: ""
        )
    }
}
