//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 27/11/2020.
//

import Foundation
import HTML
import PointFreeHtmlLanguages
import Languages

public struct Agenda {
    public var items: [Agenda.Item]

    public init(items: [Agenda.Item]) {
        self.items = items
    }
}

extension Agenda {
    public struct Item {
        let title: String

        public init(
            title: String
        ) {
            self.title = title
        }
    }
}
extension Agenda.View {
    public enum Variant {
        case short
        case full(subtitle: String, bodyHeader: String)
    }
}

extension Agenda {
    public struct View: HTML {
        let agenda: Agenda
        let variant: Agenda.View.Variant = .short
        
        public init(agenda: Agenda) {
            self.agenda = agenda
        }
        
        public var body: some HTML {
            
            if !agenda.items.isEmpty {
                h1 {
                    TranslatedString(
                        dutch: "Agenda",
                        english: "Agenda"
                    )
                }

                h2 {
                    TranslatedString(
                        dutch: "Onderwerpen",
                        english: "Topics"
                    )
                }

                ul {
                    HTMLForEach(agenda.items) { item in
                        li { HTMLText(item.title) }
                    }
                }
            }
            
            switch variant {
            case .short:
                HTMLEmpty()
            case .full(subtitle: let subtitle, bodyHeader: let bodyHeader):
                HTMLEmpty()
            }
        }
    }
}

extension Agenda.Item: HTML {
    public var body: some HTML {
        li { HTMLText(self.title) }
    }
}

//#if canImport(SwiftUI)
// import SwiftUI
// #Preview {
//     HTMLDocument {
//         Agenda(
//             title: "Title",
//             variant: .short,
//             items: [
//                 .init(title: "test", important: true),
//                 .init(title: "test"),
//                 .init(title: "test"),
//                 .init(title: "test", important: true),
//                 .init(title: "test")
//             ]
//         )
//     }
//    .frame(width: 400, height: 600)
// }
// #endif
