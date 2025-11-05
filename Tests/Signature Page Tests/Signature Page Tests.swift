//
//  Signature Page Tests.swift
//  swift-document-templates
//
//  Signature Page template tests focusing on HTML generation and structure
//

import Dependencies
import DependenciesTestSupport
import Foundation
import HTML
import Testing
import Translating

@testable import Signature_Page

@Suite("Signature Page Template") struct SignaturePageTests {

    // MARK: - Signatory Enum Tests

    @Test("Individual signatory") func individualSignatory() {
        let signatory = Signatory.individual(name: TranslatedString("John Doe"), metadata: [:])

        #expect(signatory.name == TranslatedString("John Doe"))
        #expect(signatory.people.count == 1)
    }

    @Test("Group signatory") func groupSignatory() {
        let signatory = Signatory.group(
            name: TranslatedString("Company"),
            signers: [
                Signatory.Person(name: TranslatedString("Person 1")),
                Signatory.Person(name: TranslatedString("Person 2")),
            ],
            metadata: [:]
        )

        #expect(signatory.name == TranslatedString("Company"))
        #expect(signatory.people.count == 2)
    }

    @Test("Individual signatory with title") func individualSignatoryWithTitle() {
        let signatory = Signatory.individual(
            name: "Dr. Jane Smith",
            title: TranslatedString("Director"),
            metadata: [:]
        )

        #expect(signatory.name == TranslatedString("Dr. Jane Smith"))
        #expect(signatory.metadata[.title] == TranslatedString("Director"))
    }

    @Test("Individual signatory with position") func individualSignatoryWithPosition() {
        let signatory = Signatory.individual(
            name: "John Doe",
            position: TranslatedString("CEO"),
            metadata: [:]
        )

        #expect(signatory.metadata[.position] == TranslatedString("CEO"))
    }

    // MARK: - Person Tests

    @Test("Person with name only") func personWithNameOnly() {
        let person = Signatory.Person(name: TranslatedString("Test Person"))

        #expect(person.name == TranslatedString("Test Person"))
        #expect(person.metadata.isEmpty)
    }

    @Test("Person with metadata") func personWithMetadata() {
        let person = Signatory.Person(
            name: TranslatedString("Test Person"),
            metadata: [.position: TranslatedString("Manager")]
        )

        #expect(person.metadata[.position] == TranslatedString("Manager"))
    }

    @Test("Person with position") func personWithPosition() {
        let person = Signatory.Person(
            name: TranslatedString("Test Person"),
            position: TranslatedString("Director")
        )

        #expect(person.metadata[.position] == TranslatedString("Director"))
    }

    // MARK: - SignaturePage Tests

    @Test("SignaturePage with single signatory") func signaturePageWithSingleSignatory() {
        let page = SignaturePage(signatories: [
            .individual(name: TranslatedString("John Doe"), metadata: [:])
        ])

        #expect(page.signatories.count == 1)
        let _: any HTML = page
    }

    @Test("SignaturePage with multiple signatories") func signaturePageWithMultipleSignatories() {
        let page = SignaturePage(signatories: [
            .individual(name: TranslatedString("Person 1"), metadata: [:]),
            .group(
                name: TranslatedString("Company"),
                signers: [Signatory.Person(name: TranslatedString("Person 2"))],
                metadata: [:]
            ),
        ])

        #expect(page.signatories.count == 2)
        let _: any HTML = page
    }

    @Test("Empty SignaturePage") func emptySignaturePage() {
        let page = SignaturePage(signatories: [])

        #expect(page.signatories.isEmpty)
        let _: any HTML = page
    }

    // MARK: - Convenience Initializers

    @Test("Signatory convenience init with signers array")
    func signatoryConvenienceInitWithSignersArray() {
        let signatory = Signatory(
            name: TranslatedString("Company"),
            signers: [
                Signatory.Person(name: TranslatedString("Person 1")),
                Signatory.Person(name: TranslatedString("Person 2")),
            ]
        )

        #expect(signatory.people.count == 2)
    }

    @Test("Signatory convenience init with single signer")
    func signatoryConvenienceInitWithSingleSigner() {
        let signatory = Signatory(
            name: TranslatedString("Company"),
            signer: Signatory.Person(name: TranslatedString("Person"))
        )

        #expect(signatory.people.count == 1)
    }

    @Test("Signatory with role") func signatoryWithRole() {
        let signatory = Signatory(
            name: TranslatedString("Company"),
            role: TranslatedString("Director"),
            signers: [Signatory.Person(name: TranslatedString("Person"))]
        )

        #expect(signatory.metadata[.role] == TranslatedString("Director"))
    }

    // MARK: - Person Block Tests

    @Test("Person Block renders HTML") func personBlockRendersHTML() {
        let block = Signatory.Person.Block(
            person: Signatory.Person(name: TranslatedString("Test Person"))
        )

        let _: any HTML = block
    }

    // MARK: - Metadata Tests

    @Test("Signatory with registration number") func signatoryWithRegistrationNumber() {
        let signatory = Signatory(
            name: TranslatedString("Company"),
            signers: [Signatory.Person(name: TranslatedString("Person"))],
            metadata: [.registrationNumber: TranslatedString("12345678")]
        )

        #expect(signatory.metadata[.registrationNumber] == TranslatedString("12345678"))
    }

    @Test("Signatory with custom metadata") func signatoryWithCustomMetadata() {
        let customKey = TranslatedString(dutch: "Kantoor", english: "Office")
        let signatory = Signatory(
            name: TranslatedString("Company"),
            signers: [Signatory.Person(name: TranslatedString("Person"))],
            metadata: [customKey: TranslatedString("Amsterdam")]
        )

        #expect(signatory.metadata[customKey] == TranslatedString("Amsterdam"))
    }

    // MARK: - Language Support

    @Test("SignaturePage in Dutch", .dependency(\.language, .dutch)) func signaturePageInDutch() {
        let page = SignaturePage(signatories: [
            .individual(name: TranslatedString("Jan Jansen"), metadata: [:])
        ])

        let _: any HTML = page
    }

    @Test("SignaturePage in English", .dependency(\.language, .english))
    func signaturePageInEnglish() {
        let page = SignaturePage(signatories: [
            .individual(name: TranslatedString("John Doe"), metadata: [:])
        ])

        let _: any HTML = page
    }

    // MARK: - Codable/Hashable

    @Test("Signatory is Hashable") func signatoryIsHashable() {
        let signatory1 = Signatory.individual(name: TranslatedString("A"), metadata: [:])
        let signatory2 = Signatory.individual(name: TranslatedString("A"), metadata: [:])
        let signatory3 = Signatory.individual(name: TranslatedString("B"), metadata: [:])

        #expect(signatory1 == signatory2)
        #expect(signatory1 != signatory3)
    }

    @Test("Person is Hashable") func personIsHashable() {
        let person1 = Signatory.Person(name: TranslatedString("A"))
        let person2 = Signatory.Person(name: TranslatedString("A"))
        let person3 = Signatory.Person(name: TranslatedString("B"))

        #expect(person1 == person2)
        #expect(person1 != person3)
    }

    // MARK: - Complex Scenarios

    @Test("Management company structure") func managementCompanyStructure() {
        let managementCompany = Signatory(
            name: TranslatedString("Management B.V."),
            signers: [
                Signatory.Person(
                    name: TranslatedString("John Smith"),
                    position: TranslatedString("Director of Management B.V.")
                )
            ]
        )

        let operatingCompany = Signatory(
            name: TranslatedString("Operating Company B.V."),
            signers: [
                Signatory.Person(
                    name: TranslatedString("Management B.V."),
                    position: TranslatedString("Director of Operating Company B.V.")
                )
            ]
        )

        let page = SignaturePage(signatories: [operatingCompany, managementCompany])

        #expect(page.signatories.count == 2)
        let _: any HTML = page
    }

    @Test("Multiple representatives") func multipleRepresentatives() {
        let signatory = Signatory(
            name: TranslatedString("Company"),
            signers: [
                Signatory.Person(name: TranslatedString("Director 1")),
                Signatory.Person(name: TranslatedString("Director 2")),
                Signatory.Person(name: TranslatedString("Director 3")),
            ]
        )

        #expect(signatory.people.count == 3)
    }
}
