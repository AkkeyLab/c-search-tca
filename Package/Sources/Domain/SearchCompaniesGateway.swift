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
        let key = "National Tax Agency API Key"
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: key) as? String, !apiKey.isEmpty else {
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
