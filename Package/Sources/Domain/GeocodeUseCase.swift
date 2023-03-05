//
//  File.swift
//  
//
//  Created by AkkeyLab on 2023/03/06.
//

import CoreLocation
import Data

public protocol GeocodeUseCaseProtocol {
    func geocodeCompanyAddress(_ company: Company) async throws -> [CLLocationCoordinate2D]
}

public final class GeocodeUseCase: GeocodeUseCaseProtocol {
    private let geocoder = CLGeocoder()
    private let repository = CompanyAddressRepository()

    public init() {}

    public func geocodeCompanyAddress(_ company: Company) async throws -> [CLLocationCoordinate2D] {
        let address = company.prefectureName + company.cityName + company.streetNumber
        let cache = try loadFromCache(address: address)
        guard cache.isEmpty else {
            debugPrint("Use cache")
            return cache
        }
        let placemarks = try await geocoder.geocodeAddressString(address, in: nil, preferredLocale: .jp)
        let coordinate = placemarks.compactMap(\.location?.coordinate)
        try? createCache(address: address, coordinate: coordinate)
        debugPrint("Use generate value")
        return coordinate
    }

    private func loadFromCache(address: String) throws -> [CLLocationCoordinate2D] {
        let cache = try repository.load()
        return cache
            .filter { $0.address == address }
            .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private func createCache(address: String, coordinate: [CLLocationCoordinate2D]) throws {
        try coordinate.forEach { coordinate in
            try repository.append(
                address: address,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        }
        try repository.saveIfNeeded()
    }
}

private extension Locale {
    static let jp = Locale(identifier: "ja_JP")
}
