//
//  SearchCompaniesUseCase.swift
//  
//
//  Created by AkkeyLab on 2022/12/30.
//

import ComposableArchitecture

public protocol SearchCompaniesUseCaseProtocol {
    func search(name: String) async throws -> [Company]
}

public final class SearchCompaniesUseCase: SearchCompaniesUseCaseProtocol {
    private let gateway: SearchCompaniesGatewayProtocol

    public init(gateway: SearchCompaniesGatewayProtocol = SearchCompaniesGateway()) {
        self.gateway = gateway
    }

    public func search(name: String) async throws -> [Company] {
        do {
            let result = try await gateway.search(name: name)
            return result.corporation.enumerated().map(Company.init)
        } catch {
            throw error
        }
    }
}
