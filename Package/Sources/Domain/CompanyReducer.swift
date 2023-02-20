//
//  CompanyReducer.swift
//  
//
//  Created by AkkeyLab on 2023/02/21.
//

import ComposableArchitecture
import MapKit

public struct CompanyReducer: ReducerProtocol {
    public struct State: Equatable {
        public static func == (lhs: CompanyReducer.State, rhs: CompanyReducer.State) -> Bool {
            lhs.company == rhs.company
            && lhs.regions == rhs.regions
            && lhs.error.debugDescription == rhs.error.debugDescription
        }

        public let company: Company
        public var regions = [MKCoordinateRegion]()
        public var error: LocalizedAlertError?

        public init(company: Company) {
            self.company = company
        }
    }

    public enum Action: Equatable {
        case geocode
        case geocodeResponse(TaskResult<[CLPlacemark]>)
        case confirmedError
    }

    private let geocoder = CLGeocoder()

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .geocode:
                let company = state.company
                let address = company.prefectureName + company.cityName + company.streetNumber
                return .task {
                    await .geocodeResponse(TaskResult {
                        try await geocoder.geocodeAddressString(address, in: nil, preferredLocale: .jp)
                    })
                }
            case let .geocodeResponse(.success(placemarks)):
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                state.regions = placemarks
                    .compactMap(\.location?.coordinate)
                    .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
                    .map { MKCoordinateRegion(center: $0, span: span) }
                return .none
            case let .geocodeResponse(.failure(error)):
                state.error = LocalizedAlertError(error: error)
                return .none
            case .confirmedError:
                state.error = nil
                return .none
            }
        }
    }

    public init() {}
}

extension MKCoordinateRegion: Identifiable {
    public var id: String {
        "\(center.latitude)\(center.longitude)"
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.id == rhs.id
    }
}

private extension Locale {
    static let jp = Locale(identifier: "ja_JP")
}
