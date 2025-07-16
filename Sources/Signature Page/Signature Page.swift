//
//  Signature Page.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Foundation
import OrderedCollections
import Languages
import HTML
import TranslatedString
import Date

public struct SignaturePage {
    public let title: TranslatedString
    public let subtitle: TranslatedString?
    public let signatories: [Signatory]
    public let displayMode: DisplayMode
    
    /// Create a signature page with signatories
    public init(
        title: TranslatedString = .signatures,
        subtitle: TranslatedString? = nil,
        signatories: [Signatory],
        displayMode: DisplayMode = .groupedBySignatory
    ) {
        self.title = title
        self.subtitle = subtitle
        self.signatories = signatories
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
                .margin(bottom: subtitle != nil ? .px(5) : .px(20))
            
            if let subtitle {
                p { subtitle }
                    .margin(bottom: .px(20))
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
        .padding(.px(20))
    }
    
    private func renderGroupedView() -> AnyHTML {
        AnyHTML(
            div {
                HTMLForEach(signatories) { signatory in
                    switch signatory {
                    case .group(let name, let individuals, let metadata):
                        div {
                            // Signatory group header
                            h3 { name }
                            
                            // Metadata if present
                            if !metadata.isEmpty {
                                table {
                                    HTMLForEach(metadata.map { $0 }) { key, value in
                                        tr {
                                            td {
                                                key.map { $0.capitalizingFirstLetter() }
                                            }
                                            .width(.px(120))
                                            .padding(right: .px(15))
                                            
                                            td {
                                                value
                                            }
                                        }
                                    }
                                }
                                .margin(bottom: .px(15))
                                .borderCollapse(.collapse)
                            }
                            
                            // Person blocks
                            HTMLForEach(individuals) { person in
                                Signatory.Person.Block(
                                    person: person
                                )
                            }
                        }
                        .margin(bottom: .px(30))
                        
                    case .individual(let name, let metadata):
                        // For individual signers, render the signer block directly without a group header
                        Signatory.Person.Block(
                            person: .init(name: name, metadata: metadata)
                        )
                        .margin(bottom: .px(30))
                    }
                }
            }
        )
    }
    
    private func renderSeparateView() -> AnyHTML {
        AnyHTML(
            div {
                HTMLForEach(signatories) { signatory in
                    switch signatory {
                    case .group(let name, let individuals, let metadata):
                        div {
                            h3 { name }
                            
                            // Metadata if present
                            if !metadata.isEmpty {
                                table {
                                    HTMLForEach(metadata.map { $0 }) { key, value in
                                        tr {
                                            td {
                                                TranslatedString(key.english).map { $0.capitalizingFirstLetter() }
                                            }
                                            .width(.px(120))
                                            .padding(right: .px(15))
                                            
                                            td {
                                                value
                                            }
                                        }
                                    }
                                }
                                .margin(bottom: .px(15))
                                .borderCollapse(.collapse)
                            }
                            
                            HTMLForEach(individuals) { person in
                                Signatory.Person.Block(person: person)
                            }
                        }
                        .margin(bottom: .px(40))
                        .padding(.px(20))
                        .border(
                            .top, .bottom, .left, .right,
                            width: .px(1),
                            style: .solid,
                            color: .init(light: .hex("ccc")),
                        )
                        
                    case .individual(let name, let metadata):
                        // For individual signers, render in a container without a header
                        div {
                            Signatory.Person.Block(
                                person: .init(name: name, metadata: metadata)
                            )
                        }
                        .margin(bottom: .px(40))
                        .padding(.px(20))
                        .border(
                            .top, .bottom, .left, .right,
                            width: .px(1),
                            style: .solid,
                            color: .init(light: .hex("ccc")),
                        )
                    }
                }
            }
        )
    }
    
    private func renderColumnsView() -> AnyHTML {
        AnyHTML(
            div {
                div {
                    HTMLForEach(signatories) { signatory in
                        switch signatory {
                        case .group(let name, let individuals, let metadata):
                            div {
                                h3 { name }
                                
                                // Metadata if present
                                if !metadata.isEmpty {
                                    table {
                                        HTMLForEach(metadata.map { $0 }) { key, value in
                                            tr {
                                                td {
                                                    TranslatedString(key.english).map { $0.capitalizingFirstLetter() }
                                                }
                                                .width(.px(120))
                                                .padding(right: .px(15))
                                                
                                                td {
                                                    value
                                                }
                                            }
                                        }
                                    }
                                    .margin(bottom: .px(15))
                                    .borderCollapse(.collapse)
                                }
                                
                                HTMLForEach(individuals) { person in
                                    Signatory.Person.Block(person: person)
                                }
                            }
                            .padding(.px(10))
//                            .width(calc: "50% - 20px")
                            
                        case .individual(let name, let metadata):
                            // For individual signers, render in a column without a header
                            div {
                                Signatory.Person.Block(
                                    person: .init(name: name, metadata: metadata)
                                )
                            }
                            .padding(.px(10))
//                            .width(calc: "50% - 20px")
                        }
                    }
                }
                .display(.flex)
                .flexDirection(.row)
                .flexWrap(.wrap)
                .rowGap(.px(20))
                .columnGap(.length(.px(20)))
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
            signatories: [
                // A company with multiple signers
                Signatory.preview,
                
                // A company with one signer
                .group(
                    name: TranslatedString(
                        dutch: "TechCorp B.V.",
                        english: "TechCorp Inc."
                    ), 
                    signers: [
                        .init(name: "Sarah Johnson", position: "CTO")
                    ],
                    metadata: [.role: .buyer]
                ),
                
                // Individual with position and metadata
                .individual(
                    name: "Coen ten Thije Boonkkamp", 
                    position: "Developer",
                    metadata: [.dateOfBirth: "1980-01-01"]
                ),
                
                // Simple individual with just a name
                .individual(
                    name: "Another Individual Signer",
                    metadata: [
                        .date: .init(
                            Date.now.formatted(
                            date: .complete,
                            time: .omitted
                        )
                        )
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
    prepareDependencies {
        $0.language = .dutch
    }
    
    return HTMLDocument {
        SignaturePage.preview
    }
    .frame(width: 632, height: 750)
}
#endif

