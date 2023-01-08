//
//  SearchCompaniesReducer.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import ComposableArchitecture

public struct SearchCompaniesReducer: ReducerProtocol {
    public struct State: Equatable {
        public var companies: [Company]

        public init(companies: [Company] = []) {
            self.companies = companies
        }
    }

    public enum Action: Equatable {
        case search(companyName: String)
        case searchResponse(TaskResult<[Company]>)
    }

    @Dependency(\.searchCompaniesUseCase) var searchCompaniesUseCase

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .search(companyName):
                return .task {
                    await .searchResponse(TaskResult {
                        try await self.searchCompaniesUseCase.search(name: companyName)
                    })
                }
            case let .searchResponse(.success(companies)):
                state.companies = companies
                return .none
            case let .searchResponse(.failure(error)):
                debugPrint(error)
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
