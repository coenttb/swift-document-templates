//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 12/06/2021.
//

import Foundation
import HTML
import Translating

extension Letter {
    public struct Header {
        let sender: Letter.Sender
        let recipient: Letter.Recipient
        let location: String?
        let date: (sending: Date?, signature: Date?)
        let subject: String?
        let reference: String? = nil
        let salutation: TranslatedString

        public init(
            sender: Letter.Sender,
            recipient: Letter.Recipient,
            location: String?,
            date: (sending: Date?, signature: Date?),
            subject: String?,
            salutation: TranslatedString = .salutation
        ) {
            self.sender = sender
            self.recipient = recipient
            self.location = location
            self.date = date
            self.subject = subject
            self.salutation = salutation
        }
    }
}

extension Letter.Header: HTML {
    @HTMLBuilder
    public var body: some HTML {
        table {
            tr {
                td {
                    recipient
                }
                .inlineStyle("vertical-align", "top")
                .inlineStyle("width", "100%")

                td {
                    sender
                }
                .inlineStyle("vertical-align", "top")
            }

        }
        .inlineStyle("width", "100%")
        .inlineStyle("border-collapse", "collapse")

        switch (location, date.sending) {
        case let (.some(location), .some(date)):
            HTMLText("\(location), \(date.formatted(date: .long, time: .omitted, translated: true))")
            br()
        case let (.some(location), .none):
            HTMLText("\(location)")
            br()
        case let (.none, .some(date)):
            HTMLText("\(date.formatted(date: .long, time: .omitted, translated: true)))")
            br()
        case (.none, .none):
            HTMLEmpty()
        }

        if let subject {
            TranslatedString(
                dutch: "betreft",
                english: "subject"
            ).capitalizingFirstLetter()
            ": "
            "\(subject)"
            br()
        }
    }
}

extension Letter.Header {
    package static var preview: Self {
        .init(
            sender: .preview,
            recipient: .preview,
            location: "Utrecht",
            date: (sending: Date.now, signature: nil),
            subject: "Important Information Enclosed"
        )
    }

}

#if os(macOS) && canImport(SwiftUI)
import SwiftUI
#Preview {
    HTMLDocument {
        Letter.Header.preview
    }
    .frame(width: 451, height: 698)
}
#endif
