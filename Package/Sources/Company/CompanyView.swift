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
                Button(
                    action: {
                        viewStore.send(.registerToWidget)
                    },
                    label: {
                        Label(L10n.Button.registerToWidget, systemImage: "pin")
                            .font(.caption)
                    }
                )
                .buttonStyle(RectangleButtonStyle())
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

private struct RectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .multilineTextAlignment(.center)
            .foregroundColor(configuration.isPressed ? .secondary : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.primary, lineWidth: 1)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

struct CompanyViewPreviews: PreviewProvider {
    static var previews: some View {
        CompanyView(
            store: Store(
                initialState: CompanyReducer.State(company: Company.mock),
                reducer: CompanyReducer(userDefaults: UserDefaultsMock())
                    .dependency(\.geocodeUseCase, GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock()))
            )
        )
    }
}
