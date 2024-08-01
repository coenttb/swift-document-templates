//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import CSS
import Dependencies
import Foundation
import HTML
import HtmlToPdf
import Invoice
import Languages
import Locale
import SwiftDate
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
            } operation: {
                let invoice: some HTML = Invoice.test
                try await invoice.print(
                    title: "\(language) | \(invoice_title) | \(wrap)",
                    to: directory,
                    wrapInHtmlDocument: {
                        switch wrap {
                        case .minimal:
                            HTMLPreview.minimal
                        case .modern:
                            HTMLPreview.modern

                        }
                    }()
                )
            }
        }
    }
}

extension Invoice.Sender {
    static let tenThijeBoonkkamp: Self = .init(
        name: "Ten Thije Boonkkamp",
        address: [
            "Melissekade 114",
            "3544 CV Utrecht",
            "Nederland"
        ],
        phone: "+31 6 43 90 14 29",
        email: "info@tenthijeboonkkamp.nl",
        website: "tenthijeboonkkamp.nl",
        kvk: "75006723",
        btw: "NL002225740B77",
        iban: "NL47 BUNQ 2038 5375 42"
    )
}

extension Invoice.Recipient {
    static let test: Self = .init(
        id: "GFH12JK98J",
        name: "Cliënt B.V.",
        address: [
            "Laan der Wegen 56",
            "3555 HV Amsterdam",
            "Nederland"
        ]
    )
}

extension Invoice {
    public static var test: Self {
        .init(
            sender: .tenThijeBoonkkamp,
            client: .test,
            invoiceNumber: "1",
            invoiceDate: Date.now,
            expiryDate: (Date.now + 1.months),
            metadata: [
                .purchaseOrderNumber.capitalized(): "PO12345678",
                .perEmail: "facturen@client.nl; naam@cliënt.nl"
            ],
            rows: [
                .service(
                    .init(
                        amountOfHours: 8,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: "\(TranslatedString.fixed_hours(week: 1))"
                    )
                ),
                .service(
                    .init(
                        amountOfHours: 8,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: "\(TranslatedString.fixed_hours(week: 2))"
                    )
                ),
                .service(
                    .init(
                        amountOfHours: 1,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: """
                        \(TranslatedString(
                            dutch: "additioneel verzocht werk: [...]",
                            english: "additionally requested work: : [...]"
                        ))
                        """
                    )
                ),
                .service(
                    .init(
                        amountOfHours: 8,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: "\(TranslatedString.fixed_hours(week: 3))"
                    )
                )
            ]
        )
    }
}
