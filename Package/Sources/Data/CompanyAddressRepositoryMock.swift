//
//  CompanyAddressRepositoryMock.swift
//  
//
//  Created by AkkeyLab on 2023/03/06.
//

public struct CompanyAddressRepositoryMock: CompanyAddressRepositoryProtocol {
    public init() {}

    public func load<T>() throws -> [T] where T: CompanyAddressEntity {
        []
    }

    public func append(address: String, latitude: Double, longitude: Double) throws {}

    public func saveIfNeeded() throws {}
}
