//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 07/06/2022.
//

import Foundation
import CoenttbHTML

import Languages
import Letter
import OrderedCollections
import Percent
import Date

public struct Invoice {
    public let sender: Invoice.Sender
    public let client: Invoice.Recipient
    public let invoiceNumber: String
    public let invoiceDate: Date
    public let expiryDate: Date?
    public let metadata: Invoice.Metadata
    public let rows: [Invoice.Row]
    
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
                        
                        .margin(top: 0)
                        .margin(bottom: 0)
                    }
                    .verticalAlign(.top)
                    .width(100.percent)
                    
                    td {
                        table {
                            HTMLGroup {
                                tr {
                                    td { b { TranslatedString.clientNumber.capitalized } }
                                        .padding(right: 15.px)
                                    td { "\(self.client.id)" }
                                    
                                }
                                tr {
                                    td { b { TranslatedString.invoiceNumber.capitalized } }
                                        .padding(right: 15.px)
                                    td { "\(self.invoiceNumber)" }
                                    
                                }
                                tr {
                                    td { b { TranslatedString.invoiceDate.capitalized } }
                                        .padding(right: 15.px)
                                    
                                    td { "\(self.invoiceDate.formatted(date: .long, time: .omitted).localized)" }
                                    
                                }
                            }
                            .verticalAlign(.bottom)
                            .whiteSpace(.nowrap)
                            
                        }
                        
                    }
                    
                }
                .verticalAlign(.bottom)
            }
            .borderCollapse(.collapse)
            
            br()
            
            table {
                
                if let expiryDate = self.expiryDate {
                    tr {
                        td { TranslatedString.expiryDate.capitalized() }
                        td { "\(expiryDate.formatted(date: .long, time: .omitted).localized)" }
                    }
                }
                
                HTMLForEach(metadata.map { $0 }) { (key, value) in
                    tr {
                        td { "\(key)" }
                            .padding(right: 15.px)
                        td { "\(value)" }
                    }
                }
                
            }
            .borderCollapse(.collapse)
            
            br()
            br()
            
            table {
                
                thead {
                    tr {
                        td { b { TranslatedString.description.capitalized } }
                            .width(100.percent)
                            .padding(right: 15.px)
                        
                        td { b { TranslatedString.quantity.capitalized } }
                            .padding(right: 15.px)
                        
                        td { b { TranslatedString.unit.capitalized } }
                            .padding(right: 15.px)
                        
                        td { b { TranslatedString.rate.capitalized } }
                            .padding(right: 15.px)
                        
                        td { b { TranslatedString.vatPercentage.uppercased() } }
                            .padding(right: 15.px)
                    }
                    .inlineStyle("border-bottom", "1px solid #000")
                }
                
                HTMLForEach(self.rows) { row in
                    switch row {
                    case let .goed(goed):
                        tr {
                            td { "\(goed.description)" }
                                .padding(right: 15.px)
                            
                            td { "\(goed.quantity)" }
                                .padding(right: 15.px)
                            
                            td { TranslatedString.unit.capitalized() }
                                .padding(right: 15.px)
                            
                            td { "\(goed.rate.formatted(.euro))" }
                                .padding(right: 15.px)
                            
                            td { "\(goed.vatPercentage?.percent ?? 0%)" }
                                .padding(right: 15.px)
                        }
                    case let .service(dienst):
                        tr {
                            td { "\(dienst.description)" }
                                .padding(right: 15.px)
                            
                            td { "\(dienst.amountOfHours)" }
                                .padding(right: 15.px)
                            
                            td {
                                dienst.amountOfHours <= 1 ? TranslatedString.hour.capitalized() : TranslatedString.hours.capitalized()
                            }
                            .padding(right: 15.px)
                            
                            td { "\(dienst.hourlyRate.formatted(.euro))" }
                                .padding(right: 15.px)
                            
                            td { "\(dienst.vat ?? 0%)" }
                                .padding(right: 15.px)
                        }
                    }
                }
            }
            .borderCollapse(.separate)
            
            hr()
            
            table {
                tr {
                    td {
                        HTMLEmpty()
                    }
                    .width(100.percent)
                    
                    td {
                        table {
                            tr {
                                td {
                                    TranslatedString(
                                        dutch: "Bedrag excl. BTW",
                                        english: "Amount excl. VAT"
                                    )
                                }
                                .whiteSpace(.nowrap)
                                .padding(right: 15.px)
                                td { "\(self.rows.totalExcludingVAT.formatted(.euro))" }
                            }
                            
                            tr {
                                td { TranslatedString.vat.uppercased() }
                                //                                    .inlineStyle("border-bottom", "3px double #000")
                                td { "\(self.rows.totalVAT.formatted(.euro))" }
                                    .inlineStyle("border-bottom", "3px double #000")
                            }
                            
                            tr {
                                td { b { TranslatedString.totalAmount.capitalized } }
                                td { b { "\(self.rows.totalIncludingVAT.formatted(.euro))" } }
                            }
                        }
                    }
                }
            }
            .borderCollapse(.collapse)
            
            br()
            br()
            
            if let expiry = expiryDate {
                p {
                    
                    HTMLText("""
                    \(TranslatedString(
                            dutch: "Wij verzoeken u vriendelijk het totaalbedrag van \(self.rows.totalIncludingVAT.formatted(.euro)) uiterlijk \(expiry.formatted(date: .long, time: .omitted).localized) over te maken naar ",
                            english: "Please transfer the total amount of \(self.rows.totalIncludingVAT.formatted(.euro)) by \(expiry.formatted(date: .long, time: .omitted).localized), to "
                    
                        ))
                    """)
                    HTMLText(self.sender.iban)
                        .whiteSpace(.nowrap)
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
                            dutch: "Wij verzoeken u vriendelijk het totaalbedrag van \(self.rows.totalIncludingVAT.formatted(.euro)) over te maken naar ",
                            english: "Please transfer the total amount of \(self.rows.totalIncludingVAT.formatted(.euro))  to "
                    
                        ))
                    """)
                    HTMLText(self.sender.iban)
                        .whiteSpace(.nowrap)
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

extension FormatStyle where Self == FloatingPointFormatStyle<Double>.Currency {
    static var euro: Self {
        .currency(code: "EUR")
            .precision(.fractionLength(2))
            .locale(Locale(identifier: "nl_NL"))
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
    public var totalExcludingVAT: Double {
        self.reduce(0.0) { partialResult, row in
            partialResult + row.total
        }
    }
    
    public var totalIncludingVAT: Double {
        totalExcludingVAT + totalVAT
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
            expiryDate: Date.now,
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

#if os(macOS) && canImport(SwiftUI)
import SwiftUI
#Preview {
    HTMLPreview.modern {
        Invoice.preview
    }
    .frame(width: 632, height: 750)
}
#endif
