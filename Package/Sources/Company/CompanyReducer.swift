//
//  CompanyReducer.swift
//  
//
//  Created by AkkeyLab on 2023/02/21.
//

import ComposableArchitecture
import Domain
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
        case geocodeResponse(TaskResult<[CLLocationCoordinate2D]>)
        case confirmedError
    }

    @Dependency(\.geocodeUseCase) var geocodeUseCase

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .geocode:
                let company = state.company
                return .task {
                    await .geocodeResponse(TaskResult {
                        try await geocodeUseCase.geocodeCompanyAddress(company)
                    })
                }
            case let .geocodeResponse(.success(coordinate)):
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                state.regions = coordinate
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

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(latitude)\(longitude)"
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.id == rhs.id
    }
}

extension GeocodeUseCase: TestDependencyKey {
    public static var testValue = GeocodeUseCase()
}

extension DependencyValues {
    public var geocodeUseCase: GeocodeUseCase {
        get { self[GeocodeUseCase.self] }
        set { self[GeocodeUseCase.self] = newValue }
    }
}
