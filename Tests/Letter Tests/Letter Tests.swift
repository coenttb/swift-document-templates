//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import Dependencies
import Foundation
import HTML
import Letter
import HtmlToPdf
import Testing
import Translating

@Test("Letter")
func letter() async throws {
    @Dependency(\.pdf) var pdf


    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    for language in [Language.english, .dutch] {
        try await withDependencies {
            $0.language = language
            $0.locale = language.locale
        } operation: {
            let letter: some HTML = Letter.Header.preview

            let filename = "Letter \(language).pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: letter, to: fileURL)
        }
    }
}

@Test("Github")
func asda() async throws {
    @Dependency(\.pdf) var pdf


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
        p { "Dear Coen," }
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
            let filename = "Github Letter \(language).pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { letter }, to: fileURL)
        }
    }
}
