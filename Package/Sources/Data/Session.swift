//
//  Session.swift
//  
//
//  Created by AkkeyLab on 2023/09/10.
//

import Foundation

public protocol Session {
    func data(for request: URLRequest) async throws -> Data
}

extension URLSession: Session {
    public func data(for request: URLRequest) async throws -> Data {
        try await data(for: request).0
    }
}
