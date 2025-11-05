//
//  Invitation Tests.swift
//  swift-document-templates
//
//  Invitation template tests focusing on HTML generation and structure
//

import Dependencies
import DependenciesTestSupport
import Foundation
import HTML
import Letter
import Testing

@testable import Invitation

@Suite("Invitation Template") struct InvitationTests {

    // MARK: - Basic Functionality

    @Test("Invitation generates HTML with all components") func invitationGeneratesHTML() {
        let invitation = Invitation(
            sender: .init(
                name: "Test Org",
                address: ["123 Street"],
                phone: "123-456",
                email: "test@org.com",
                website: "test.com"
            ),
            recipient: .init(id: "RECIP001", name: "Guest Name", address: ["456 Street"]),
            invitationNumber: "INV-001",
            invitationDate: Date.now,
            eventDate: Date.now,
            location: "Test Hall",
            metadata: [:]
        )

        // Verify invitation conforms to HTML protocol
        let _: any HTML = invitation
        #expect(invitation.invitationNumber == "INV-001")
        #expect(invitation.location == "Test Hall")
    }

    // MARK: - Reference Generation

    @Test("Invitation reference combines recipient ID and invitation number")
    func invitationReference() {
        let invitation = Invitation(
            sender: .init(name: "Org", address: [], phone: "1", email: "e", website: "w"),
            recipient: .init(id: "GUEST123", name: "Guest", address: []),
            invitationNumber: "INV456",
            invitationDate: Date.now,
            eventDate: Date.now,
            location: "Hall",
            metadata: [:]
        )

        #expect(invitation.reference == "GUEST123-INV456")
    }

    // MARK: - Sender Tests

    @Test("Invitation sender with all fields") func invitationSender() {
        let sender = Invitation.Sender(
            name: "Organization",
            address: ["Street 1", "City"],
            phone: "123-456",
            email: "info@org.com",
            website: "org.com"
        )

        #expect(sender.name == "Organization")
        #expect(sender.phone == "123-456")
        #expect(sender.email == "info@org.com")
    }

    // MARK: - Recipient Tests

    @Test("Invitation recipient with ID") func invitationRecipient() {
        let recipient = Invitation.Recipient(
            id: "RECIP001",
            name: "Guest Name",
            address: ["Address Line 1"]
        )

        #expect(recipient.id == "RECIP001")
        #expect(recipient.name == "Guest Name")
    }

    // MARK: - Date Handling

    @Test("Invitation with event date in future", .dependency(\.calendar, .autoupdatingCurrent))
    func invitationWithFutureEventDate() async throws {
        let now = Date.now
        let future = now + 7.days

        let invitation = Invitation(
            sender: .init(name: "O", address: [], phone: "1", email: "e", website: "w"),
            recipient: .init(id: "R", name: "G", address: []),
            invitationNumber: "INV",
            invitationDate: now,
            eventDate: future,
            location: "L",
            metadata: [:]
        )

        #expect(invitation.eventDate > invitation.invitationDate)
    }

    // MARK: - Metadata

    @Test("Invitation with custom metadata") func invitationWithMetadata() {
        let key = TranslatedString(dutch: "Dresscode", english: "Dress Code")
        let value = TranslatedString(dutch: "Formeel", english: "Formal")

        let invitation = Invitation(
            sender: .init(name: "O", address: [], phone: "1", email: "e", website: "w"),
            recipient: .init(id: "R", name: "G", address: []),
            invitationNumber: "INV",
            invitationDate: Date.now,
            eventDate: Date.now,
            location: "L",
            metadata: [key: value]
        )

        #expect(invitation.metadata[key] == value)
    }

    // MARK: - Letter Sender Conversion

    @Test("Convert Invitation.Sender to Letter.Sender") func convertInvitationSenderToLetterSender()
    {
        let invitationSender = Invitation.Sender(
            name: "Organization",
            address: ["Street"],
            phone: "123",
            email: "test@test.com",
            website: "test.com"
        )

        let letterSender = Letter.Sender(invitationSender)

        #expect(letterSender.name == invitationSender.name)
        #expect(letterSender.address == invitationSender.address)
        #expect(letterSender.metadata[.phone] == invitationSender.phone)
        #expect(letterSender.metadata[.email] == invitationSender.email)
    }

    // MARK: - Language Support

    @Test("Invitation in Dutch", .dependency(\.language, .dutch)) func invitationInDutch() {
        let invitation = Invitation(
            sender: .init(name: "Org", address: [], phone: "1", email: "e", website: "w"),
            recipient: .init(id: "R", name: "G", address: []),
            invitationNumber: "INV",
            invitationDate: Date.now,
            eventDate: Date.now,
            location: "L",
            metadata: [:]
        )

        let _: any HTML = invitation
    }

    @Test("Invitation in English", .dependency(\.language, .english)) func invitationInEnglish() {
        let invitation = Invitation(
            sender: .init(name: "Org", address: [], phone: "1", email: "e", website: "w"),
            recipient: .init(id: "R", name: "G", address: []),
            invitationNumber: "INV",
            invitationDate: Date.now,
            eventDate: Date.now,
            location: "L",
            metadata: [:]
        )

        let _: any HTML = invitation
    }

    // MARK: - Equatable/Hashable

    @Test("Sender equality") func senderEquality() {
        let sender1 = Invitation.Sender(
            name: "A",
            address: ["B"],
            phone: "1",
            email: "e",
            website: "w"
        )
        let sender2 = Invitation.Sender(
            name: "A",
            address: ["B"],
            phone: "1",
            email: "e",
            website: "w"
        )
        let sender3 = Invitation.Sender(
            name: "C",
            address: ["D"],
            phone: "2",
            email: "f",
            website: "x"
        )

        #expect(sender1 == sender2)
        #expect(sender1 != sender3)
    }

    @Test("Recipient creation") func recipientCreation() {
        let recipient1 = Invitation.Recipient(id: "A", name: "B", address: ["C"])
        let recipient2 = Invitation.Recipient(id: "D", name: "E", address: ["F"])

        // Verify recipients can be created
        _ = recipient1
        _ = recipient2
    }
}
