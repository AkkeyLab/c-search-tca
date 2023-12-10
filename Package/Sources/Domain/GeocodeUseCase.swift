//
//  GeocodeUseCase.swift
//  
//
//  Created by AkkeyLab on 2023/03/06.
//

import CoreLocation
import Data

public protocol CLGeocoderProtocol {
    #if os(visionOS)
    func geocodeAddressString(_ addressString: String) async throws -> [CLLocation]
    #else
    func geocodeAddressString(_ addressString: String, in region: CLRegion?, preferredLocale locale: Locale?) async throws -> [CLLocation]
    #endif
}

public protocol GeocodeUseCaseProtocol {
    func geocodeCompanyAddress(_ company: Company) async throws -> [CLLocationCoordinate2D]
}

public final class GeocodeUseCase: GeocodeUseCaseProtocol {
    private let geocoder: CLGeocoderProtocol
    private let repository: CompanyAddressRepositoryProtocol

    public init(geocoder: CLGeocoderProtocol = CLGeocoder(), repository: CompanyAddressRepositoryProtocol = CompanyAddressRepository.shared) {
        self.geocoder = geocoder
        self.repository = repository
    }

    public func geocodeCompanyAddress(_ company: Company) async throws -> [CLLocationCoordinate2D] {
        let address = company.prefectureName + company.cityName + company.streetNumber
        let cache = try loadFromCache(address: address)
        guard cache.isEmpty else {
            return cache
        }
        let placemarks: [CLLocation] = try await {
            #if os(visionOS)
            try await geocoder.geocodeAddressString(address)
            #else
            try await geocoder.geocodeAddressString(address, in: nil, preferredLocale: .jp)
            #endif
        }()
        let coordinate = placemarks.map(\.coordinate)
        try? createCache(address: address, coordinate: coordinate)
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

extension CLGeocoder: CLGeocoderProtocol {
    #if os(visionOS)
    public func geocodeAddressString(_ addressString: String) async throws -> [CLLocation] {
        try await geocodeAddressString(addressString)
            .compactMap(\.location)
    }
    #else
    public func geocodeAddressString(_ addressString: String, in region: CLRegion?, preferredLocale locale: Locale?) async throws -> [CLLocation] {
        try await geocodeAddressString(addressString, in: region, preferredLocale: locale)
            .compactMap(\.location)
    }
    #endif
}
