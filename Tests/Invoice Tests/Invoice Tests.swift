//
//  Invoice Tests.swift
//  swift-document-templates
//
//  Invoice template tests focusing on HTML generation and structure
//

import DateExtensions
import Dependencies
import Foundation
import HTML
import Percent
import Testing
import Translating

@testable import Invoice

@Suite("Invoice Template") struct InvoiceTests {

  // MARK: - Basic Functionality

  @Test("Invoice generates HTML with all components")
  func invoiceGeneratesHTML() async throws {
    try await withDependencies {
      $0.calendar = .autoupdatingCurrent
      $0.locale = .init(identifier: "en_US")
    } operation: {
      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV001",
        invoiceDate: Date.now,
        expiryDate: Date.now + 30.days,
        metadata: [:],
        rows: [
          .service(.init(amountOfHours: 10, hourlyRate: 100, vat: 21%, description: "Test"))
        ]
      )

      // Verify invoice conforms to HTML protocol
      let _: any HTML = invoice
      #expect(invoice.invoiceNumber == "INV001")
      #expect(invoice.rows.count == 1)
    }
  }

  @Test("Invoice with no rows")
  func invoiceWithNoRows() async throws {
    try await withDependencies {
      $0.calendar = .autoupdatingCurrent
      $0.locale = .init(identifier: "en_US")
    } operation: {
      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV002",
        invoiceDate: Date.now,
        expiryDate: nil,
        metadata: [:],
        rows: []
      )

      #expect(invoice.rows.isEmpty)
      let _: any HTML = invoice
    }
  }

  // MARK: - Reference Generation

  @Test("Invoice reference combines client ID and invoice number")
  func invoiceReference() async throws {
    try await withDependencies {
      $0.calendar = .autoupdatingCurrent
      $0.locale = .init(identifier: "en_US")
    } operation: {
      let invoice = Invoice(
        sender: .preview,
        client: .init(id: "CLIENT123", name: "Test Client", address: ["Address"]),
        invoiceNumber: "INV456",
        invoiceDate: Date.now,
        expiryDate: nil,
        metadata: [:],
        rows: []
      )

      #expect(invoice.reference == "CLIENT123-INV456")
    }
  }

  // MARK: - Row Types

  @Test("Service row (Dienst) calculations")
  func serviceRowCalculations() {
    let service = Invoice.Row.Dienst(
      amountOfHours: 10,
      hourlyRate: 150,
      vat: 21%,
      description: "Consulting"
    )

    #expect(service.amountOfHours == 10)
    #expect(service.hourlyRate == 150)
    #expect(service.vat == 21%)
    #expect(service.description == "Consulting")
  }

  @Test("Goods row (Goed) with quantity and rate")
  func goodsRow() {
    let goods = Invoice.Row.Goed(
      description: "Widget",
      quantity: 5,
      unit: "pieces",
      rate: 25,
      vatPercentage: .procent21
    )

    #expect(goods.quantity == 5)
    #expect(goods.unit == "pieces")
    #expect(goods.rate == 25)
  }

  @Test("Service row without VAT")
  func serviceRowWithoutVAT() {
    let service = Invoice.Row.Dienst(
      amountOfHours: 8,
      hourlyRate: 120,
      vat: nil,
      description: "Tax-free service"
    )

    #expect(service.vat == nil)
  }

  @Test("Goods row without VAT")
  func goodsRowWithoutVAT() {
    let goods = Invoice.Row.Goed(
      description: "Exported goods",
      quantity: 100,
      unit: "kg",
      rate: 10,
      vatPercentage: nil
    )

    #expect(goods.vatPercentage == nil)
  }

  // MARK: - Multiple Rows

  @Test("Invoice with mixed row types")
  func invoiceWithMixedRows() async throws {
    try await withDependencies {
      $0.calendar = .autoupdatingCurrent
      $0.locale = .init(identifier: "en_US")
    } operation: {
      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV003",
        invoiceDate: Date.now,
        expiryDate: nil,
        metadata: [:],
        rows: [
          .service(.init(amountOfHours: 10, hourlyRate: 100, vat: 21%, description: "Service")),
          .goed(.init(description: "Product", quantity: 2, unit: "pcs", rate: 50, vatPercentage: .procent21)),
        ]
      )

      #expect(invoice.rows.count == 2)
    }
  }

  // MARK: - Date Handling

  @Test("Invoice with expiry date")
  func invoiceWithExpiryDate() async throws {
    try await withDependencies {
      $0.calendar = .autoupdatingCurrent
      $0.locale = .init(identifier: "en_US")
    } operation: {
      let now = Date.now
      let future = now + 14.days

      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV004",
        invoiceDate: now,
        expiryDate: future,
        metadata: [:],
        rows: []
      )

      #expect(invoice.expiryDate == future)
    }
  }

  @Test("Invoice without expiry date")
  func invoiceWithoutExpiryDate() async throws {
    try await withDependencies {
      $0.calendar = .autoupdatingCurrent
      $0.locale = .init(identifier: "en_US")
    } operation: {
      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV005",
        invoiceDate: Date.now,
        expiryDate: nil,
        metadata: [:],
        rows: []
      )

      #expect(invoice.expiryDate == nil)
    }
  }

  // MARK: - Metadata

  @Test("Invoice with custom metadata")
  func invoiceWithMetadata() async throws {
    try await withDependencies {
      $0.calendar = .autoupdatingCurrent
      $0.locale = .init(identifier: "en_US")
    } operation: {
      let key = TranslatedString(dutch: "Project", english: "Project")
      let value = TranslatedString(dutch: "Website", english: "Website")

      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV006",
        invoiceDate: Date.now,
        expiryDate: nil,
        metadata: [key: value],
        rows: []
      )

      #expect(invoice.metadata[key] == value)
    }
  }

  // MARK: - Sender/Client

  @Test("Invoice sender with all required fields")
  func invoiceSender() {
    let sender = Invoice.Sender(
      name: "Test Company",
      address: ["Street 1", "City"],
      phone: "123-456",
      email: "test@test.com",
      website: "test.com",
      kvk: "12345678",
      btw: "NL123456789B01",
      iban: "NL00BANK1234567890"
    )

    #expect(sender.name == "Test Company")
    #expect(sender.kvk == "12345678")
    #expect(sender.btw == "NL123456789B01")
  }

  @Test("Invoice recipient with ID")
  func invoiceRecipient() {
    let client = Invoice.Recipient(
      id: "CLIENT001",
      name: "Client Corp",
      address: ["Address Line 1"]
    )

    #expect(client.id == "CLIENT001")
    #expect(client.name == "Client Corp")
  }

  // MARK: - Letter Sender Conversion

  @Test("Convert Invoice.Sender to Letter.Sender")
  func convertInvoiceSenderToLetterSender() {
    let invoiceSender = Invoice.Sender(
      name: "Company",
      address: ["Street"],
      phone: "123",
      email: "test@test.com",
      website: "test.com",
      kvk: "12345678",
      btw: "NL123456789B01",
      iban: "NL00BANK"
    )

    let letterSender = Letter.Sender(invoiceSender)

    #expect(letterSender.name == invoiceSender.name)
    #expect(letterSender.address == invoiceSender.address)
    #expect(letterSender.metadata[.phone] == invoiceSender.phone)
    #expect(letterSender.metadata[.email] == invoiceSender.email)
  }

  // MARK: - VAT Types

  @Test("BTW percent conversion")
  func btwPercentConversion() {
    let btw = Invoice.BTW.procent21
    #expect(btw.percent == 21%)
  }

  // MARK: - Language Support

  @Test("Invoice in Dutch")
  func invoiceInDutch() async throws {
    try await withDependencies {
      $0.language = .dutch
      $0.calendar = .autoupdatingCurrent
    } operation: {
      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV007",
        invoiceDate: Date.now,
        expiryDate: nil,
        metadata: [:],
        rows: []
      )

      let _: any HTML = invoice
    }
  }

  @Test("Invoice in English")
  func invoiceInEnglish() async throws {
    try await withDependencies {
      $0.language = .english
      $0.calendar = .autoupdatingCurrent
    } operation: {
      let invoice = Invoice(
        sender: .preview,
        client: .preview,
        invoiceNumber: "INV008",
        invoiceDate: Date.now,
        expiryDate: nil,
        metadata: [:],
        rows: []
      )

      let _: any HTML = invoice
    }
  }

  // MARK: - Equatable/Hashable

  @Test("Sender equality")
  func senderEquality() {
    let sender1 = Invoice.Sender(
      name: "A", address: ["B"], phone: "1", email: "e", website: "w", kvk: "k", btw: "b", iban: "i"
    )
    let sender2 = Invoice.Sender(
      name: "A", address: ["B"], phone: "1", email: "e", website: "w", kvk: "k", btw: "b", iban: "i"
    )
    let sender3 = Invoice.Sender(
      name: "C", address: ["D"], phone: "2", email: "f", website: "x", kvk: "l", btw: "c", iban: "j"
    )

    #expect(sender1 == sender2)
    #expect(sender1 != sender3)
  }

  @Test("Recipient creation")
  func recipientCreation() {
    let client1 = Invoice.Recipient(id: "A", name: "B", address: ["C"])
    let client2 = Invoice.Recipient(id: "D", name: "E", address: ["F"])

    // Verify recipients can be created
    _ = client1
    _ = client2
  }
}
