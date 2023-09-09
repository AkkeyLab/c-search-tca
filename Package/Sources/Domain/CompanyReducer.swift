//
//  CompanyReducer.swift
//  
//
//  Created by AkkeyLab on 2023/02/21.
//

import ComposableArchitecture
import Data
import MapKit
import XCTestDynamicOverlay

#if os(visionOS)
#else
import WidgetKit
#endif

public protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
}

public protocol WidgetCenterProtocol {
    func reloadAllTimelines()
}

extension UserDefaults: UserDefaultsProtocol {}

#if os(visionOS)
#else
extension WidgetCenter: WidgetCenterProtocol {}
#endif

@available(iOS 16.1, *)
public struct CompanyReducer: Reducer {
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
        case registerToWidget
        case callToCompany
        case cancelCallToCompany
        case confirmedError
    }

    @Dependency(\.activityClient) var activityClient
    @Dependency(\.geocodeUseCase) var geocodeUseCase
    private let userDefaults: UserDefaultsProtocol
    private let widgetCenter: WidgetCenterProtocol

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .geocode:
                let company = state.company
                return .run { send in
                    let action: Action = await .geocodeResponse(TaskResult {
                        try await geocodeUseCase.geocodeCompanyAddress(company)
                    })
                    await send(action)
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
            case .registerToWidget:
                let companyName = state.company.name.applyingTransform(.fullwidthToHalfwidth, reverse: false)
                userDefaults.set(companyName, forKey: "company-name-for-widget")
                widgetCenter.reloadAllTimelines()
                return .none
            case .callToCompany:
                let companyName = state.company.name
                return .run { _ in
                    try await activityClient.request(companyName)
                }

            case .cancelCallToCompany:
                let companyName = state.company.name
                return .run { _ in
                    await activityClient.end(companyName)
                }
            case .confirmedError:
                state.error = nil
                return .none
            }
        }
    }

    public init(userDefaults: UserDefaultsProtocol, widgetCenter: WidgetCenterProtocol) {
        self.userDefaults = userDefaults
        self.widgetCenter = widgetCenter
    }
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
    public static var testValue = GeocodeUseCase(geocoder: CLGeocoderMock(), repository: CompanyAddressRepositoryMock())
}

extension DependencyValues {
    public var geocodeUseCase: GeocodeUseCase {
        get { self[GeocodeUseCase.self] }
        set { self[GeocodeUseCase.self] = newValue }
    }

    @available(iOS 16.1, *)
    var activityClient: ActivityClient {
        get { self[ActivityClient.self] }
        set { self[ActivityClient.self] = newValue }
    }
}

@available(iOS 16.1, *)
struct ActivityClient {
    var request: @Sendable (_ companyName: String) async throws -> Void
    var update: @Sendable (_ companyName: String) async -> Void
    var end: @Sendable (_ companyName: String) async -> Void
}

@available(iOS 16.1, *)
extension ActivityClient: DependencyKey {
    #if canImport(ActivityKit)
    @available(iOS 16.1, *)
    static let liveValue = Self(
        request: { try await ActivityActor.shared.request(companyName: $0) },
        update: { await ActivityActor.shared.update(companyName: $0) },
        end: { await ActivityActor.shared.end(companyName: $0) }
    )
    #else
    static let liveValue = ActivityClient.previewValue
    #endif
}

@available(iOS 16.1, *)
extension ActivityClient: TestDependencyKey {
    static let testValue = Self(
        request: unimplemented("\(Self.self).request"),
        update: unimplemented("\(Self.self).update"),
        end: unimplemented("\(Self.self).end")
    )

    static let previewValue = Self(
        request: { _ in },
        update: { _ in },
        end: { _ in }
    )
}
