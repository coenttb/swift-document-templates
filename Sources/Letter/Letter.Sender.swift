//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Foundation
import HTML
import Translating
import OrderedCollections
import PointFreeHTMLTranslating

extension Letter {
    public struct Sender: Hashable, Equatable, Codable {
        public let name: String
        public let address: [String]
        public let metadata: Metadata

        public init(
            name: String,
            address: [String],
            metadata: Metadata
        ) {
            self.name = name
            self.address = address
            self.metadata = metadata
        }

        public typealias Metadata = OrderedDictionary<TranslatedString, String>

        public init(
            name: String,
            address: [String],
            phone: String? = nil,
            email: String? = nil,
            website: String? = nil,
            kvk: String? = nil,
            btw: String? = nil,
            iban: String? = nil,
            on_behalf_of: String? = nil
        ) {
            self.name = name
            self.address = address
            var tempMetadata: Metadata = [:]

            if let phone = phone {
                tempMetadata[.phone] = phone
            }
            if let email = email {
                tempMetadata[.email] = email
            }
            if let website = website {
                tempMetadata[.website] = website
            }
            if let kvk = kvk {
                tempMetadata[.kvk] = kvk
            }
            if let btw = btw {
                tempMetadata[.btw] = btw
            }
            if let iban = iban {
                tempMetadata[.iban] = iban
            }
            if let on_behalf_of = on_behalf_of {
                tempMetadata["on_behalf_of"] = on_behalf_of
            }

            self.metadata = tempMetadata
        }
    }
}

extension Letter.Sender: HTML {
    public var body: some HTML {

        h3 { "\(self.name)" }
            .inlineStyle("margin-top", "0")
            .inlineStyle("margin-bottom", "0")
            .inlineStyle("text-align", "right")

        table {
            tr {
                td {}
                td {
                    HTMLForEach(self.address) { line in
                        small { "\(line)" }
                        br()()
                    }
                }
            }
            HTMLForEach(self.metadata.map { $0 }) { (key, value) in
                tr {
                    td {
                        small { "\(key)" }
                    }
                    .inlineStyle("text-align", "right")
                    .inlineStyle("vertical-align", "top")
                    .inlineStyle("padding-right", "10px")

                    td { small { "\(value)" } }
                }
            }
        }
        .inlineStyle("border-collapse", "collapse")
    }
}

extension Letter.Sender {
    public static var empty: Self {.init(name: "", address: [])}

    package static var preview: Self {
        .init(
            name: "Preview Invoice B.V.",
            address: [
                "Straat 1",
                "3544 CV Utrecht",
                "Nederland"
            ],
            phone: "+31 6 43901430",
            email: "info@previewfactuur.nl",
            website: "www.previewfactuur.nl",
            kvk: "87657654",
            btw: "BLBTW098765432",
            iban: "NLBUNG12345678"
        )
    }
}

#if os(macOS) && canImport(SwiftUI)
import SwiftUI
#Preview {
    HTMLDocument {
        Letter.Sender.preview
    }
    .frame(width: 451, height: 698)
}
#endif
