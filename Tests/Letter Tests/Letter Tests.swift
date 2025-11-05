//
//  Letter Tests.swift
//  swift-document-templates
//
//  Letter template tests focusing on HTML generation and structure
//

import Dependencies
import Foundation
import HTML
import Testing
import Translating

@testable import Letter

@Suite("Letter Template") struct LetterTests {

  // MARK: - Basic Functionality

  @Test("Letter generates HTML with all components")
  func letterGeneratesHTML() throws {
    let sender = Letter.Sender(
      name: "Test Company",
      address: ["123 Main St", "City, Country"],
      phone: "123-456-7890",
      email: "test@company.com"
    )

    let recipient = Letter.Recipient(
      name: "Test Recipient",
      address: ["456 Elm St", "City, Country"]
    )

    let letter = Letter(
      sender: sender,
      recipient: recipient,
      location: "Amsterdam",
      date: (sending: Date.now, signature: nil),
      subject: "Test Subject"
    ) {
      p { "Test body content" }
    }

    // Verify letter conforms to HTML protocol
    let _: any HTML = letter
    #expect(letter.sender.name == "Test Company")
    #expect(letter.recipient.name == "Test Recipient")
    #expect(letter.subject == "Test Subject")
  }

  @Test("Letter with minimal required fields")
  func letterWithMinimalFields() throws {
    let sender = Letter.Sender(
      name: "Sender",
      address: ["Address"],
      metadata: [:]
    )

    let recipient = Letter.Recipient(
      name: "Recipient",
      address: ["Address"]
    )

    let letter = Letter(
      sender: sender,
      recipient: recipient,
      location: nil,
      date: (sending: nil, signature: nil),
      subject: nil
    ) {
      "Body text"
    }

    // Verify minimal letter compiles and renders
    let _: any HTML = letter
    #expect(letter.location == nil)
    #expect(letter.subject == nil)
  }

  // MARK: - Sender Tests

  @Test("Sender with all metadata fields")
  func senderWithAllMetadata() {
    let sender = Letter.Sender(
      name: "Full Company",
      address: ["Street 123", "City"],
      phone: "123-456",
      email: "info@company.com",
      website: "www.company.com",
      kvk: "12345678",
      btw: "NL123456789B01",
      iban: "NL00BANK1234567890"
    )

    #expect(sender.metadata.count == 6)
    #expect(sender.metadata[.phone] == "123-456")
    #expect(sender.metadata[.email] == "info@company.com")
  }

  @Test("Sender with custom metadata")
  func senderWithCustomMetadata() {
    let customKey = TranslatedString(dutch: "Test", english: "Test")
    let sender = Letter.Sender(
      name: "Company",
      address: ["Address"],
      metadata: [customKey: "Value"]
    )

    #expect(sender.metadata[customKey] == "Value")
  }

  @Test("Sender with empty address array")
  func senderWithEmptyAddress() {
    let sender = Letter.Sender(
      name: "Company",
      address: [],
      metadata: [:]
    )

    #expect(sender.address.isEmpty)
  }

  // MARK: - Recipient Tests

  @Test("Recipient with email metadata")
  func recipientWithEmails() {
    let recipient = Letter.Recipient(
      name: "Recipient",
      address: ["Address"],
      emails: ["email1@test.com", "email2@test.com"]
    )

    #expect(recipient.metadata[.perEmail]?.contains("email1@test.com") == true)
    #expect(recipient.metadata[.perEmail]?.contains("email2@test.com") == true)
  }

  @Test("Recipient with custom metadata")
  func recipientWithCustomMetadata() {
    let customKey = TranslatedString(dutch: "Afdeling", english: "Department")
    let recipient = Letter.Recipient(
      name: "Person",
      address: ["Address"],
      metadata: [customKey: "Sales"]
    )

    #expect(recipient.metadata[customKey] == "Sales")
  }

  // MARK: - Language Support

  @Test("Letter header in Dutch")
  func letterHeaderInDutch() throws {
    withDependencies {
      $0.language = .dutch
    } operation: {
      let letter = Letter.preview

      // Verify letter compiles with Dutch language dependency
      let _: any HTML = letter
    }
  }

  @Test("Letter header in English")
  func letterHeaderInEnglish() throws {
    withDependencies {
      $0.language = .english
    } operation: {
      let letter = Letter.preview

      // Verify letter compiles with English language dependency
      let _: any HTML = letter
    }
  }

  // MARK: - Date Handling

  @Test("Letter with both sending and signature dates")
  func letterWithBothDates() {
    let now = Date.now
    let letter = Letter(
      sender: .preview,
      recipient: .preview,
      location: "Utrecht",
      date: (sending: now, signature: now),
      subject: "Test"
    ) {
      "Body"
    }

    #expect(letter.date.sending != nil)
    #expect(letter.date.signature != nil)
  }

  @Test("Letter with only sending date")
  func letterWithOnlySendingDate() {
    let letter = Letter(
      sender: .preview,
      recipient: .preview,
      location: "Utrecht",
      date: (sending: Date.now, signature: nil),
      subject: "Test"
    ) {
      "Body"
    }

    #expect(letter.date.sending != nil)
    #expect(letter.date.signature == nil)
  }

  @Test("Letter with no dates")
  func letterWithNoDates() {
    let letter = Letter(
      sender: .preview,
      recipient: .preview,
      location: nil,
      date: (sending: nil, signature: nil),
      subject: "Test"
    ) {
      "Body"
    }

    #expect(letter.date.sending == nil)
    #expect(letter.date.signature == nil)
  }

  // MARK: - Custom Fields

  @Test("Letter with custom reference title")
  func letterWithCustomReferenceTitle() {
    let customRef = TranslatedString(dutch: "Kenmerk", english: "Reference")
    let letter = Letter(
      sender: .preview,
      recipient: .preview,
      location: "City",
      date: (sending: Date.now, signature: nil),
      subject: "Subject",
      referenceTitel: customRef
    ) {
      "Body"
    }

    // Verify letter can be created with custom reference title
    let _: any HTML = letter
  }

  @Test("Letter with custom salutation")
  func letterWithCustomSalutation() {
    let customSalutation = TranslatedString(dutch: "Geachte", english: "Dear")
    let letter = Letter(
      sender: .preview,
      recipient: .preview,
      location: "City",
      date: (sending: Date.now, signature: nil),
      subject: "Subject",
      salutation: customSalutation
    ) {
      "Body"
    }

    // Verify letter can be created with custom salutation
    let _: any HTML = letter
  }

  // MARK: - Preview

  @Test("Letter preview is valid")
  func letterPreviewIsValid() {
    let preview = Letter.preview

    // Verify preview letter can be created and renders
    let _: any HTML = preview
  }

  // MARK: - Equatable/Hashable

  @Test("Sender equality")
  func senderEquality() {
    let sender1 = Letter.Sender(name: "A", address: ["B"], metadata: [:])
    let sender2 = Letter.Sender(name: "A", address: ["B"], metadata: [:])
    let sender3 = Letter.Sender(name: "C", address: ["D"], metadata: [:])

    #expect(sender1 == sender2)
    #expect(sender1 != sender3)
  }

  @Test("Recipient equality")
  func recipientEquality() {
    let recipient1 = Letter.Recipient(name: "A", address: ["B"])
    let recipient2 = Letter.Recipient(name: "A", address: ["B"])
    let recipient3 = Letter.Recipient(name: "C", address: ["D"])

    #expect(recipient1 == recipient2)
    #expect(recipient1 != recipient3)
  }
}
