//
//  InvitationTests.swift
//
//
//  Created by Claude on 06/12/2024.
//

import CoenttbHtmlToPdf
import Date
import Dependencies
import Foundation
import HTML
import Invitation
import Languages
import Testing

@Test("Invitation")
func testInvitation() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")
    print(directory)

    let testDate = Date(timeIntervalSince1970: 1735689600) // January 1, 2025

    enum Style {
        case minimal
        case modern
    }
    for wrap in [Style.minimal, Style.modern] {
        for language in [Language.english, .dutch] {
        try await withDependencies {
            $0.language = language
            $0.locale = language.locale
            $0.calendar = .autoupdatingCurrent
        } operation: {
            let invitation = Invitation(
                sender: .init(
                    name: "Test Organization",
                    address: [
                        "123 Test Street",
                        "1234 AB TestCity",
                        "TestCountry"
                    ],
                    phone: "+31 6 12345678",
                    email: "test@organization.com",
                    website: "www.testorganization.com"
                ),
                recipient: .init(
                    id: "TEST001",
                    name: "John Doe",
                    address: [
                        "456 Sample Road",
                        "5678 CD SampleTown",
                        "SampleCountry"
                    ]
                ),
                invitationNumber: "INV-2024-001",
                invitationDate: testDate,
                eventDate: testDate + 1.weekOfYear,
                location: "Grand Test Hall",
                metadata: [
                    TranslatedString(dutch: "Dresscode", english: "Dress Code"):
                        TranslatedString(dutch: "Formeel", english: "Formal"),
                    TranslatedString(dutch: "Aanvangstijd", english: "Start Time"):
                        TranslatedString(dutch: "19:00", english: "7:00 PM")
                ]
            )

            try await invitation.print(
                title: "Invitation \(language) | \(wrap)",
                to: directory,
                wrapInHtmlDocument: {
                    switch wrap {
                    case .minimal: HTMLDocument.minimal
                    case .modern: HTMLDocument
                    }
                }()
            )
        }
    }
    }

}
