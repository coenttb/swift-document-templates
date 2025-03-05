//
//  Signature Page.swift
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
    public let signatoryGroups: [SignatoryGroup]
    public let displayMode: DisplayMode
    
    /// Create a signature page with signatory groups
    public init(
        title: TranslatedString = .signatures,
        subtitle: TranslatedString? = nil,
        signatoryGroups: [SignatoryGroup],
        displayMode: DisplayMode = .groupedBySignatory
    ) {
        self.title = title
        self.subtitle = subtitle
        self.signatoryGroups = signatoryGroups
        self.displayMode = displayMode
    }
}

extension SignaturePage {
    public typealias Metadata = OrderedDictionary<TranslatedString, TranslatedString>
    
    /// How to display signatories on the signature page
    public enum DisplayMode {
        /// Group signature blocks by signatory with headers
        case groupedBySignatory
        
        /// Display each signatory in its own section with clear separation
        case separateSignatories
        
        /// Display signatories in columns (side by side)
        case columns
    }
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

            switch displayMode {
            case .groupedBySignatory:
                renderGroupedView()
            case .separateSignatories:
                renderSeparateView()
            case .columns:
                renderColumnsView()
            }
        }
        .padding(20.px)
    }
    
    private func renderGroupedView() -> AnyHTML {
        AnyHTML(
            div {
                HTMLForEach(signatoryGroups) { signatoryGroup in
                    div {
                        // Signatory group header
                        h3 {
                            signatoryGroup.name
                        }
                        
                        // Metadata if present
                        if !signatoryGroup.metadata.isEmpty {
                            table {
                                HTMLForEach(signatoryGroup.metadata.map { $0 }) { key, value in
                                    tr {
                                        td {
                                            key.map { $0.capitalizingFirstLetter() }
                                        }
                                        .width(120.px)
                                        .padding(right: 15.px)
                                        
                                        td {
                                            value
                                        }
                                    }
                                }
                            }
                            .margin(bottom: 15.px)
                            .borderCollapse(.collapse)
                        }
                        
                        // Signer blocks
                        HTMLForEach(signatoryGroup.signers) { signer in
                            SignerBlock(
                                signer: signer,
                                date: .now,
                                location: "Amsterdam"
                            )
                        }
                    }
                    .margin(bottom: 30.px)
                }
            }
        )
    }
    
    private func renderSeparateView() -> AnyHTML {
        AnyHTML(
            div {
                HTMLForEach(signatoryGroups) { signatoryGroup in
                    div {
                        h3 {
                            signatoryGroup.name
                        }
                        
                        // Metadata if present
                        if !signatoryGroup.metadata.isEmpty {
                            table {
                                HTMLForEach(signatoryGroup.metadata.map { $0 }) { key, value in
                                    tr {
                                        td {
                                            key.map { $0.capitalizingFirstLetter() }
                                        }
                                        .width(120.px)
                                        .padding(right: 15.px)
                                        
                                        td {
                                            value
                                        }
                                    }
                                }
                            }
                            .margin(bottom: 15.px)
                            .borderCollapse(.collapse)
                        }
                        
                        HTMLForEach(signatoryGroup.signers) { signer in
                            SignerBlock(
                                signer: signer
                            )
                        }
                    }
                    .margin(bottom: 40.px)
                    .padding(20.px)
                    .border(.all(width: 1.px, style: .solid, color: .hex("ccc")))
                }
            }
        )
    }
    
    private func renderColumnsView() -> AnyHTML {
        AnyHTML(
            div {
                div {
                    HTMLForEach(signatoryGroups) { signatoryGroup in
                        div {
                            h3 {
                                signatoryGroup.name
                            }
                            
                            // Metadata if present
                            if !signatoryGroup.metadata.isEmpty {
                                table {
                                    HTMLForEach(signatoryGroup.metadata.map { $0 }) { key, value in
                                        tr {
                                            td {
                                                key.map { $0.capitalizingFirstLetter() }
                                            }
                                            .width(120.px)
                                            .padding(right: 15.px)
                                            
                                            td {
                                                value
                                            }
                                        }
                                    }
                                }
                                .margin(bottom: 15.px)
                                .borderCollapse(.collapse)
                            }
                            
                            HTMLForEach(signatoryGroup.signers) { signer in
                                SignerBlock(
                                    signer: signer
                                )
                            }
                        }
                        .padding(10.px)
//                        .width(calc: "50% - 20px")
                    }
                }
                .display(.flex)
                .flexDirection(.row)
                .flexWrap(.wrap)
                .rowGap(20.px)
                .columnGap(.length(20.px))
            }
        )
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
            signatoryGroups: [
                SignatoryGroup.preview,
                .init(
                    name: TranslatedString(
                        dutch: "TechCorp B.V.",
                        english: "TechCorp Inc."
                    ),
                    role: .buyer,
                    signers: [
                        .naturalPerson(.init(name: "Sarah Johnson", position: "CTO"))
                    ]
                )
            ],
            displayMode: .groupedBySignatory
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

