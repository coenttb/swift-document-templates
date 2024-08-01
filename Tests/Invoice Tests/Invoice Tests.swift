//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 19/07/2024.
//

import CSS
import Dependencies
import Foundation
import HTML
import HtmlToPdf
import Invoice
import Languages
import Locale
import SwiftDate
import Testing

@Test("HtmlToPdf")
func basldfva() async throws {
    
    let directory = URL(filePath: #filePath).deletingLastPathComponent().appending(component: "Output")
    print(directory)
    
    let invoice_title: TranslatedString = .init(
        dutch: "Factuur",
        english: "Invoice"
    )
    
    enum Style {
        case minimal, modern
    }
    
    for wrap in [Style.minimal, .modern] {
        for language in [Language.english, .dutch] {
            try await withDependencies {
                $0.language = language
                $0.locale = language.locale
            } operation: {
                let invoice: some HTML = Invoice.preview
                try await invoice.print(
                    title: "\(language) | \(invoice_title) | \(wrap)",
                    to: directory,
                    wrapInHtmlDocument: {
                        switch wrap {
                        case .minimal:
                            HTMLPreview.minimal
                        case .modern:
                            HTMLPreview.modern
                            
                        }
                    }()
                )
            }
        }
    }
}
