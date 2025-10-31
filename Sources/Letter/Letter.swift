//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 14/06/2020.
//

import Foundation
import HTML
import Translating

public struct Letter {
    let sender: Letter.Sender
    let recipient: Letter.Recipient
    let location: String?
    let date: (sending: Date?, signature: Date?)
    let subject: String?
    let reference: String? = nil
    let referenceTitel: TranslatedString
    let salutation: TranslatedString
    public let _body: AnyHTML

    public init<Body: HTML >(
        sender: Letter.Sender,
        recipient: Letter.Recipient,
        location: String?,
        date: (sending: Date?, signature: Date?),
        subject: String?,
        referenceTitel: TranslatedString = .referenceNumber,
        salutation: TranslatedString = .salutation,
        @HTMLBuilder body: () -> Body
    ) {
        self.sender = sender
        self.recipient = recipient
        self.location = location
        self.date = date
        self.subject = subject
        self.referenceTitel = referenceTitel
        self.salutation = salutation
        self._body = AnyHTML(body())
    }
}

extension Letter: HTML {
    public var body: some HTML {
        Letter.Header(
            sender: self.sender,
            recipient: self.recipient,
            location: self.location,
            date: self.date,
            subject: self.subject
        )
        br()
        _body
    }
}

extension Letter {
    package static var preview: Self {
        .init(
            sender: .preview,
            recipient: .preview,
            location: "Utrecht",
            date: (sending: Date.now, signature: nil),
            subject: "Letter") {
                "Test content"
            }
    }
}

// #if os(macOS) && canImport(SwiftUI)
// import SwiftUI
// #Preview {
//    HTMLDocument {
//        Letter.preview
//    }
//    .frame(width: 451, height: 698)
// }
// #endif
