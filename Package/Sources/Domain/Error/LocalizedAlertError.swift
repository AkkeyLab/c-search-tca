//
//  LocalizedAlertError.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Foundation

public struct LocalizedAlertError: LocalizedError {
    private let underlyingError: LocalizedError

    public var errorDescription: String? {
        underlyingError.errorDescription
    }
    public var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    public init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
