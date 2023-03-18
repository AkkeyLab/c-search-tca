//
//  CompanyReducer.swift
//  
//
//  Created by AkkeyLab on 2023/02/21.
//

import Activity
import ActivityKit
import ComposableArchitecture
import Data
import MapKit
import WidgetKit

public protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
}

public protocol WidgetCenterProtocol {
    func reloadAllTimelines()
}

extension UserDefaults: UserDefaultsProtocol {}

extension WidgetCenter: WidgetCenterProtocol {}

@available(iOS 16.1, *)
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

        fileprivate var activity: Activity<VisitAttributes>?

        public init(company: Company) {
            self.company = company
        }
    }

    public enum Action: Equatable {
        case geocode
        case geocodeResponse(TaskResult<[CLLocationCoordinate2D]>)
        case registerToWidget
        case callToCompany
        case confirmedError
    }

    @Dependency(\.geocodeUseCase) var geocodeUseCase
    private let userDefaults: UserDefaultsProtocol
    private let widgetCenter: WidgetCenterProtocol

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
            case .registerToWidget:
                let companyName = state.company.name.applyingTransform(.fullwidthToHalfwidth, reverse: false)
                userDefaults.set(companyName, forKey: "company-name-for-widget")
                widgetCenter.reloadAllTimelines()
                return .none
            case .callToCompany:
                guard #available(iOS 16.2, *) else {
                    return .none
                }
                guard let activity = state.activity else {
                    let attributes = VisitAttributes(name: "Me")
                    let contentState = VisitAttributes.ContentState(value: 3)
                    let staleDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
                    let content = ActivityContent(state: contentState, staleDate: staleDate)
                    do {
                        state.activity = try Activity<VisitAttributes>.request(attributes: attributes, content: content)
                    } catch {
                        state.error = LocalizedAlertError(error: error)
                    }
                    return .none
                }
                return .fireAndForget {
                    await activity.end()
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
}
