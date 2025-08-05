//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import PointFreeHTMLToPDF
import Dependencies
import Foundation
import HTML
import Translating
@testable import Signature_Page
import Testing

@Test("Single Natural Person")
func singleNaturalPerson() async throws {
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    let block = Signatory.Person.Block(
        person: Signatory.Person(name: TranslatedString("John Smith"))
    )

    try await withDependencies {
        $0.language = .english
        $0.locale = Language.english.locale
    } operation: {
        try await HTMLDocument { block }
            .print(
                title: "Signatory Block Single Natural Person",
                to: directory
            )
    }
}

@Test("Single Legal Entity with One Representative")
func singleLEWithOneRepresentative() async throws {
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
        try await HTMLDocument { page }
            .print(
                title: "Signatory Block Legal Entity Single Representative",
                to: directory
            )
    }
}

@Test("Legal Entity with Two Representatives")
func singleLEWithTwoRepresentatives() async throws {
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
        try await HTMLDocument { page }
            .print(
                title: "Signatory Block Legal Entity Two Representatives",
                to: directory
            )
    }
}

@Test("Management Company Structure")
func managementCompanyStructure() async throws {
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
        try await HTMLDocument { page }
            .print(
                title: "Signatory Block Management Company Structure",
                to: directory
            )
    }
}

@Test("Natural Person with Metadata")
func naturalPersonWithMetadata() async throws {
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
        try await HTMLDocument { block }
            .print(
                title: "Signatory Block Natural Person with Metadata",
                to: directory
            )
    }
}

@Test("Legal Entity with Proxy Holder")
func legalEntityWithProxyHolder() async throws {
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
        try await HTMLDocument { page }
            .print(
                title: "Signatory Block Legal Entity with Proxy Holder",
                to: directory
            )
    }
}

@Test("Legal Entity with Registration Details")
func legalEntityWithRegistrationDetails() async throws {
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
        try await HTMLDocument { page }
            .print(
                title: "Signatory Block Legal Entity with Registration Details",
                to: directory
            )
    }
}