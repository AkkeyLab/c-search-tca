//
//  XmlDataParser.swift
//  
//
//  Created by AkkeyLab on 2022/12/30.
//

import APIKit
import Foundation
import XMLCoder

final class XmlDataParser<T: Codable>: DataParser {
    enum Error: Swift.Error {
        case invalidData(Data)
    }

    let encoding: String.Encoding

    init(encoding: String.Encoding = .utf8) {
        self.encoding = encoding
    }

    var contentType: String? {
        nil
    }

    func parse(data: Data) throws -> Any {
        try XMLDecoder().decode(T.self, from: data)
    }
}
