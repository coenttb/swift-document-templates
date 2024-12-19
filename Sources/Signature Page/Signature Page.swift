//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Foundation
import OrderedCollections
import Languages

public struct SignaturePage {
    public let title: TranslatedString
    public let subtitle: TranslatedString?
    public let date: Date?
    public let location: String?
    public let signatoryBlocks: [SignatoryBlock]
    
    public init(
        title: TranslatedString = .signatures,
        subtitle: TranslatedString? = nil,
        date: Date? = nil,
        location: String? = nil,
        signatoryBlocks: [SignatoryBlock]
    ) {
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.location = location
        self.signatoryBlocks = signatoryBlocks
    }
}


extension SignaturePage {
    public typealias Metadata = OrderedDictionary<TranslatedString, TranslatedString>
}


extension SignaturePage {
    static var preview: Self {
        .init(
            title: .signatures,
            subtitle: .init(
                dutch: "Ondergetekenden verklaren akkoord te zijn met de voorwaarden",
                english: "The undersigned declare to agree with the conditions"
            ),
            date: .now,
            location: "Amsterdam",
            signatoryBlocks: [
                SignatoryBlock(
//                    title: .init(
//                        dutch: "Eerste Partij",
//                        english: "First Party"
//                    ),
//                    description: .init(
//                        dutch: "De Verkoper",
//                        english: "The Seller"
//                    ),
                    signatory: .chainPreview,
                    metadata: [
                        .init(
                            dutch: "Opmerkingen",
                            english: "Remarks"
                        ): .init(
                            dutch: "Origineel getekend",
                            english: "Originally signed"
                        )
                    ]
                ),
                SignatoryBlock(
//                    title: .init(
//                        dutch: "Tweede Partij",
//                        english: "Second Party"
//                    ),
//                    description: .init(
//                        dutch: "De Koper",
//                        english: "The Buyer"
//                    ),
                    signatory: .chainPreview
                )
            ]
        )
    }
}
