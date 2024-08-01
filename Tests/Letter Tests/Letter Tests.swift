//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import Dependencies
import Foundation
import HTML
import HtmlToPdf
import Languages
import Letter
import Testing

@Test("HtmlToPdf")
func basldfva() async throws {

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")

    for language in [Language.english, .dutch] {
        try await withDependencies {
            $0.language = language
        } operation: {
            let letter: some HTML = Letter.Header.preview

            try await letter.print(
                title: "Letter \(language)",
                to: directory
            )
        }
    }
}
