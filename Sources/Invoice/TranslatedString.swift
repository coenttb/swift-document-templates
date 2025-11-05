//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Foundation
import Translating

extension TranslatedString {
    public static let invoiceNumber: Self = .init(dutch: "factuurnummer", english: "invoice number")

    public static let invoiceDate: Self = .init(dutch: "factuurdatum", english: "invoice date")

    public static let expiryDate: Self = .init(dutch: "vervaldatum", english: "expiry date")

    public static let clientNumber: Self = .init(dutch: "cliëntnummer", english: "client id")

    public static let purchaseOrderNumber: Self = .init(
        dutch: "inkoopordernummer",
        english: "purchase order number"
    )

    public static let totalAmount: Self = .init(dutch: "totaalbedrag", english: "total amount")

    public static let invoice: Self = .init(dutch: "factuur", english: "invoice")

    public static let description: Self = .init(dutch: "omschrijving", english: "description")

    public static let quantity: Self = .init(dutch: "aantal", english: "quantity")

    public static let unit: Self = .init(dutch: "eenheid", english: "unit")

    public static let rate: Self = .init(dutch: "tarief", english: "rate")

    public static let vatPercentage: Self = .init(dutch: "btw%", english: "vat%")

    public static let vat: Self = .init(dutch: "btw", english: "vat")

    public static let total: Self = .init(dutch: "totaal", english: "total")

    public static let hour: Self = .init(dutch: "uur", english: "hour")

    public static let hours: Self = .init(dutch: "uren", english: "hours")
}
