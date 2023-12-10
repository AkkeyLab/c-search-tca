//
//  APIRequest.swift
//  
//
//  Created by AkkeyLab on 2023/09/10.
//

import Foundation

public struct Uppercase: Equatable {
    let uppercased: String
}

extension Uppercase: ExpressibleByStringLiteral {
    public init(stringLiteral: String) {
        uppercased = stringLiteral.uppercased()
    }
}

public enum HTTPMethod: Uppercase {
    case get, post, put, delete, patch
}

public protocol APIRequest {
    associatedtype Response: Decodable

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }

    var request: URLRequest { get }
}

extension APIRequest {
    public var request: URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue.uppercased
        return request
    }
}
