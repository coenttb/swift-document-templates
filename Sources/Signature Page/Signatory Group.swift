//
//  Signatory Group.swift
//
//  Created by Claude on 06/12/2024.
//

import Foundation
import OrderedCollections
import Languages

/// Represents a signatory group to an agreement, which may consist of one or more signers
public struct SignatoryGroup: Hashable, Codable {
    public let name: TranslatedString
    public let signers: [Signer]
    public let metadata: SignatoryGroup.Metadata
    
    public init(
        name: TranslatedString,
        signers: [Signer],
        metadata: SignatoryGroup.Metadata = [:]
    ) {
        self.name = name
        self.signers = signers
        self.metadata = metadata
    }
    
    /// Convenience initializer for a signatory group with a single signer
    public init(
        name: TranslatedString,
        signer: Signer,
        metadata: SignatoryGroup.Metadata = [:]
    ) {
        self.init(
            name: name,
            signers: [signer],
            metadata: metadata
        )
    }
    
    /// Convenience initializer that includes role
    public init(
        name: TranslatedString,
        role: TranslatedString,
        signers: [Signer],
        metadata: SignatoryGroup.Metadata = [:]
    ) {
        var metadata = metadata
        metadata[.role] = role.english
        self.init(
            name: name,
            signers: signers,
            metadata: metadata
        )
    }
}

extension SignatoryGroup {
    public typealias Metadata = OrderedDictionary<TranslatedString, String>
}

// Standard signatory roles
extension TranslatedString {
    public static let seller = TranslatedString(dutch: "Verkoper", english: "Seller")
    public static let buyer = TranslatedString(dutch: "Koper", english: "Buyer")
    public static let lessor = TranslatedString(dutch: "Verhuurder", english: "Lessor")
    public static let lessee = TranslatedString(dutch: "Huurder", english: "Lessee")
    public static let contractor = TranslatedString(dutch: "Aannemer", english: "Contractor")
    public static let client = TranslatedString(dutch: "Opdrachtgever", english: "Client")
    public static let firstParty = TranslatedString(dutch: "Partij 1", english: "Party 1")
    public static let secondParty = TranslatedString(dutch: "Partij 2", english: "Party 2")
}

// Preview examples
extension SignatoryGroup {
    static var preview: Self {
        .init(
            name: TranslatedString(
                dutch: "Acme B.V.",
                english: "Acme Corporation"
            ),
            role: .seller,
            signers: [
                .legalEntity(
                    .init(
                        name: "Acme B.V.",
                        metadata: [
                            .registrationNumber: "12345678",
                        ],
                        representatives: [
                            .init(
                                signer: .naturalPerson(
                                    .init(
                                        name: "John Doe", 
                                        position: "CEO"
                                    )
                                ),
                                capacity: .director
                            ),
                            .init(
                                signer: .naturalPerson(
                                    .init(
                                        name: "Jane Smith", 
                                        position: "CFO"
                                    )
                                ),
                                capacity: .director
                            )
                        ]
                    )
                )
            ]
        )
    }
}
