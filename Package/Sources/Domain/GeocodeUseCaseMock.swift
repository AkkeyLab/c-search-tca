//
//  GeocodeUseCaseMock.swift
//  
//
//  Created by AkkeyLab on 2023/03/06.
//

import CoreLocation

public final class GeocodeUseCaseMock: GeocodeUseCaseProtocol {
    public init() {}

    public func geocodeCompanyAddress(_ company: Company) async throws -> [CLLocationCoordinate2D] {
        []
    }
}
