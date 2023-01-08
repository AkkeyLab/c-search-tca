//
//  SearchCompaniesGatewayMock.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Data
import XMLCoder

public final class SearchCompaniesGatewayMock: SearchCompaniesGatewayProtocol {
    public typealias Entity = CompaniesEntity

    public init() {}

    public func search(name: String) async throws -> Entity {
        return try XMLDecoder().decode(Entity.self, from: Entity.mockData!)
    }
}
