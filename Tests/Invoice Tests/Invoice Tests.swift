//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import CoenttbHtmlToPdf
import CSS
import Date
import Dependencies
import Foundation
import HTML
import Invoice
import Languages
import Locale
import Percent
import Testing

@Test("HtmlToPdf")
func basldfva() async throws {

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")
    print(directory)

    let invoice_title: TranslatedString = .init(
        dutch: "Factuur",
        english: "Invoice"
    )

    enum Style {
        case minimal, modern
    }

    for wrap in [Style.minimal, .modern] {
        for language in [Language.english, .dutch] {

            try await withDependencies {
                $0.language = language
                $0.locale = language.locale
                $0.calendar = .autoupdatingCurrent
            } operation: {

                let invoice: some HTML = Invoice(
                    sender: .init(
                        name: "Your Company",
                        address: ["123 Main St", "City", "Country"],
                        phone: "123-456-7890",
                        email: "billing@company.com",
                        website: "www.company.com",
                        kvk: "12345678",
                        btw: "NL123456789B01",
                        iban: "NL00BANK1234567890"
                    ),
                    client: .init(
                        id: "CUST001",
                        name: "Client Name",
                        address: ["789 Maple St", "City", "Country"]
                    ),
                    invoiceNumber: "INV001",
                    invoiceDate: Date.now,
                    expiryDate: (Date.now + 30.days),
                    metadata: [:],
                    rows: [
                        .service(.init(amountOfHours: 160, hourlyRate: 140.00, vat: 21%, description: "Consulting services"))
                    ]
                )

                try await invoice.print(
                    title: "\(language) | \(invoice_title) | \(wrap)",
                    to: directory,
                    wrapInHtmlDocument: {
                        switch wrap {
                        case .minimal:
                            HTMLDocument.minimal
                        case .modern:
                            HTMLDocument

                        }
                    }()
                )
            }
        }
    }
}
