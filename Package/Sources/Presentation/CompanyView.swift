//
//  CompanyView.swift
//  
//
//  Created by AkkeyLab on 2023/02/21.
//

import ComposableArchitecture
import Domain
import MapKit
import SwiftUI

struct CompanyView: View {
    private let store: StoreOf<CompanyReducer>

    public init(store: StoreOf<CompanyReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.company.name)
                ForEach(viewStore.binding(get: { $0.regions }, send: .geocode), id: \.id) { region in
                    Map(
                        coordinateRegion: region,
                        annotationItems: [region],
                        annotationContent: { location in
                            MapMarker(coordinate: location.center.wrappedValue)
                        }
                    )
                }
            }
            .onAppear {
                viewStore.send(.geocode)
            }
            .errorAlert(error: viewStore.error, buttonTitle: L10n.Common.ok) {
                viewStore.send(.confirmedError)
            }
        }
    }
}

//struct CompanyViewPreviews: PreviewProvider {
//    static var previews: some View {
//        CompanyView(company: <#Company#>)
//    }
//}
