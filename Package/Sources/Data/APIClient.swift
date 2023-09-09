//
//  APIClient.swift
//  
//
//  Created by AkkeyLab on 2023/09/09.
//

import XMLCoder

public struct APIClient {
    private let session: Session

    public init(session: Session) {
        self.session = session
    }

    public func send<Request: APIRequest>(request: Request) async throws -> Request.Response {
        let result = try await session.data(for: request.request)
        return try XMLDecoder().decode(Request.Response.self, from: result)
    }
}
