//
//  SearchCompaniesUseCaseMock.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

public final class SearchCompaniesUseCaseMock: SearchCompaniesUseCaseProtocol {
    private let gateway: SearchCompaniesGatewayProtocol

    public init(gateway: SearchCompaniesGatewayProtocol) {
        self.gateway = gateway
    }

    public func search(name: String) async throws -> [Company] {
        let entity = try await gateway.search(name: "")
        return entity.corporation.enumerated().map(Company.init)
    }
}
