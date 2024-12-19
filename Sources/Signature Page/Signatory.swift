//
//  Signatory.swift
//
//  Created by Claude on 06/12/2024.
//

import Foundation
import OrderedCollections
import Languages

public enum Signatory: Hashable, Codable {
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

extension Signatory {
    public typealias Metadata = OrderedDictionary<TranslatedString, String>
}

extension Signatory {
    public struct NaturalPerson: Hashable, Codable {
        public let name: String
        public let metadata: Signatory.Metadata
        
        public init(
            name: String,
            metadata: Signatory.Metadata = [:]
        ) {
            self.name = name
            self.metadata = metadata
        }
    }
}

extension Signatory {
    public struct LegalEntity: Hashable, Codable {
        public let name: String
        public let metadata: Signatory.Metadata
        public let representatives: [Signatory.Representative]
        
        public init(
            name: String,
            metadata: Signatory.Metadata = [:],
            representatives: [Signatory.Representative]
        ) {
            self.name = name
            self.metadata = metadata
            self.representatives = representatives
        }
    }
}

extension Signatory {
    public struct Representative: Hashable, Codable {
        public let signatory: Signatory
        public let capacity: Representative.Capacity
        
        public init(
            signatory: Signatory,
            capacity: Representative.Capacity
        ) {
            self.signatory = signatory
            self.capacity = capacity
        }
        public typealias Capacity = TranslatedString
    }
    
}

extension Signatory.Representative.Capacity {
    public static let director: Self = "director"
}

extension Signatory.NaturalPerson {
    public init(
        name: String,
        title: String? = nil,
        position: String? = nil,
        dateOfBirth: String? = nil
    ) {
        var metadata: Signatory.Metadata = [:]
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
}

extension Signatory {
    static var chainPreview: Self {
        // BV3 (signatory) -> BV2 (director) -> BV1 (director) -> Natural Person (director)
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
                        signatory: .legalEntity(
                            LegalEntity(
                                name: "BV2",
                                metadata: [.registrationNumber: "22222222"],
                                representatives: [
                                    .init(
                                        signatory: .legalEntity(
                                            LegalEntity(
                                                name: "BV1",
                                                metadata: [.registrationNumber: "11111111"],
                                                representatives: [
                                                    .init(
                                                        signatory: .naturalPerson(
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
