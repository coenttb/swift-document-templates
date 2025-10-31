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
import HtmlToPdf
import Testing
import Translating

@Test("Agenda")
func basldfva() async throws {
  @Dependency(\.pdf) var pdf

  let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(
    component: "Output"
  )
  print(directory)

  for language in [Language.english, .dutch] {
    try await withDependencies {
      $0.language = language
    } operation: {
      let agenda: Agenda = .init(
        items: [
          .init(
            title: "\(TranslatedString(dutch: "Nederlands", english: "English"))"
          ),
          .init(title: "test"),
          .init(title: "test"),
          .init(title: "test"),
          .init(title: "test"),
          .init(title: "test"),
        ]
      )

      let filename = "Agenda \(language).pdf"
      let fileURL = directory.appendingPathComponent(filename)
      try await pdf.render(html: HTMLDocument { agenda }, to: fileURL)
    }
  }
}
