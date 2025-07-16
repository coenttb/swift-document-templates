//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import CoenttbHtmlToPdf
import Dependencies
import Foundation
import HTML
import Languages
import Letter
import Testing

@Test("Letter")
func letter() async throws {

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    for language in [Language.english, .dutch] {
        try await withDependencies {
            $0.language = language
            $0.locale = language.locale
        } operation: {
            let letter: some HTML = Letter.Header.preview

            try await letter.print(
                title: "Letter \(language)",
                to: directory
            )
        }
    }
}

@Test("Github")
func asda() async throws {

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

    let letter: some HTML = Letter(
        sender: sender,
        recipient: recipient,
        location: "Utrecht",
        date: (sending: Date.now, signature: nil),
        subject: "Subject of the Letter"
    ) {
        "Dear \(recipient.name),"
        p { "I hope this finds you well." }
        p { "Best regards," }
        p { "coenttb" }
    }

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    for language in [Language.english, .dutch] {
        try await withDependencies {
            $0.language = language
            $0.locale = language.locale
        } operation: {
            try await letter.print(
                title: "Github Letter \(language)",
                to: directory,
                wrapInHtmlDocument: HTMLDocument.init(body:)
            )
        }
    }
}
