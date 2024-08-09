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
import Date
import Testing
import Percent

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
//                let invoice: some HTML = Invoice.preview
                let invoice: some HTML = Invoice(
                    sender: .init(name: "Your Company", address: ["123 Main St", "City", "Country"], phone: "123-456-7890", email: "billing@company.com", website: "www.company.com", kvk: "12345678", btw: "NL123456789B01", iban: "NL00BANK1234567890"),
                    client: .init(id: "CUST001", name: "Client Name", address: ["789 Maple St", "City", "Country"]),
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


