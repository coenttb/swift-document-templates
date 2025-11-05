//
//  ReadmePDFExamplesTests.swift
//  swift-document-templates
//
//  Generates PDF examples shown in README to keep documentation in sync with code
//

import Agenda
import Attendance_List
import DateExtensions
import Dependencies
import DependenciesTestSupport
import Foundation
import HTML
import HtmlToPdf
import Invitation
import Invoice
import Letter
import Percent
import Signature_Page
import Testing
import Translating

@Suite("README PDF Examples")
struct ReadmePDFExamplesTests {
  @Dependency(\.pdf) var pdf

  /// Output directory for generated PDFs
  private static let outputDirectory: URL = {
    let testDirectory = URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
    return testDirectory
      .appendingPathComponent("README Examples Output", isDirectory: true)
  }()

  /// Ensure output directory exists
  private static func ensureOutputDirectoryExists() throws {
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: outputDirectory.path) {
      try fileManager.createDirectory(
        at: outputDirectory,
        withIntermediateDirectories: true
      )
    }
  }

  // MARK: - Invoice Example

  @Test(
    "Generate Invoice PDF from README example",
    .dependency(\.calendar, .autoupdatingCurrent),
    .dependency(\.locale, .init(identifier: "en_US"))
  )
  func generateInvoicePDF() async throws {
    try Self.ensureOutputDirectoryExists()

    let invoice = Invoice(
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

    let outputURL = Self.outputDirectory
      .appendingPathComponent("Invoice Example.pdf")

    let htmlString = try String(invoice)
    _ = try await pdf.render.html(htmlString, to: outputURL)
  }

  // MARK: - Letter Example

  @Test("Generate Letter PDF from README example", .dependency(\.locale, .init(identifier: "en_US")))
  func generateLetterPDF() async throws {
    try Self.ensureOutputDirectoryExists()

    let sender: Letter.Sender = .init(
      name: "Your Company",
      address: ["123 Main St", "City", "Country"],
      phone: "123-456-7890",
      email: "info@company.com",
      website: "www.company.com"
    )

    let recipient: Letter.Recipient = .init(
      name: "Recipient Name",
      address: ["456 Elm St", "City", "Country"]
    )

    let letter = Letter(
      sender: sender,
      recipient: recipient,
      location: "Utrecht",
      date: (sending: Date.now, signature: nil),
      subject: "Subject of the Letter"
    ) {
      "Dear \(recipient.name),"
      p { "I hope this finds you well." }
      p { "Best regards," }
      p { "Your Name" }
    }

    let outputURL = Self.outputDirectory
      .appendingPathComponent("Letter Example.pdf")

    let htmlString = try String(letter)
    _ = try await pdf.render.html(htmlString, to: outputURL)
  }

  // MARK: - Agenda Example

  @Test("Generate Agenda PDF from README example", .dependency(\.locale, .init(identifier: "en_US")))
  func generateAgendaPDF() async throws {
    try Self.ensureOutputDirectoryExists()

    let agenda = Agenda(
      items: [
        .init(title: "Opening Remarks"),
        .init(title: "Q1 Financial Results"),
        .init(title: "Strategic Planning Discussion"),
      ]
    )

    let outputURL = Self.outputDirectory
      .appendingPathComponent("Agenda Example.pdf")

    let htmlString = try String(agenda)
    _ = try await pdf.render.html(htmlString, to: outputURL)
  }

  // MARK: - Attendance List Example

  @Test("Generate Attendance List PDF from README example", .dependency(\.locale, .init(identifier: "en_US")))
  func generateAttendanceListPDF() async throws {
    try Self.ensureOutputDirectoryExists()

    let attendanceList = AttendanceList(
      title: "Annual Conference",
      metadata: [:],
      attendees: [
        .init(firstName: "John", lastName: "Doe", role: "Manager"),
        .init(firstName: "Jane", lastName: "Smith", role: "Director"),
      ]
    )

    let outputURL = Self.outputDirectory
      .appendingPathComponent("Attendance List Example.pdf")

    let htmlString = try String(attendanceList)
    _ = try await pdf.render.html(htmlString, to: outputURL)
  }

  // MARK: - Invitation Example

  @Test("Generate Invitation PDF from README example", .dependency(\.locale, .init(identifier: "en_US")))
  func generateInvitationPDF() async throws {
    try Self.ensureOutputDirectoryExists()

    let invitation = Invitation(
      sender: .init(
        name: "Your Company",
        address: ["123 Main St", "City"],
        phone: "123-456-7890",
        email: "events@company.com",
        website: "www.company.com"
      ),
      recipient: .init(
        id: "RECIP001",
        name: "Guest Name",
        address: ["456 Guest St", "City"]
      ),
      invitationNumber: "INV-2024-001",
      invitationDate: Date.now,
      eventDate: Date.now,
      location: "Conference Center",
      metadata: [:]
    )

    let outputURL = Self.outputDirectory
      .appendingPathComponent("Invitation Example.pdf")

    let htmlString = try String(invitation)
    _ = try await pdf.render.html(htmlString, to: outputURL)
  }

  // MARK: - Signature Page Example

  @Test("Generate Signature Page PDF from README example", .dependency(\.locale, .init(identifier: "en_US")))
  func generateSignaturePagePDF() async throws {
    try Self.ensureOutputDirectoryExists()

    // Single individual
    let individual = Signatory.individual(
      name: "John Doe",
      title: .init(dutch: "Directeur", english: "Director"),
      metadata: [:]
    )

    // Group of signers
    let group = Signatory(
      name: .init(dutch: "Bedrijf B.V.", english: "Company B.V."),
      signers: [
        .init(name: .init("Jane Smith"), metadata: [:]),
        .init(name: .init("Bob Johnson"), metadata: [:]),
      ],
      metadata: [:]
    )

    let signaturePage = SignaturePage(
      signatories: [individual, group]
    )

    let outputURL = Self.outputDirectory
      .appendingPathComponent("Signature Page Example.pdf")

    let htmlString = try String(signaturePage)
    _ = try await pdf.render.html(htmlString, to: outputURL)
  }
}
