//
//  Signatory Group.swift
//
//  Created by Claude on 06/12/2024.
//

import Foundation
import HTML
import OrderedCollections
import PointFreeHTMLTranslating
import Translating

/// Represents a signatory to an agreement, which may be a group of signers or an individual
public enum Signatory: Hashable, Codable {
    /// A group of signers (e.g. a company with representatives)
    case group(name: TranslatedString, signers: [Person], metadata: Metadata)

    /// A single individual signing for themselves (no group header displayed)
    case individual(name: TranslatedString, metadata: Metadata)

}

extension Signatory {
    /// Access the name of the signatory
    public var name: TranslatedString {
        switch self {
        case .group(let name, _, _):
            return name
        case .individual(let name, _):
            return name
        }
    }

    /// Access the people that make up the signatory
    public var people: [Person] {
        switch self {
        case .group(_, let people, _):
            return people
        case .individual(let name, let metadata):
            // Create a person with the same properties
            return [Person(name: name, metadata: metadata)]
        }
    }

    /// Access the metadata of the signatory
    public var metadata: Metadata {
        switch self {
        case .group(_, _, let metadata):
            return metadata
        case .individual(_, let metadata):
            return metadata
        }
    }

    /// Convenience initializer for a signatory group
    public init(
        name: TranslatedString,
        signers: [Person],
        metadata: Metadata = [:]
    ) {
        self = .group(name: name, signers: signers, metadata: metadata)
    }

    /// Convenience initializer for a signatory group with a single Person
    public init(
        name: TranslatedString,
        signer: Person,
        metadata: Metadata = [:]
    ) {
        self = .group(name: name, signers: [signer], metadata: metadata)
    }

    /// Convenience initializer that includes role
    public init(
        name: TranslatedString,
        role: TranslatedString,
        signers: [Person],
        metadata: Metadata = [:]
    ) {
        var metadata = metadata
        metadata[.role] = role
        self = .group(name: name, signers: signers, metadata: metadata)
    }

    /// Create an individual signatory with the given name
    public static func individual(
        name: String,
        title: TranslatedString? = nil,
        position: TranslatedString? = nil,
        metadata: Metadata = [:]
    ) -> Self {
        var fullMetadata = metadata
        if let title { fullMetadata[.title] = title }
        if let position { fullMetadata[.position] = position }
        return .individual(name: TranslatedString(name), metadata: fullMetadata)
    }
    /// Represents a person who can sign
    public struct Person: Hashable, Codable {
        public let name: TranslatedString
        public let metadata: Metadata

        public init(
            name: TranslatedString,
            metadata: Metadata = [:]
        ) {
            self.name = name
            self.metadata = metadata
        }

        /// Create a person with title and position
        public init(
            name: TranslatedString,
            title: TranslatedString? = nil,
            position: TranslatedString? = nil,
            dateOfBirth: Date? = nil
        ) {
            var metadata: Metadata = [:]
            if let title { metadata[.title] = title }
            if let position { metadata[.position] = position }
            if let dateOfBirth { metadata[.dateOfBirth] = .init(dateOfBirth.formatted(date: .numeric, time: .omitted)) }

            self.init(name: name, metadata: metadata)
        }

        /// Rendering block for a person
        public struct Block: HTML {
            private let person: Person
            private let metadata: SignaturePage.Metadata
            private let style: Style

            public init(
                person: Person,
                date: Date? = nil,
                location: String? = nil,
                metadata: SignaturePage.Metadata = [:],
                style: Style = .default
            ) {
                self.person = person
                self.style = style

                var combinedMetadata = metadata
                if let date {
                    combinedMetadata[.date.capitalizingFirstLetter()] = .init(date.formatted(date: .numeric, time: .omitted))
                }
                if let location {
                    combinedMetadata[.location.capitalizingFirstLetter()] = TranslatedString(location)
                }
                self.metadata = combinedMetadata
            }

            public var body: some HTML {
                div {
                    // Person name
                    b { person.name }

                    // Combined metadata
                    if !person.metadata.isEmpty || !metadata.isEmpty {
                        table {
                            // Person metadata
                            HTMLForEach(person.metadata.map { $0 }) { key, value in
                                tr {
                                    td {
                                        key.map { $0.capitalizingFirstLetter() }
                                    }
                                    .width(.px(.init(style.metadataColumnWidth)))
                                    .padding(right: .px(15))
                                    .verticalAlign(.top)

                                    td {
                                        value
                                    }
                                    .verticalAlign(.top)
                                }
                            }

                            // Date/location metadata
                            HTMLForEach(metadata.map { $0 }) { key, value in
                                tr {
                                    td {
                                        key
                                    }
                                    .width(.px(.init(style.metadataColumnWidth)))
                                    .padding(right: .px(15))
                                    .verticalAlign(.top)

                                    td {
                                        value
                                    }
                                    .verticalAlign(.top)
                                }
                            }
                        }
                        .borderCollapse(.collapse)
                        .padding(top: .px(5))
                    }

                    // Signature line
                    div {
                        String(repeating: "_", count: 40)
                    }
                    .padding(vertical: .px(30), horizontal: nil)
                    .maxWidth(.px(300))
                }
                .margin(bottom: .px(15))
            }

            /// Styling options for the individual signatory block
            public struct Style {
                public let metadataColumnWidth: Int

                public init(metadataColumnWidth: Int = 120) {
                    self.metadataColumnWidth = metadataColumnWidth
                }

                public static let `default` = Style()
            }
        }
    }
}

extension Signatory {
    public typealias Metadata = OrderedDictionary<TranslatedString, TranslatedString>
}

// Preview examples
extension Signatory {
    static var preview: Self {
        .group(
            name: TranslatedString(
                dutch: "Acme B.V.",
                english: "Acme Corporation"
            ),
            signers: [
                Person(name: "John Doe", position: "CEO"),
                Person(name: "Jane Smith", position: "CFO")
            ],
            metadata: [
                .registrationNumber: "12345678",
                .role: .seller
            ]
        )
    }

    static var individualExample: Self {
        .individual(
            name: "Coen ten Thije Boonkkamp",
            position: "Developer",
            metadata: [:]
        )
    }
}
