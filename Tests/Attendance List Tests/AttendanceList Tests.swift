//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import Attendance_List
import Dependencies
import Foundation
import HTML
import HtmlToPdf
import Testing
import Translating

@Test("Attendance List")
func basldfva() async throws {
    @Dependency(\.pdf) var pdf

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")
    print(directory)

    let title: TranslatedString = .init(
        dutch: "Aanwezigheidslijst",
        english: "Attendancelist"
    )

    enum Style {
        case minimal
        case modern
    }

    for wrap in [Style.minimal, Style.modern] {
        for language in [Language.english, .dutch] {
            try await withDependencies {
                $0.language = language
                $0.locale = language.locale
            } operation: {
                let attendanceList: some HTML = AttendanceList.preview

                let filename = "Attendance List \(language) | \(title) | \(wrap).pdf"
                let fileURL = directory.appendingPathComponent(filename)
                try await pdf.render(html: HTMLDocument { attendanceList }, to: fileURL)
            }
        }
    }
}
