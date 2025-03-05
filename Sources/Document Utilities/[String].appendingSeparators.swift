//
//  [String].appendingSeparators.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 05/03/2025.
//

import Foundation
import Languages

extension [String] {
    public func appendingSeparators(
        standard separator: TranslatedString = ";",
        beforeLast secondLastSeparator: TranslatedString? = .and,
        atEnd lastSeparator: TranslatedString = ","
    ) -> [String] {
        guard !isEmpty else { return [] }
        guard count > 1 else { return [self[0] + lastSeparator.description] }
        
        return enumerated().map { index, element in
            switch index {
            case count - 1:
                return element + lastSeparator.description
            case count - 2:
                if let secondLastSeparator = secondLastSeparator {
                    return element + "\(separator) \(secondLastSeparator) "
                } else {
                    return element + separator.description
                }
            default:
                return element + separator.description + " "
            }
        }
    }
}
