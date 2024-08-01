//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import AttendenceList
import CSS
import Dependencies
import Foundation
import HTML
import HtmlToPdf
import Languages
import Locale
import Testing

@Test("HtmlToPdf")
func basldfva() async throws {

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")
    print(directory)

    let title: TranslatedString = .init(
        dutch: "Aanwezigheidslijst",
        english: "Attendencelist"
    )

    for wrap in ["minimal", "modern"] {
        for language in [Language.english, .dutch] {
            try await withDependencies {
                $0.language = language
                $0.locale = language.locale
            } operation: {
                let invoice: some HTML = AttendanceList.preview

                try await invoice.print(

                    title: "\(language) | \(title) | \(wrap)",
                    to: directory,
                    wrapInHtmlDocument: {
                        if wrap == "minimal" {
                            return HTMLPreview.minimal
                        }
                        if wrap == "modern" {
                            return HTMLPreview.modern
                        }

                        fatalError()
                    }()
                )
            }
        }
    }

}
