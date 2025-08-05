//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Translating

extension TranslatedString {
    public static let signatures = TranslatedString(
        dutch: "Ondertekening",
        english: "Signatures"
    )

    public static let signedAt = TranslatedString(
        dutch: "Getekend te",
        english: "Signed at"
    )

    public static let signedOn = TranslatedString(
        dutch: "Getekend op",
        english: "Signed on"
    )

    public static let onBehalfOf = TranslatedString(
        dutch: "Namens",
        english: "On behalf of"
    )

    public static let inCapacityOf = TranslatedString(
        dutch: "In hoedanigheid van",
        english: "In capacity of"
    )

    public static let date = TranslatedString(
        dutch: "datum",
        english: "date"
    )

    public static let location = TranslatedString(
        dutch: "locatie",
        english: "location"
    )
}

extension TranslatedString {
    public static let title = TranslatedString(
        dutch: "Titel",
        english: "Title"
    )
    public static let position = TranslatedString(
        dutch: "Functie",
        english: "Position"
    )
    public static let registrationNumber = TranslatedString(
        dutch: "KvK-nummer",
        english: "Registration Number"
    )
    public static let dateOfBirth = TranslatedString(
        dutch: "Geboortedatum",
        english: "Date of Birth"
    )
    public static let role = TranslatedString(
        dutch: "Rol",
        english: "Role"
    )
}

extension TranslatedString {
    public static let seller = TranslatedString(
        dutch: "Verkoper",
        english: "Seller"
    )
    public static let buyer = TranslatedString(
        dutch: "Koper",
        english: "Buyer"
    )
    public static let lessor = TranslatedString(
        dutch: "Verhuurder",
        english: "Lessor"
    )
    public static let lessee = TranslatedString(
        dutch: "Huurder",
        english: "Lessee"
    )
    public static let contractor = TranslatedString(
        dutch: "Aannemer",
        english: "Contractor"
    )
    public static let client = TranslatedString(
        dutch: "Opdrachtgever",
        english: "Client"
    )
    public static let firstParty = TranslatedString(
        dutch: "Partij 1",
        english: "Party 1"
    )
    public static let secondParty = TranslatedString(
        dutch: "Partij 2",
        english: "Party 2"
    )
}

extension String {
    func repeated(_ count: Int) -> String {
        String(repeating: self, count: count)
    }
}
