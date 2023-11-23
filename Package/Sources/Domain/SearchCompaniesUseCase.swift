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
            return result.corporation.enumerated().map { id, entity in
                let halfWidthName = entity.name.applyingTransform(.fullwidthToHalfwidth, reverse: false) ?? entity.name
                return .init(
                    id: id,
                    corporateNumber: entity.corporateNumber,
                    name: halfWidthName,
                    prefectureName: entity.prefectureName,
                    cityName: entity.cityName,
                    streetNumber: entity.streetNumber,
                    postCode: entity.postCode,
                    furigana: entity.furigana
                )
            }
        } catch {
            throw error
        }
    }
}
