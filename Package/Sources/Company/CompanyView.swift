//
//  CompanyView.swift
//  
//
//  Created by AkkeyLab on 2023/02/21.
//

import ComposableArchitecture
import Data
import Domain
import MapKit
import SwiftUI

public struct CompanyView: View {
    private let store: StoreOf<CompanyReducer>

    public init(store: StoreOf<CompanyReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.company.name)
                ForEach(viewStore.regions) { region in
                    Map(
                        coordinateRegion: .constant(region),
                        annotationItems: [region],
                        annotationContent: { location in
                            MapMarker(coordinate: location.center)
                        }
                    )
                }
            }
            .onAppear {
                viewStore.send(.geocode)
            }
            .errorAlert(error: viewStore.error, buttonTitle: "OK") {
                viewStore.send(.confirmedError)
            }
        }
    }
}

struct CompanyViewPreviews: PreviewProvider {
    static var previews: some View {
        CompanyView(
            store: Store(
                initialState: CompanyReducer.State(company: Company.mock),
                reducer: CompanyReducer()
                    .dependency(\.geocodeUseCase, GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock()))
            )
        )
    }
}
