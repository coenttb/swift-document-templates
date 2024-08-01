//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Foundation
import HTML
import Internal
import Languages
import OrderedCollections

extension TranslatedString {
    public static let perEmail: Self = .init(
        dutch: "Verzonden per email",
        english: "Send via email"
    )
}

extension Letter {
    public struct Recipient: Hashable, Equatable, Codable {
        public let name: String
        public let address: [String]
        public let metadata: Metadata

        public typealias Metadata = OrderedDictionary<TranslatedString, String>

        public init(
            name: String,
            address: [String],
            metadata: Metadata = [:]
        ) {
            self.name = name
            self.address = address
            self.metadata = metadata
        }

        public init(
            name: String,
            address: [String],
            emails: [String]
        ) {

            var metadata: Metadata = [:]
            metadata[.perEmail] = emails.joined(separator: ", and")

            self = .init(
                name: name,
                address: address,
                metadata: metadata
            )
        }
    }
}

extension Letter.Recipient {
    public static func mock() -> Self {
        .init(name: "Mock", address: [])
    }

    public static var empty: Self { .init(name: "", address: []) }

    package static var preview: Self {
        .init(
            name: "Preview Recipient B.V.",
            address: ["Postbus 4050", "3006 AB Rotterdam", "Nederland"]
        )
    }
}

extension Letter.Recipient: HTML {
    public var body: some HTML {
        b { "\(self.name)" }

        br()
        HTMLForEach(self.address) { line in
            "\(line)"
            br()
        }
        table {
            HTMLForEach(self.metadata.map { $0 }) { (key, value) in
                tr {
                    td {
                        small { "\(key)" }
                    }
                    .inlineStyle("text-align", "right")
                    .inlineStyle("vertical-align", "top")
                    .inlineStyle("padding-right", "15px")

                    td { "\(value)" }
                }
            }
        }
        .inlineStyle("border-collapse", "collapse")
    }
}
