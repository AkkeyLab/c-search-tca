//
//  CLGeocoderMock.swift
//  
//
//  Created by AkkeyLab on 2023/03/06.
//

import CoreLocation

public struct CLGeocoderMock: CLGeocoderProtocol {
    public init() {}

    #if os(visionOS)
    public func geocodeAddressString(_ addressString: String) async throws -> [CLLocation] {
        []
    }
    #else
    public func geocodeAddressString(_ addressString: String, in region: CLRegion?, preferredLocale locale: Locale?) async throws -> [CLLocation] {
        []
    }
    #endif
}
