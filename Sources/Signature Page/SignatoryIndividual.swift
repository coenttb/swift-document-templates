//
//  SignatoryIndividual.swift
//
//  Created by Claude on 06/12/2024.
//

import Foundation
import OrderedCollections
import Languages

/// Represents a single signer entity - either a natural person or legal entity
extension Signatory {
    public enum Individual: Hashable, Codable {
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
}


extension Signatory.Individual {
    public typealias Metadata = OrderedDictionary<TranslatedString, TranslatedString>
}

extension Signatory.Individual {
    public struct NaturalPerson: Hashable, Codable {
        public let name: String
        public let metadata: Signatory.Individual.Metadata
        public let representatives: [Signatory.Individual.Representative]
        
        public init(
            name: String,
            metadata: Signatory.Individual.Metadata = [:],
            representatives: [Signatory.Individual.Representative] = []
        ) {
            self.name = name
            self.metadata = metadata
            self.representatives = representatives
        }
    }
}

extension Signatory.Individual {
    public struct LegalEntity: Hashable, Codable {
        public let name: String
        public let metadata: Signatory.Individual.Metadata
        public let representatives: [Signatory.Individual.Representative]
        
        public init(
            name: String,
            metadata: Signatory.Individual.Metadata = [:],
            representatives: [Signatory.Individual.Representative]
        ) {
            self.name = name
            self.metadata = metadata
            self.representatives = representatives
        }
    }
}

extension Signatory.Individual {
    public struct Representative: Hashable, Codable {
        public let signer: Signatory.Individual
        public let capacity: Representative.Capacity
        
        public init(
            signer: Signatory.Individual,
            capacity: Representative.Capacity
        ) {
            self.signer = signer
            self.capacity = capacity
        }
        public typealias Capacity = TranslatedString
    }
}

extension Signatory.Individual.Representative.Capacity {
    public static let director: Self = "director"
    public static let attorney: Self = TranslatedString(dutch: "Gemachtigde", english: "Attorney")
    public static let agent: Self = TranslatedString(dutch: "Agent", english: "Agent")
}

extension Signatory.Individual.NaturalPerson {
    public init(
        name: String,
        title: TranslatedString? = nil,
        position: TranslatedString? = nil,
        dateOfBirth: TranslatedString? = nil
    ) {
        var metadata: Signatory.Individual.Metadata = [:]
        if let title { metadata[.title] = title }
        if let position { metadata[.position] = position }
        if let dateOfBirth { metadata[.dateOfBirth] = dateOfBirth }
        
        self.init(name: name, metadata: metadata)
    }
}


extension Signatory.Individual {
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
