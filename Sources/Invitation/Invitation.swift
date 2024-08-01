//
//  Invitation.swift
//
//
//  Created by Coen ten Thije Boonkkamp on August 1, 2024.
//

import Foundation
import HTML
import Internal
import Languages
import Letter
import OrderedCollections
import SwiftDate

public struct Invitation {
    let sender: Invitation.Sender
    let recipient: Invitation.Recipient
    let invitationNumber: String
    let invitationDate: Date
    let eventDate: Date
    let location: String
    let metadata: Invitation.Metadata

    public init(
        sender: Invitation.Sender,
        recipient: Invitation.Recipient,
        invitationNumber: String,
        invitationDate: Date,
        eventDate: Date,
        location: String,
        metadata: Invitation.Metadata
    ) {
        self.sender = sender
        self.recipient = recipient
        self.invitationNumber = invitationNumber
        self.invitationDate = invitationDate
        self.eventDate = eventDate
        self.location = location
        self.metadata = metadata
    }
}

extension Invitation {
    public typealias Metadata = OrderedDictionary<TranslatedString, TranslatedString>
}

extension Invitation {
    var reference: String {
        "\(recipient.id)-\(invitationNumber)"
    }
}

extension Invitation {
    public struct Sender: Hashable, Equatable, Codable {
        public let name: String
        public let address: [String]
        public let phone: String
        public let email: String
        public let website: String

        public init(
            name: String,
            address: [String],
            phone: String,
            email: String,
            website: String
        ) {
            self.name = name
            self.address = address
            self.phone = phone
            self.email = email
            self.website = website
        }
    }
}

extension Letter.Sender {
    public init(_ sender: Invitation.Sender) {
        self = .init(
            name: sender.name,
            address: sender.address,
            phone: sender.phone,
            email: sender.email,
            website: sender.website,
            kvk: nil,
            btw: nil,
            iban: nil,
            on_behalf_of: nil
        )
    }
}

extension Invitation {
    public struct Recipient {
        public let id: String
        public let name: String
        public let address: [String]
        public let metadata: Letter.Recipient.Metadata

        public init(
            id: String,
            name: String,
            address: [String],
            metadata: Letter.Recipient.Metadata = [:]
        ) {
            self.id = id
            self.name = name
            self.address = address
            self.metadata = metadata
        }
    }
}

extension Letter.Recipient {
    public init(_ recipient: Invitation.Recipient) {
        self = .init(
            name: recipient.name,
            address: recipient.address,
            metadata: recipient.metadata
        )
    }
}

extension Invitation: HTML {
    public var body: some HTML {
        Letter(
            sender: .init(self.sender),
            recipient: .init(self.recipient),
            location: self.location,
            date: (sending: self.invitationDate, signature: nil),
            subject: "\(TranslatedString.eventInvitation)"
        ) {
            table {
                tr {
                    td {
                        h1 {
                            TranslatedString.invitation.capitalized
                        }
                        .inlineStyle("margin-top", "0")
                        .inlineStyle("margin-bottom", "0")
                    }
                    .inlineStyle("vertical-align", "top")
                    .inlineStyle("width", "100%")

                    td {
                        table {
                            HTMLGroup {
                                tr {
                                    td { b { TranslatedString.invitationNumber.capitalized } }
                                        .inlineStyle("padding-right", "15px")
                                    td { "\(self.invitationNumber)" }
                                }
                                tr {
                                    td { b { TranslatedString.invitationDate.capitalized } }
                                        .inlineStyle("padding-right", "15px")
                                    td { "\(self.invitationDate.formatted(usingLocaleDependency: true, date: .long, time: .omitted))" }
                                }
                                tr {
                                    td { b { TranslatedString.eventDate.capitalized } }
                                        .inlineStyle("padding-right", "15px")
                                    td { "\(self.eventDate.formatted(usingLocaleDependency: true, date: .long, time: .omitted))" }
                                }
                                tr {
                                    td { b { TranslatedString.location.capitalized } }
                                        .inlineStyle("padding-right", "15px")
                                    td { "\(self.location)" }
                                }
                            }
                            .inlineStyle("vertical-align", "bottom")
                            .inlineStyle("white-space", "nowrap")
                        }
                    }
                }
                .inlineStyle("vertical-align", "bottom")
            }
            .inlineStyle("border-collapse", "collapse")

            br()

            table {
                HTMLForEach(metadata.map { $0 }) { (key, value) in
                    tr {
                        td { "\(key)" }
                            .inlineStyle("padding-right", "15px")
                        td { "\(value)" }
                    }
                }
            }
            .inlineStyle("border-collapse", "collapse")

            br()
            br()

            p {
                HTMLText("""
                \(TranslatedString(
                        dutch: "We nodigen u van harte uit voor het evenement dat op \(self.eventDate.formatted(usingLocaleDependency: true)) plaatsvindt bij \(self.location).",
                        english: "We cordially invite you to the event taking place on \(self.eventDate.formatted(usingLocaleDependency: true)) at \(self.location)."
                    ))
                """)
            }
        }
    }
}

extension TranslatedString {
    static let invitation = TranslatedString(dutch: "Uitnodiging", english: "Invitation")
    static let invitationNumber = TranslatedString(dutch: "Uitnodigingsnummer", english: "Invitation Number")
    static let invitationDate = TranslatedString(dutch: "Uitnodigingsdatum", english: "Invitation Date")
    static let eventDate = TranslatedString(dutch: "Evenementdatum", english: "Event Date")
    static let location = TranslatedString(dutch: "Locatie", english: "Location")
    static let eventInvitation = TranslatedString(dutch: "Evenement Uitnodiging", english: "Event Invitation")
}

#if canImport(SwiftUI)
import SwiftUI
#Preview {
    HTMLPreview.modern {
        Invitation.preview
    }
    .frame(width: 632, height: 750)
}
#endif

extension Invitation.Sender {
    package static var preview: Self {
        .init(
            name: "Organisator B.V.",
            address: [
                "Straatnaam 1",
                "1234 AB Stad",
                "Nederland"
            ],
            phone: "+31 6 12345678",
            email: "info@organisator.nl",
            website: "www.organisator.nl"
        )
    }
}

extension Invitation.Recipient {
    package static var preview: Self {
        .init(
            id: "INV123456",
            name: "Gast Naam",
            address: [
                "Adresweg 23",
                "5678 CD Plaats",
                "Nederland"
            ]
        )
    }
}

extension Invitation {
    package static var preview: Self {
        .init(
            sender: .preview,
            recipient: .preview,
            invitationNumber: "001",
            invitationDate: Date.now,
            eventDate: (Date.now + 2.weeks),
            location: "Eventlocatie",
            metadata: [
                .init(dutch: "Dresscode", english: "Dress Code"): .init(dutch: "Zakelijk", english: "Business")
            ]
        )
    }
}
