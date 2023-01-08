//
//  KeyedDecodingContainer+.swift
//  
//
//  Created by AkkeyLab on 2023/01/09.
//

import Extension
import Foundation

extension KeyedDecodingContainer {
    func decodeDate(template: DateTemplate, forKey: KeyedDecodingContainer.Key) throws -> Date {
        try date(
            template: template,
            forKey: forKey,
            dateString: try decode(String.self, forKey: forKey)
        )
    }

    func decodeDateIfPresent(template: DateTemplate, forKey: KeyedDecodingContainer.Key) throws -> Date? {
        guard let string = try decodeIfPresent(String.self, forKey: forKey),
              !string.isEmpty else {
            return nil
        }

        return try date(template: template, forKey: forKey, dateString: string)
    }

    /// By using this function, empty string is treated as nil
    func decodeStringIfPresent(forKey: KeyedDecodingContainer.Key) throws -> String? {
        guard let string = try decodeIfPresent(String.self, forKey: forKey),
              !string.isEmpty else {
            return nil
        }

        return string
    }

    private func date(template: DateTemplate, forKey: KeyedDecodingContainer.Key, dateString: String) throws -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter().apply {
            $0.calendar = calendar
            $0.locale = .jp
            $0.dateFormat = DateFormatter.dateFormat(
                fromTemplate: template.rawValue,
                options: .zero,
                locale: .jp
            )
        }

        guard let date = formatter.date(from: dateString) else {
            let text = "The date format should be \(template.rawValue), but it is \(dateString)"
            throw DecodingError.dataCorruptedError(
                forKey: forKey,
                in: self,
                debugDescription: text
            )
        }

        return date
    }
}
