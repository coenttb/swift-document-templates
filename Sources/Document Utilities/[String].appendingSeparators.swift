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
        guard count > 1 else {
            let element = self[0]
            return [element.hasSuffix(lastSeparator.description) ? element : element + lastSeparator.description]
        }

        return enumerated().map { index, element in
            switch index {
            case count - 1:
                return element.hasSuffix(lastSeparator.description) ? element : element + lastSeparator.description
            case count - 2:
                if let secondLastSeparator = secondLastSeparator {
                    let secondLastSeparatorStr = "\(separator) \(secondLastSeparator) "
                    return element.hasSuffix(secondLastSeparatorStr) ? element : element + secondLastSeparatorStr
                } else {
                    return element.hasSuffix(separator.description) ? element : element + separator.description
                }
            default:
                let standardSeparatorStr = separator.description + " "
                return element.hasSuffix(standardSeparatorStr) ? element : element + standardSeparatorStr
            }
        }
    }
}
