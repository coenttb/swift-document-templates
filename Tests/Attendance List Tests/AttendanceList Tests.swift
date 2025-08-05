//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import Attendance_List
import CoenttbHtmlToPdf
import Dependencies
import Foundation
import HTML
import Translating
import Locale
import Testing

@Test("Attendance List")
func basldfva() async throws {

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

                try await attendanceList.print(

                    title: "Attendance List \(language) | \(title) | \(wrap)",
                    to: directory,
                    wrapInHtmlDocument: {
                        switch wrap {
                        case .minimal: /*HTMLDocument.minimal*/ fatalError()
                        case .modern: /*HTMLDocument*/ fatalError()
                        }
                    }()
                )
            }
        }
    }
}
