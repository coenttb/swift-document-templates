//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import CoenttbHtmlToPdf
import Dependencies
import Foundation
import HTML
import Languages
import Signature_Page
import Testing

@Test("Single Natural Person")
func singleNaturalPerson() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let block = SignatoryBlock(
        signatory: .naturalPerson(
            .init(name: "John Smith")
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await block.print(
            title: "Signatory Block Single Natural Person",
            to: directory,
            wrapInHtmlDocument: HTMLDocument
        )
    }
}

@Test("Single Legal Entity with One Representative")
func singleLEWithOneRepresentative() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let block = SignatoryBlock(
        signatory: .legalEntity(
            .init(
                name: company,
                representatives: [
                    .init(
                        signatory: .naturalPerson(
                            .init(name: "John Smith")
                        ),
                        capacity: .director + " of \(company)"
                    )
                ]
            )
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await block.print(
            title: "Signatory Block Legal Entity Single Representative",
            to: directory,
            wrapInHtmlDocument: HTMLDocument
        )
    }
}

@Test("Legal Entity with Two Representatives")
func singleLEWithTwoRepresentatives() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let block = SignatoryBlock(
        signatory: .legalEntity(
            .init(
                name: company,
                representatives: [
                    .init(
                        signatory: .naturalPerson(
                            .init(name: "John Smith")
                        ),
                        capacity: .director + " of \(company)"
                    ),
                    .init(
                        signatory: .naturalPerson(
                            .init(name: "Lisa Wayne")
                        ),
                        capacity: .director + " of \(company)"
                    )
                ]
            )
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await block.print(
            title: "Signatory Block Legal Entity Two Representatives",
            to: directory,
            wrapInHtmlDocument: HTMLDocument
        )
    }
}

@Test("Management Company Structure")
func managementCompanyStructure() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let operatingCompany = "Operating Company B.V."
    let managementCompany = "Management B.V."

    let block = SignatoryBlock(
        signatory: .legalEntity(
            .init(
                name: operatingCompany,
                representatives: [
                    .init(
                        signatory: .legalEntity(
                            .init(
                                name: managementCompany,
                                representatives: [
                                    .init(
                                        signatory: .naturalPerson(
                                            .init(name: "John Smith")
                                        ),
                                        capacity: .director + " of \(managementCompany)"
                                    )
                                ]
                            )
                        ),
                        capacity: .director + " of \(operatingCompany)"
                    )
                ]
            )
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await block.print(
            title: "Signatory Block Management Company Structure",
            to: directory,
            wrapInHtmlDocument: HTMLDocument
        )
    }
}

@Test("Natural Person with Metadata")
func naturalPersonWithMetadata() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let block = SignatoryBlock(
        signatory: .naturalPerson(
            .init(
                name: "Dr. John Smith",
                metadata: [
//                    .title: "PhD",
                    .position: "Chief Scientific Officer"
                ]
            )
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await block.print(
            title: "Signatory Block Natural Person with Metadata",
            to: directory,
            wrapInHtmlDocument: HTMLDocument
        )
    }
}

@Test("Legal Entity with Proxy Holder")
func legalEntityWithProxyHolder() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let block = SignatoryBlock(
        signatory: .legalEntity(
            .init(
                name: company,
                representatives: [
                    .init(
                        signatory: .naturalPerson(
                            .init(name: "Jane Doe")
                        ),
                        capacity: TranslatedString(
                            dutch: "Gevolmachtigde van \(company)",
                            english: "Proxy holder of \(company)"
                        )
                    )
                ]
            )
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await block.print(
            title: "Signatory Block Legal Entity with Proxy Holder",
            to: directory,
            wrapInHtmlDocument: HTMLDocument
        )
    }
}

@Test("Legal Entity with Registration Details")
func legalEntityWithRegistrationDetails() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let company = "Example Company B.V."
    let block = SignatoryBlock(
        signatory: .legalEntity(
            .init(
                name: company,
                metadata: [
                    .registrationNumber: "12345678",
                    .init(dutch: "Vestigingsadres", english: "Business Address"): "Amsterdam"
                ],
                representatives: [
                    .init(
                        signatory: .naturalPerson(
                            .init(name: "John Smith")
                        ),
                        capacity: .director + " of \(company)"
                    )
                ]
            )
        )
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await block.print(
            title: "Signatory Block Legal Entity with Registration Details",
            to: directory,
            wrapInHtmlDocument: HTMLDocument
        )
    }
}
