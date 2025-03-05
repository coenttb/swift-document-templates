//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Foundation
import OrderedCollections
import Languages
import CoenttbHTML
import TranslatedString

public struct SignaturePage {
    public let title: TranslatedString
    public let subtitle: TranslatedString?
    public let signatoryBlocks: [SignatoryBlock]
    
    public init(
        title: TranslatedString = .signatures,
        subtitle: TranslatedString? = nil,
        signatoryBlocks: [SignatoryBlock]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.signatoryBlocks = signatoryBlocks
    }
}


extension SignaturePage {
    public typealias Metadata = OrderedDictionary<TranslatedString, TranslatedString>
}

extension SignaturePage: HTML {
    public var body: some HTML {
        div {
            h2 { title }
                .margin(bottom: subtitle != nil ? 5.px : 20.px)
            
            if let subtitle {
                p { subtitle }
                    .margin(bottom: 20.px)
            }

            div {
                HTMLForEach(signatoryBlocks) { block in
                    block
                }
            }
        }
        .padding(20.px)
    }
}


extension SignaturePage {
    static var preview: Self {
        .init(
            title: .signatures,
            subtitle: .init(
                dutch: "Ondergetekenden verklaren akkoord te zijn met de voorwaarden",
                english: "The Parties have caused this agreement to be duly signed by the undersigned authorised representatives in separate signature pages the day and year first above written"
            ),
            signatoryBlocks: [
                SignatoryBlock(
                    signatory: .simple,
                    date: .now,
                    location: "Amsterdam",
                    other: [:
//                        .init(
//                            dutch: "Opmerkingen",
//                            english: "Remarks"
//                        ): .init(
//                            dutch: "Origineel getekend",
//                            english: "Originally signed"
//                        )
                    ]
                ),
                SignatoryBlock(
                    signatory: .chainPreview
                )
            ]
        )
    }
}


#if os(macOS) && canImport(SwiftUI)
import SwiftUI
#Preview {
    HTMLPreview.modern {
        SignaturePage.preview
    }
    .frame(width: 632, height: 750)
}
#endif

