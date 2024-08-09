//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 07/06/2022.
//

import Foundation
import HTML
import Internal
import Languages
import Letter
import OrderedCollections
import Percent
import SwiftDate

public struct Invoice {
    let sender: Invoice.Sender
    let client: Invoice.Recipient
    let invoiceNumber: String
    let invoiceDate: Date
    let expiryDate: Date?
    let metadata: Invoice.Metadata
    let rows: [Invoice.Row]

    public init(
        sender: Invoice.Sender,
        client: Invoice.Recipient,
        invoiceNumber: String,
        invoiceDate: Date,
        expiryDate: Date?,
        metadata: Invoice.Metadata,
        rows: [Invoice.Row]
    ) {
        self.sender = sender
        self.client = client
        self.invoiceNumber = invoiceNumber
        self.invoiceDate = invoiceDate
        self.expiryDate = expiryDate
        self.metadata = metadata
        self.rows = rows
    }
}

extension Invoice {
    public typealias Metadata = OrderedDictionary<TranslatedString, TranslatedString>
}

extension Invoice {
    var reference: String {
        "\(client.id)-\(invoiceNumber)"
    }
}

extension Invoice {
    public struct Sender: Hashable, Equatable, Codable {
        public let name: String
        public let address: [String]
        public let phone: String
        public let email: String
        public let website: String
        public let kvk: String
        public let btw: String
        public let iban: String

        public init(
            name: String,
            address: [String],
            phone: String,
            email: String,
            website: String,
            kvk: String,
            btw: String,
            iban: String
        ) {
            self.name = name
            self.address = address
            self.phone = phone
            self.email = email
            self.website = website
            self.kvk = kvk
            self.iban = iban
            self.btw = btw
        }
    }
}

extension Letter.Sender {
    public init(_ sender: Invoice.Sender) {
        self = .init(
            name: sender.name,
            address: sender.address,
            phone: sender.phone,
            email: sender.email,
            website: sender.website,
            kvk: sender.kvk,
            btw: sender.btw,
            iban: sender.iban,
            on_behalf_of: nil
        )
    }
}

extension Invoice {
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
    public init(_ recipient: Invoice.Recipient) {
        self = .init(
            name: recipient.name,
            address: recipient.address,
            metadata: recipient.metadata
        )
    }
}

extension Invoice: HTML {
    public var body: some HTML {
        Letter(
            sender: .init(self.sender),
            recipient: .init(self.client),
            location: nil,
            date: (sending: nil, signature: nil),
            subject: nil
        ) {
            table {
                tr {
                    td {
                        h1 {
                            TranslatedString.invoice.capitalized
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
                                    td { b { TranslatedString.clientNumber.capitalized } }
                                        .inlineStyle("padding-right", "15px")
                                    td { "\(self.client.id)" }

                                }
                                tr {
                                    td { b { TranslatedString.invoiceNumber.capitalized } }
                                        .inlineStyle("padding-right", "15px")
                                    td { "\(self.invoiceNumber)" }

                                }
                                tr {
                                    td { b { TranslatedString.invoiceDate.capitalized } }
                                        .inlineStyle("padding-right", "15px")

                                    td { "\(self.invoiceDate.formatted(usingLocaleDependency: true, date: .long, time: .omitted))" }

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

                if let expiryDate = self.expiryDate {
                    tr {
                        td { TranslatedString.expiryDate.capitalized() }
                        td { "\(expiryDate.formatted(usingLocaleDependency: true, date: .long, time: .omitted))" }
                    }
                }

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

            table {

                thead {
                    tr {
                        td { b { TranslatedString.description.capitalized } }
                            .inlineStyle("width", "100%")
                            .inlineStyle("padding-right", "15px")

                        td { b { TranslatedString.quantity.capitalized } }
                            .inlineStyle("padding-right", "15px")

                        td { b { TranslatedString.unit.capitalized } }
                            .inlineStyle("padding-right", "15px")

                        td { b { TranslatedString.rate.capitalized } }
                            .inlineStyle("padding-right", "15px")

                        td { b { TranslatedString.vatPercentage.uppercased() } }
                            .inlineStyle("padding-right", "15px")
                    }
                    .inlineStyle("border-bottom", "1px solid #000")
                }

                HTMLForEach(self.rows) { row in
                    switch row {
                    case let .goed(goed):
                        tr {
                            td { "\(goed.description)" }
                                .inlineStyle("padding-right", "15px")

                            td { "\(goed.quantity)" }
                                .inlineStyle("padding-right", "15px")

                            td { TranslatedString.unit.capitalized() }
                                .inlineStyle("padding-right", "15px")

                            td { "\(NumberFormatter.money.string(for: goed.rate)!)" }
                                .inlineStyle("padding-right", "15px")

                            td { "\(goed.vatPercentage?.percent ?? 0%)" }
                                .inlineStyle("padding-right", "15px")
                        }
                    case let .service(dienst):
                        tr {
                            td { "\(dienst.description)" }
                                .inlineStyle("padding-right", "15px")

                            td { "\(dienst.amountOfHours)" }
                                .inlineStyle("padding-right", "15px")

                            td {
                                dienst.amountOfHours <= 1 ? TranslatedString.hour.capitalized() : TranslatedString.hours.capitalized()
                            }
                                .inlineStyle("padding-right", "15px")

                            td { "\(NumberFormatter.money.string(for: dienst.hourlyRate)!)" }
                                .inlineStyle("padding-right", "15px")

                            td { "\(dienst.vat ?? 0%)" }
                                .inlineStyle("padding-right", "15px")
                        }
                    }
                }
            }
            .inlineStyle("border-collapse", "separate")

            hr()

            table {
                tr {
                    td {
                        HTMLEmpty()
                    }
                    .inlineStyle("width", "100%")

                    td {
                        table {
                            tr {
                                td {
                                    TranslatedString(
                                        dutch: "Bedrag excl. BTW",
                                        english: "Amount excl. VAT"
                                    )
                                }
                                    .inlineStyle("white-space", "nowrap")
                                    .inlineStyle("padding-right", "15px")
                                td { "\(NumberFormatter.money.string(for: self.rows.total - self.rows.totalVAT)!)" }
                            }

                            tr {
                                td { TranslatedString.vat.uppercased() }
//                                    .inlineStyle("border-bottom", "3px double #000")
                                td { "\(NumberFormatter.money.string(for: self.rows.totalVAT)!)" }
                                    .inlineStyle("border-bottom", "3px double #000")
                            }

                            tr {
                                td { b { TranslatedString.totalAmount.capitalized } }
                                td { b { "\(NumberFormatter.money.string(for: self.rows.total)!)" } }
                            }
                        }
                    }
                }
            }
            .inlineStyle("border-collapse", "collapse")

            br()
            br()

            if let expiry = expiryDate {
                p {

                    HTMLText("""
                    \(TranslatedString(
                            dutch: "Wij verzoeken u vriendelijk het totaalbedrag van \(NumberFormatter.money.string(for: self.rows.total)!) uiterlijk \(expiry.formatted(usingLocaleDependency: true)) over te maken naar ",
                            english: "Please transfer the total amount of \(NumberFormatter.money.string(for: self.rows.total)!) by \(expiry.formatted(usingLocaleDependency: true)), to "

                        ))
                    """)
                    HTMLText(self.sender.iban)
                        .inlineStyle("white-space", "nowrap")
                    HTMLText("""
                    \(TranslatedString(
                        dutch: ", onder vermelding van ",
                        english: ", referencing "
                    ))
                    """)

                    "\(reference)"
                    "."
                }
            } else {
                p {
                    HTMLText("""
                    \(TranslatedString(
                            dutch: "Wij verzoeken u vriendelijk het totaalbedrag van \(NumberFormatter.money.string(for: self.rows.total)!) over te maken naar ",
                            english: "Please transfer the total amount of \(NumberFormatter.money.string(for: self.rows.total)!)  to "

                        ))
                    """)
                    HTMLText(self.sender.iban)
                        .inlineStyle("white-space", "nowrap")
                    HTMLText("""
                    \(TranslatedString(
                        dutch: ", onder vermelding van ",
                        english: ", referencing "
                    ))
                    """)

                    "\(reference)"
                    "."
                }
            }
        }
    }
}

extension Invoice {
    public enum Row {
        case goed(Invoice.Row.Goed)
        case service(Invoice.Row.Dienst)
    }
}

extension Invoice {
    public enum BTW {
        case procent21
    }
}

extension Invoice.BTW {
    public var percent: Percentage {
        switch self {
        case .procent21: return 21%
        }
    }
}

extension Invoice.Row {
    public struct Goed {
        let description: String
        let quantity: Double
        let unit: String
        let rate: Double
        let vatPercentage: Invoice.BTW?

        public init(description: String, quantity: Double, unit: String, rate: Double, vatPercentage: Invoice.BTW?) {
            self.description = description
            self.quantity = quantity
            self.unit = unit
            self.rate = rate
            self.vatPercentage = vatPercentage
        }
    }
}

extension Invoice.Row {
    public var total: Double {
        switch self {
        case let .service(dienst): return dienst.total
        case let .goed(goed): return goed.total
        }
    }

    public var totalVAT: Double {
        switch self {
        case let .service(dienst): return dienst.totalVAT
        case let .goed(goed): return goed.totalVAT
        }
    }
}

extension Array where Element == Invoice.Row {
    public var total: Double {
        self.reduce(0.0) { partialResult, row in
            partialResult + row.total
        }
    }

    public var totalVAT: Double {
        self.reduce(0.0) { partialResult, row in
            partialResult + row.totalVAT
        }
    }
}

extension Invoice.Row {
    public struct Dienst {
        let amountOfHours: Double
        let hourlyRate: Double
        let vat: Percentage?
        let description: String

        public init(
            amountOfHours: Double,
            hourlyRate: Double,
            vat: Percentage?,
            description: String
        ) {
            self.amountOfHours = amountOfHours
            self.hourlyRate = hourlyRate
            self.vat = vat
            self.description = description
        }
    }
}

extension Invoice.Row.Dienst {
    public var total: Double { self.amountOfHours * self.hourlyRate }
    public var totalVAT: Double { self.amountOfHours * self.hourlyRate * (self.vat ?? 0%).fraction }
}

extension Invoice.Row.Goed {
    public var total: Double { fatalError() }
    public var totalVAT: Double { fatalError() }
}

extension TranslatedString {
    public static let netherlands: Self = .init(
        dutch: "Nederland",
        english: "The Netherlands"
    )
}

extension Invoice.Sender {
    package static var preview: Self {
        .init(
            name: "Preview Invoice B.V.",
            address: [
                "Straat 1",
                "3544 CV Utrecht",
                "\(TranslatedString.netherlands)"
            ],
            phone: "+31 6 43901430",
            email: "info@previewfactuur.nl",
            website: "www.previewfactuur.nl",
            kvk: "87657654",
            btw: "BLBTW098765432",
            iban: "NLBUNG12345678"
        )
    }
}

extension Invoice.Recipient {
    package static var preview: Self {
        .init(
            id: "GFH12JK98J",
            name: "Cliënt B.V.",
            address: [
                "Laan der Wegen 56",
                "3555 HV Amsterdam",
                "\(TranslatedString.netherlands)"
            ]
        )
    }
}

extension Percentage {
    public static let vat_regular_dutch: Self = .init(fraction: 0.21)
}

extension Invoice {
    package static var preview: Self {
        .init(
            sender: .preview,
            client: .preview,
            invoiceNumber: "1",
            invoiceDate: Date.now,
            expiryDate: (Date.now + 1.months),
            metadata: [
                .purchaseOrderNumber.capitalized(): "PO12345678",
                .perEmail: "facturen@client.nl; naam@cliënt.nl"
            ],
            rows: [
                .service(
                    .init(
                        amountOfHours: 8,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: "\(TranslatedString.fixed_hours(week: 1))"
                    )
                ),
                .service(
                    .init(
                        amountOfHours: 8,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: "\(TranslatedString.fixed_hours(week: 2))"
                    )
                ),
                .service(
                    .init(
                        amountOfHours: 1,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: """
                        \(TranslatedString(
                            dutch: "additioneel verzocht werk: [...]",
                            english: "additionally requested work: : [...]"
                        ))
                        """
                    )
                ),
                .service(
                    .init(
                        amountOfHours: 8,
                        hourlyRate: 225.0,
                        vat: .vat_regular_dutch,
                        description: "\(TranslatedString.fixed_hours(week: 3))"
                    )
                )
            ]
        )
    }
}

extension TranslatedString {
    package static func fixed_hours(week: Int) -> TranslatedString {
        return .init(
            dutch: "week \(week) vaste uren",
            english: "week \(week) fixed hours"
        )
    }
}
//
//#if os(macOS) && canImport(SwiftUI)
//import SwiftUI
//#Preview {
//    HTMLPreview.modern {
//        Invoice.preview
//    }
//    .frame(width: 632, height: 750)
//}
//#endif
