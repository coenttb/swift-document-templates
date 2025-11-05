//
//  ReadmeVerificationTests.swift
//  swift-document-templates
//
//  Created for README verification
//

import Agenda
import Attendance_List
import Dependencies
import DependenciesTestSupport
import Foundation
import Invitation
import Invoice
import Letter
import Signature_Page
import Testing

@Suite("README Verification") struct ReadmeVerificationTests {

    @Test(
        "Invoice example from README (lines 51-84)",
        .dependency(\.calendar, .autoupdatingCurrent)
    ) func invoiceExample() {
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

        // Verify the invoice was created with correct properties
        #expect(invoice.invoiceNumber == "INV001")
        #expect(invoice.sender.name == "Your Company")
        #expect(invoice.client.name == "Client Name")
        #expect(invoice.rows.count == 1)
    }

    @Test("Letter example from README (lines 93-120)") func letterExample() throws {
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

        // Verify the letter structure compiles and renders as HTML
        let _: any HTML = letter
        #expect(recipient.name == "Recipient Name")
    }

    @Test("Invoice can render as HTML", .dependency(\.calendar, .autoupdatingCurrent))
    func invoiceRendersAsHTML() {
        let invoice = Invoice(
            sender: .init(
                name: "Test Company",
                address: ["Address Line 1"],
                phone: "555-1234",
                email: "test@test.com",
                website: "test.com",
                kvk: "12345678",
                btw: "NL123456789B01",
                iban: "NL00TEST1234567890"
            ),
            client: .init(id: "CLIENT001", name: "Test Client", address: ["Client Address"]),
            invoiceNumber: "INV-001",
            invoiceDate: Date.now,
            expiryDate: Date.now + 7.days,
            metadata: [:],
            rows: []
        )

        // Verify invoice conforms to HTML protocol
        let _: any HTML = invoice
    }

    @Test("Letter can render as HTML") func letterRendersAsHTML() throws {
        let letter = Letter(
            sender: .init(
                name: "Sender",
                address: ["Address"],
                phone: "123",
                email: "sender@test.com",
                website: "test.com"
            ),
            recipient: .init(name: "Recipient", address: ["Address"]),
            location: "City",
            date: (sending: Date.now, signature: nil),
            subject: "Test Subject"
        ) { "Test body content" }

        // Verify letter conforms to HTML protocol
        let _: any HTML = letter
    }

    @Test("DateExtensions .days syntax works", .dependency(\.calendar, .autoupdatingCurrent))
    func dateExtensionsDays() {
        let now = Date.now
        let future = now + 30.days

        // Verify date arithmetic works
        #expect(future > now)
    }

    @Test("Percent literal syntax works") func percentLiteral() throws {
        let vat = 21%

        // Verify percent literal compiles
        #expect(vat.rawValue == 21)
    }

    @Test("Agenda example from README (lines 134-142)") func agendaExample() throws {
        let agenda = Agenda(items: [
            .init(title: "Opening Remarks"), .init(title: "Q1 Financial Results"),
            .init(title: "Strategic Planning Discussion"),
        ])

        // Verify agenda was created and compiles
        #expect(agenda.items.count == 3)
        let _: any HTML = agenda
    }

    @Test("Attendance List example from README (lines 150-159)") func attendanceListExample() throws
    {
        let attendanceList = AttendanceList(
            title: "Annual Conference",
            metadata: [:],
            attendees: [
                .init(firstName: "John", lastName: "Doe", role: "Manager"),
                .init(firstName: "Jane", lastName: "Smith", role: "Director"),
            ]
        )

        // Verify attendance list was created and compiles
        #expect(attendanceList.title == "Annual Conference")
        #expect(attendanceList.attendees.count == 2)
        let _: any HTML = attendanceList
    }

    @Test("Invitation example from README (lines 167-187)") func invitationExample() throws {
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

        // Verify invitation was created and compiles
        let _: any HTML = invitation
    }

    @Test("Signature Page example from README (lines 195-212)") func signaturePageExample() throws {
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

        // Verify they compile and have public properties
        let _: TranslatedString = individual.name
        #expect(group.people.count == 2)
    }
}
