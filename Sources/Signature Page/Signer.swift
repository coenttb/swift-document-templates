//
//  Signer.swift
//
//  Created by Claude on 06/12/2024.
//

import Foundation
import OrderedCollections
import Languages

/// Represents a single signer entity - either a natural person or legal entity
public enum Signer: Hashable, Codable {
    case naturalPerson(NaturalPerson)
    case legalEntity(LegalEntity)
    
    var name: String {
        switch self {
        case .naturalPerson(let naturalPerson):
            naturalPerson.name
        case .legalEntity(let legalEntity):
            legalEntity.name
        }
    }
}

extension Signer {
    public typealias Metadata = OrderedDictionary<TranslatedString, String>
}

extension Signer {
    public struct NaturalPerson: Hashable, Codable {
        public let name: String
        public let metadata: Signer.Metadata
        public let representatives: [Signer.Representative]
        
        public init(
            name: String,
            metadata: Signer.Metadata = [:],
            representatives: [Signer.Representative] = []
        ) {
            self.name = name
            self.metadata = metadata
            self.representatives = representatives
        }
    }
}

extension Signer {
    public struct LegalEntity: Hashable, Codable {
        public let name: String
        public let metadata: Signer.Metadata
        public let representatives: [Signer.Representative]
        
        public init(
            name: String,
            metadata: Signer.Metadata = [:],
            representatives: [Signer.Representative]
        ) {
            self.name = name
            self.metadata = metadata
            self.representatives = representatives
        }
    }
}

extension Signer {
    public struct Representative: Hashable, Codable {
        public let signer: Signer
        public let capacity: Representative.Capacity
        
        public init(
            signer: Signer,
            capacity: Representative.Capacity
        ) {
            self.signer = signer
            self.capacity = capacity
        }
        public typealias Capacity = TranslatedString
    }
    
}

extension Signer.Representative.Capacity {
    public static let director: Self = "director"
    public static let attorney: Self = TranslatedString(dutch: "Gemachtigde", english: "Attorney")
    public static let agent: Self = TranslatedString(dutch: "Agent", english: "Agent")
}

extension Signer.NaturalPerson {
    public init(
        name: String,
        title: String? = nil,
        position: String? = nil,
        dateOfBirth: String? = nil
    ) {
        var metadata: Signer.Metadata = [:]
        if let title { metadata[.title] = title }
        if let position { metadata[.position] = position }
        if let dateOfBirth { metadata[.dateOfBirth] = dateOfBirth }
        
        self.init(name: name, metadata: metadata)
    }
}

extension TranslatedString {
    public static let title = TranslatedString(dutch: "Titel", english: "Title")
    public static let position = TranslatedString(dutch: "Functie", english: "Position")
    public static let registrationNumber = TranslatedString(dutch: "KvK-nummer", english: "Registration Number")
    public static let dateOfBirth = TranslatedString(dutch: "Geboortedatum", english: "Date of Birth")
    public static let role = TranslatedString(dutch: "Rol", english: "Role")
}

extension Signer {
    static var simple: Self {
        .legalEntity(
            .init(
                name: "Coen B.V.",
                representatives: [
                    .init(
                        signer: .naturalPerson(.init(name: "Coen ten Thije Boonkkamp")),
                        capacity: "Director"
                    ),
                    .init(
                        signer: .naturalPerson(.init(name: "Coen ten Thije Boonkkamp")),
                        capacity: "Director"
                    ),
                ]
            )
        )
    }
    static var chainPreview: Self {
        // BV3 (signer) -> BV2 (director) -> BV1 (director) -> Natural Person (director)
        .legalEntity(
            LegalEntity(
                name: "BV3",
                metadata: [
                    .registrationNumber: "33333333",
                    .init(
                        dutch: "Vestigingsadres",
                        english: "Business Address"
                    ): "Amsterdam"
                ],
                representatives: [
                    .init(
                        signer: .legalEntity(
                            LegalEntity(
                                name: "BV2",
                                metadata: [.registrationNumber: "22222222"],
                                representatives: [
                                    .init(
                                        signer: .legalEntity(
                                            LegalEntity(
                                                name: "BV1",
                                                metadata: [.registrationNumber: "11111111"],
                                                representatives: [
                                                    .init(
                                                        signer: .naturalPerson(
                                                            NaturalPerson(
                                                                name: "John Smith",
                                                                metadata: [
                                                                    .position: "Director",
                                                                    .dateOfBirth: "1980-01-01"
                                                                ]
                                                            )
                                                        ),
                                                        capacity: .director
                                                    )
                                                ]
                                            )
                                        ),
                                        capacity: .director
                                    )
                                ]
                            )
                        ),
                        capacity: .director
                    )
                ]
            )
        )
    }
}
