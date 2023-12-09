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

@available(iOS 16.1, *)
public struct CompanyView: View {
    private let store: StoreOf<CompanyReducer>
    @State private var showDetailView = false
    @Environment(\.openWindow) private var openWindow

    public init(store: StoreOf<CompanyReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if let region = viewStore.regions.first {
                    Map(position: .constant(.region(region))) {
                        MapContentBuilder.buildBlock(
                            Marker(
                                viewStore.company.name,
                                systemImage: "building.2.crop.circle.fill",
                                coordinate: region.center
                            )
                        )
                    }
                    .overlay(alignment: .top) {
                        GeometryReader { proxy in
                            Spacer()
                                .frame(width: proxy.size.width, height: .zero)
                                .background(.ultraThinMaterial)
                        }
                    }
                }
            }
            .toolbar {
                #if canImport(ActivityKit)
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {
                            viewStore.send(.callToCompany)
                        },
                        label: {
                            let labelString = String(
                                localized: "Arrival at the entrance",
                                bundle: .module
                            )
                            Label(labelString, systemImage: "phone.arrow.up.right")
                                .font(.caption)
                        }
                    )
                }
                #endif
                #if os(visionOS)
                ToolbarItem(placement: .topBarTrailing) {
                    windowStyleInfoButton
                }
                #elseif os(macOS)
                ToolbarItemGroup(placement: .navigation) {
                    windowStyleInfoButton
                    registerToWidgetButton {
                        viewStore.send(.registerToWidget)
                    }
                }
                #else
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        windowStyleInfoButton
                    } else {
                        sheetStyleInfoButton
                    }
                    registerToWidgetButton {
                        viewStore.send(.registerToWidget)
                    }
                }
                #endif
            }
            .navigationTitle(viewStore.company.name)
            .onAppear {
                viewStore.send(.geocode)
            }
            .onDisappear {
                viewStore.send(.cancelCallToCompany)
            }
            .errorAlert(error: viewStore.error, buttonTitle: String(localized: "OK", bundle: .module)) {
                viewStore.send(.confirmedError)
            }
            .sheet(isPresented: $showDetailView) {
                CompanyDetailView(company: viewStore.company, showSearchButton: false)
                    .padding(16)
                    .presentationDetents([.medium])
            }
        }
    }

    private var showDetailViewAction: () -> Void {
        { showDetailView = true }
    }

    private var windowStyleInfoButton: some View {
        Button(
            action: {
                openWindow(id: "company-detail")
            },
            label: {
                Image(systemName: "info.bubble")
            }
        )
    }

    private var sheetStyleInfoButton: some View {
        Button(
            action: showDetailViewAction,
            label: {
                Image(systemName: "info.bubble")
            }
        )
    }

    private func registerToWidgetButton(_ action: @escaping () -> Void) -> some View {
        Button(
            action: action,
            label: {
                let labelString = String(
                    localized: "Register to widget",
                    bundle: .module
                )
                Label(labelString, systemImage: "pin")
                    .font(.caption)
            }
        )
    }
}

private struct RectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .multilineTextAlignment(.center)
                .foregroundColor(configuration.isPressed ? .secondary : .primary)
                .padding(.vertical, 8)

            Spacer()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary, lineWidth: 1)
        }
        .scaleEffect(configuration.isPressed ? 0.98 : 1)
        .padding(.horizontal, 16)
    }
}

@available(iOS 16.1, *)
struct CompanyViewPreviews: PreviewProvider {
    @available(iOS 16.1, *)
    static var previews: some View {
        CompanyView(
            store: Store(initialState: CompanyReducer.State(company: Company.mock)) {
                CompanyReducer(userDefaults: UserDefaultsMock(), widgetCenter: WidgetCenterMock())
                    .dependency(\.geocodeUseCase, GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock()))
            }
        )
    }
}
