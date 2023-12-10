//
//  CompaniesRequest.swift
//  
//
//  Created by AkkeyLab on 2022/12/30.
//

import Foundation

public struct CompaniesRequest: APIRequest {
    public typealias Response = CompaniesEntity

    // https://www.houjin-bangou.nta.go.jp/documents/k-web-api-kinou-gaiyo.pdf#page=24
    public var baseURL: URL {
        URL(string: "https://api.houjin-bangou.nta.go.jp")!
    }

    public var method: HTTPMethod {
        .get
    }

    public var path: String {
        "/4/name"
    }

    public var queryItems: [URLQueryItem] {
        [
            .init(name: "id", value: apiKey),
            .init(name: "name", value: name),
            .init(name: "type", value: type.rawValue),
            .init(name: "mode", value: mode.rawValue),
            .init(name: "kind", value: kind.rawValue),
            .init(name: "close", value: "\(hasClosed ? 1 : Int.zero)")
        ]
    }

    private let apiKey: String
    private let name: String
    private let type: CompanyResponseType
    private let mode: CompanySearchMode
    private let kind: CompanyKind
    private let hasClosed: Bool

    public init(
        apiKey: String,
        name: String,
        type: CompanyResponseType,
        mode: CompanySearchMode,
        kind: CompanyKind,
        hasClosed: Bool
    ) {
        self.apiKey = apiKey
        self.name = name
        self.type = type
        self.mode = mode
        self.kind = kind
        self.hasClosed = hasClosed
    }

    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let response = object as? Response else {
            throw RequestError.responseNotFound
        }
        return response
    }
}
