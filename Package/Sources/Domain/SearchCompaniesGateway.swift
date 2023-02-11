//
//  SearchCompaniesGateway.swift
//  
//
//  Created by AkkeyLab on 2022/12/30.
//

import APIKit
import Data
import Foundation

public protocol SearchCompaniesGatewayProtocol {
    func search(name: String) async throws -> CompaniesEntity
}

public final class SearchCompaniesGateway: SearchCompaniesGatewayProtocol {
    private let sessionAdapter: SessionAdapter

    public init(sessionAdapter: SessionAdapter) {
        self.sessionAdapter = sessionAdapter
    }

    public init() {
        let configuration = URLSessionConfiguration.default
        sessionAdapter = URLSessionAdapter(configuration: configuration)
    }

    public func search(name: String) async throws -> CompaniesEntity {
        guard let fullWidthString = name.applyingTransform(.fullwidthToHalfwidth, reverse: true) else {
            throw SearchCompanyError.emptyCompanyName
        }
        guard let environment = Bundle.main.object(forInfoDictionaryKey: "LSEnvironment") as? [String: String],
              let apiKey = environment["NATIONAL_TAX_AGENCY_API_KEY"],
              !apiKey.isEmpty
        else {
            throw  SearchCompanyError.apiKeyNotFound
        }
        let request = CompaniesRequest(
            apiKey: apiKey,
            name: fullWidthString,
            type: .unicodeXML,
            mode: .partialMatch,
            kind: .normal,
            hasClosed: false
        )
        return try await Session(adapter: sessionAdapter).response(for: request)
    }
}
