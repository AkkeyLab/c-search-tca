//
//  SearchCompanyError.swift
//  
//
//  Created by AkkeyLab on 2022/12/30.
//

import Foundation

public enum SearchCompanyError: String, Error {
    case emptyCompanyName = "Search string is empty"
    case apiKeyNotFound = "API Key not found"
}

extension SearchCompanyError: LocalizedError {
    public var errorDescription: String? {
        rawValue
    }
}
