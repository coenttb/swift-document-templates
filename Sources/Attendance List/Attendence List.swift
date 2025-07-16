//
//  AttendanceList.swift
//
//
//  Created by [Your Name] on [Date].
//

import Foundation
import HTML
import Languages
import OrderedCollections
import PointFreeHtmlLanguages

public struct AttendanceList {
    public var title: String
    public var metadata: Metadata
    public var attendees: [AttendanceList.Attendee]

    public typealias Metadata = OrderedDictionary<TranslatedString, String>

    public init(
        title: String,
        metadata: Metadata = [:],
        attendees: [AttendanceList.Attendee]
    ) {
        self.title = title
        self.metadata = metadata
        self.attendees = attendees
    }
}

extension AttendanceList {
    public struct Attendee {
        let firstName: String
        let lastName: String
        let role: String
        let signature: String?

        public init(firstName: String, lastName: String, role: String, signature: String? = nil) {
            self.firstName = firstName
            self.lastName = lastName
            self.role = role
            self.signature = signature
        }
    }
}

extension AttendanceList.Attendee {
    static let empty: Self = .init(firstName: "", lastName: "", role: "")
}

extension AttendanceList: HTML {
    public var body: some HTML {
        h1 {
            TranslatedString(
                dutch: "Aanwezigheidslijst",
                english: "Attendance List"
            )
        }

        table {
            HTMLForEach(self.metadata.map { $0 }) { (key, value) in
                tr {
                    td {
                        "\(key)"
                    }
                    .inlineStyle("text-align", "right")
                    .inlineStyle("vertical-align", "top")
                    .inlineStyle("padding-right", "10px")

                    td { "\(value)" }
                }
            }
        }

        br()()

        table {
            tr {
                th { HTMLText("Last name") }
                    .inlineStyle("padding-block", "15px")
                th { HTMLText("First name") }
                    .inlineStyle("padding-block", "15px")
                th { HTMLText("Role") }
                    .inlineStyle("padding-block", "15px")
                th { HTMLText("Signature") }
                    .inlineStyle("padding-block", "15px")
            }
            .inlineStyle("border", "1px solid black")

            HTMLForEach(attendees) { attendee in
                HTMLGroup {
                    tr {
                        td { HTMLText(attendee.lastName) }
                            .inlineStyle("padding-block", "\(!attendee.lastName.isEmpty ? "15px" : "25px")")
                        td { HTMLText(attendee.firstName) }
                            .inlineStyle("padding-block", "\(!attendee.firstName.isEmpty ? "15px" : "25px")")
                        td { HTMLText(attendee.role) }
                            .inlineStyle("padding-block", "\(!attendee.role.isEmpty ? "15px" : "25px")")
                        td { HTMLText(attendee.signature ?? "") }

                    }
                    .inlineStyle("border", "1px solid black")
                }.inlineStyle("padding-block", "15px")
            }
        }
        .width(.percent(100))
        .borderCollapse(.collapse)

    }
}

extension AttendanceList.Attendee: HTML {
    public var body: some HTML {
        tr {
            td { HTMLText(self.lastName) }
            td { HTMLText(self.firstName) }
            td { HTMLText(self.role) }
            td { HTMLText(self.signature ?? "") }
        }
        .inlineStyle("border", "1px solid black")
    }
}

extension AttendanceList {
    package static var preview: Self {
        AttendanceList(
            title: "Attendance",
            metadata: [
                "date": "\(Date.now.formatted(date: .long, time: .omitted).localized)",
                "location": "Utrecht"

            ],
            attendees: [
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty,
                .empty
            ]
        )
    }
}

extension AttendanceList {
    public static let singlePage: Self = AttendanceList(
        title: "Attendance",
        attendees: [
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty,
            .empty
        ]
    )
}

// #if os(macOS) && canImport(SwiftUI)
// import SwiftUI
// #Preview {
//    HTMLDocument {
//        AttendanceList.preview
//    }
//    .frame(width: 600, height: 800)
// }
// #endif
