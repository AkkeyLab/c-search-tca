//
//  SearchCompaniesGateway.swift
//  
//
//  Created by AkkeyLab on 2022/12/30.
//

import Data
import Foundation

public protocol SearchCompaniesGatewayProtocol {
    func search(name: String) async throws -> CompaniesEntity
}

public final class SearchCompaniesGateway: SearchCompaniesGatewayProtocol {
    private let client: APIClient

    public init(session: Session = URLSession(configuration: .default)) {
        client = APIClient(session: session)
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
        return try await client.send(request: request)
    }
}
