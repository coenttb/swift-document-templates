//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import DateExtensions
import Dependencies
import Foundation
import HTML
import HtmlToPdf
import Invoice
import Percent
import Testing
import Translating

@Test("HtmlToPdf")
func basldfva() async throws {
  @Dependency(\.pdf) var pdf

  let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(
    component: "Output"
  )
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
            .service(
              .init(
                amountOfHours: 160,
                hourlyRate: 140.00,
                vat: 21%,
                description: "Consulting services"
              )
            )
          ]
        )

        let filename = "\(language) | \(invoice_title) | \(wrap).pdf"
        let fileURL = directory.appendingPathComponent(filename)

        switch wrap {
        case .minimal:
          try await pdf.render(html: HTMLDocument { invoice }, to: fileURL)
        case .modern:
          try await pdf.render(html: HTMLDocument { invoice }, to: fileURL)
        }
      }
    }
  }
}
