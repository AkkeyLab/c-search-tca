//
//  SearchCompaniesReducer.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import ComposableArchitecture

public struct SearchCompaniesReducer: Reducer {
    public struct State: Equatable {
        public static func == (lhs: SearchCompaniesReducer.State, rhs: SearchCompaniesReducer.State) -> Bool {
            lhs.companies == rhs.companies
            && lhs.error.debugDescription == rhs.error.debugDescription
        }

        public var companies: [Company]
        public var error: LocalizedAlertError?

        public init(companies: [Company] = []) {
            self.companies = companies
        }
    }

    public enum Action: Equatable {
        case search(companyName: String)
        case searchResponse(TaskResult<[Company]>)
        case confirmedError
    }

    @Dependency(\.searchCompaniesUseCase) var searchCompaniesUseCase

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .search(companyName):
                return .run { send in
                    let action: Action = await .searchResponse(TaskResult {
                        try await self.searchCompaniesUseCase.search(name: companyName)
                    })
                    await send(action)
                }
            case let .searchResponse(.success(companies)):
                state.companies = companies
                return .none
            case let .searchResponse(.failure(error)):
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

extension SearchCompaniesUseCase: TestDependencyKey {
    public static var testValue = SearchCompaniesUseCase(gateway: SearchCompaniesGatewayMock())
}

extension DependencyValues {
    public var searchCompaniesUseCase: SearchCompaniesUseCase {
        get { self[SearchCompaniesUseCase.self] }
        set { self[SearchCompaniesUseCase.self] = newValue }
    }
}
