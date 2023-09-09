//
//  APIRequest.swift
//  
//
//  Created by AkkeyLab on 2023/09/10.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
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
        request.httpMethod = method.rawValue
        return request
    }
}
