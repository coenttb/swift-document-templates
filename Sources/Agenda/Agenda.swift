//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 27/11/2020.
//

import Foundation
import HTML
import Internal
import Languages

public struct Agenda {
    public var title: String
    public var date: Date?
    public var variant: Agenda.Variant
    public var items: [Agenda.Item]

    public init(title: String, date: Date? = nil, variant: Agenda.Variant, items: [Agenda.Item]) {
        self.title = title
        self.date = date
        self.variant = variant
        self.items = items
    }
}

extension Agenda {
    public struct Item {
        let title: String
        let important: Bool

        public init(title: String, important: Bool = false) {
            self.title = title
            self.important = important
        }
    }
}
extension Agenda {
    public enum Variant {
        case short
        case full(subtitle: String, bodyHeader: String)
    }
}

extension Agenda: HTML {
    public var body: some HTML {
        if !items.isEmpty {
            h1 {
                TranslatedString(
                    dutch: "Agenda",
                    english: "Agenda"
                )
            }

            h2 {
                TranslatedString(
                    dutch: "Onderwerpen",
                    english: "Subjects"
                )
            }

            ul {
                for item in items {
                    li { HTMLText(item.title) }
                        .inlineStyle("color", item.important ? "red" : nil)
                }
            }
        }
    }
}

extension Agenda.Item: HTML {
    public var body: some HTML {
        li { HTMLText(self.title) }
            .inlineStyle("color", self.important ? "red" : nil)
    }
}

 #if canImport(SwiftUI)
 import SwiftUI
 #Preview {
     HTMLPreview.modern {
         Agenda(
             title: "Title",
             variant: .short,
             items: [
                 .init(title: "test", important: true),
                 .init(title: "test"),
                 .init(title: "test"),
                 .init(title: "test", important: true),
                 .init(title: "test")
             ]
         )
     }
    .frame(width: 400, height: 600)
 }
 #endif
