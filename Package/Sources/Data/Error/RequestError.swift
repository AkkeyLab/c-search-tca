//
//  RequestError.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Foundation

public enum RequestError: String, Error {
    case responseNotFound = "Response not found"
}

extension RequestError: LocalizedError {
    public var errorDescription: String? {
        rawValue
    }
}
