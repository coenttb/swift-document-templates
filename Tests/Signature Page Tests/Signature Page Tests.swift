//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Dependencies
import Foundation
import HTML
import HtmlToPdf
@testable import Signature_Page
import Testing
import Translating

@Test("Single Natural Person")
func singleNaturalPerson() async throws {
    (.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let block = Signatory.Person.Block(
        person: Signatory.Person(name: TranslatedString("John Smith"))
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        let filename = "Signatory Block Single Natural Person.pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { block }, to: fileURL)
    }
}

@Test("Single Legal Entity with One Representative")
func singleLEWithOneRepresentative() async throws {
    (.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let signatory = Signatory(
        name: TranslatedString(company),
        signers: [
            Signatory.Person(
                name: TranslatedString("John Smith"),
                position: TranslatedString(
                    dutch: "Directeur van \(company)",
                    english: "Director of \(company)"
                )
            )
        ]
    )
    let page = SignaturePage(
        signatories: [signatory]
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        let filename = "Signatory Block Legal Entity Single Representative.pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { page }, to: fileURL)
    }
}

@Test("Legal Entity with Two Representatives")
func singleLEWithTwoRepresentatives() async throws {
    (.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let signatory = Signatory(
        name: TranslatedString(company),
        signers: [
            Signatory.Person(
                name: TranslatedString("John Smith"),
                position: TranslatedString(
                    dutch: "Directeur van \(company)",
                    english: "Director of \(company)"
                )
            ),
            Signatory.Person(
                name: TranslatedString("Lisa Wayne"),
                position: TranslatedString(
                    dutch: "Directeur van \(company)",
                    english: "Director of \(company)"
                )
            )
        ]
    )
    let page = SignaturePage(
        signatories: [signatory]
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        let filename = "Signatory Block Legal Entity Two Representatives.pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { page }, to: fileURL)
    }
}

@Test("Management Company Structure")
func managementCompanyStructure() async throws {
    (.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let operatingCompany = "Operating Company B.V."
    let managementCompany = "Management B.V."

    // Create the management company signatory
    let managementSignatory = Signatory(
        name: TranslatedString(managementCompany),
        signers: [
            Signatory.Person(
                name: TranslatedString("John Smith"),
                position: TranslatedString(
                    dutch: "Directeur van \(managementCompany)",
                    english: "Director of \(managementCompany)"
                )
            )
        ]
    )

    // Create the operating company signatory
    let operatingSignatory = Signatory(
        name: TranslatedString(operatingCompany),
        signers: [
            Signatory.Person(
                name: TranslatedString("\(managementCompany)"),
                position: TranslatedString(
                    dutch: "Directeur van \(operatingCompany)",
                    english: "Director of \(operatingCompany)"
                )
            )
        ]
    )

    let page = SignaturePage(
        signatories: [operatingSignatory, managementSignatory]
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        let filename = "Signatory Block Management Company Structure.pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { page }, to: fileURL)
    }
}

@Test("Natural Person with Metadata")
func naturalPersonWithMetadata() async throws {
    (.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let block = Signatory.Person.Block(
        person: Signatory.Person(
            name: TranslatedString("Dr. John Smith"),
            metadata: [
                .position: TranslatedString("Chief Scientific Officer")
            ]
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        let filename = "Signatory Block Natural Person with Metadata.pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { block }, to: fileURL)
    }
}

@Test("Legal Entity with Proxy Holder")
func legalEntityWithProxyHolder() async throws {
    (.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let signatory = Signatory(
        name: TranslatedString(company),
        signers: [
            Signatory.Person(
                name: TranslatedString("Jane Doe"),
                position: TranslatedString(
                    dutch: "Gevolmachtigde van \(company)",
                    english: "Proxy holder of \(company)"
                )
            )
        ]
    )
    let page = SignaturePage(
        signatories: [signatory]
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        let filename = "Signatory Block Legal Entity with Proxy Holder.pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { page }, to: fileURL)
    }
}

@Test("Legal Entity with Registration Details")
func legalEntityWithRegistrationDetails() async throws {
    (.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let signatory = Signatory(
        name: TranslatedString(company),
        signers: [
            Signatory.Person(
                name: TranslatedString("John Smith"),
                position: TranslatedString(
                    dutch: "Directeur van \(company)",
                    english: "Director of \(company)"
                )
            )
        ],
        metadata: [
            .registrationNumber: TranslatedString("12345678"),
            TranslatedString(dutch: "Vestigingsadres", english: "Business Address"): TranslatedString("Amsterdam")
        ]
    )
    let page = SignaturePage(
        signatories: [signatory]
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        let filename = "Signatory Block Legal Entity with Registration Details.pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { page }, to: fileURL)
    }
}
