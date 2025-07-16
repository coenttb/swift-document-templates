//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import Agenda
import Dependencies
import Foundation
import HTML
import CoenttbHtmlToPdf
import Languages
import Testing

@Test("Agenda")
func basldfva() async throws {

    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")
    print(directory)

    for language in [Language.english, .dutch] {
        try await withDependencies {
            $0.language = language
        } operation: {
            let agenda = Agenda(
                title: "Agenda Title",
                variant: .short,
                items: [
                    .init(
                        title: "\(TranslatedString(dutch: "Nederlands", english: "English"))"
                    ),
                    .init(title: "test", important: true),
                    .init(title: "test"),
                    .init(title: "test"),
                    .init(title: "test"),
                    .init(title: "test")
                ]
            )

            try await agenda.print(
                title: "Agenda \(language)",
                to: directory
            )
        }
    }
}
