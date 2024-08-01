//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Foundation
import Languages

extension TranslatedString {
    public static let address: Self = .init(
        dutch: "adres",
        english: "address"
    )

    public static let phone: Self = .init(
        dutch: "tel",
        english: "phone"
    )
    public static let email: Self = .init(
        dutch: "email",
        english: "email"
    )
    public static let website: Self = .init(
        dutch: "website",
        english: "website"
    )
    public static let kvk: Self = .init(
        dutch: "kvk",
        english: "kvk"
    )
    public static let btw: Self = .init(
        dutch: "btw",
        english: "vat"
    )
    public static let iban: Self = .init(
        dutch: "iban",
        english: "iban"
    )

    public static let referenceNumber: TranslatedString = .init(
        dutch: "Referentienummer",
        english: "Reference"
    )
    public static let salutation: TranslatedString = .init(
        dutch: "Geachte heer/mevrouw,",
        english: "Dear sir/madam,"
    )
}
