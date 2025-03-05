//
//  Signer Block.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Foundation
import CoenttbHTML
import TranslatedString
import OrderedCollections

public struct SignerBlock {
    public let title: TranslatedString?
    public let signer: Signer
    public let metadata: SignaturePage.Metadata
    public let style: Style
    public let signatureStyle: SignatureStyle
    
    public init(
        title: TranslatedString? = nil,
        signer: Signer,
        metadata: SignaturePage.Metadata = [:],
        style: Style = .default,
        signatureStyle: SignatureStyle = .line
    ) {
        self.title = title
        self.signer = signer
        self.metadata = metadata
        self.style = style
        self.signatureStyle = signatureStyle
    }
    
    public init(
        title: TranslatedString? = nil,
        signer: Signer,
        date: Date,
        location: String,
        other metadata: SignaturePage.Metadata = [:],
        style: Style = .default,
        signatureStyle: SignatureStyle = .line
    ) {
        self.title = title
        self.signer = signer
        var metadata = metadata
        metadata[.date.capitalizingFirstLetter()] = .init(date.formatted(date: .numeric, time: .omitted))
        metadata[.location.capitalizingFirstLetter()] = TranslatedString(location)
        self.metadata = metadata
        self.style = style
        self.signatureStyle = signatureStyle
    }
}

extension SignerBlock {
    /// Styling options for the signatory block
    public struct Style {
        public let showBorder: Bool
        public let backgroundColor: String?
        public let padding: Int
        public let metadataColumnWidth: Int
        
        public init(
            showBorder: Bool = false,
            backgroundColor: String? = nil,
            padding: Int = 10,
            metadataColumnWidth: Int = 80
        ) {
            self.showBorder = showBorder
            self.backgroundColor = backgroundColor
            self.padding = padding
            self.metadataColumnWidth = metadataColumnWidth
        }
        
        public static let `default` = Style()
        public static let bordered = Style(showBorder: true)
        public static let highlighted = Style(showBorder: true, backgroundColor: "#f9f9f9")
    }
    
    /// Options for how to display the signature area
    public enum SignatureStyle {
        /// Standard line for signature
        case line
        
        /// Box for signature with a label
        case box(TranslatedString)
        
        /// Line with printed name underneath
        case lineWithName
        
        /// No signature element (for digital-only documents)
        case none
        
        /// Image placeholder (for digital signatures)
        case imagePlaceholder
    }
}

extension SignerBlock: HTML {
    public var body: some HTML {
        table {
            if let title {
                tr {
                    td {
                        b { title }
                            .margin(bottom: 5.px)
                    }
                }
            }
            
            tr {
                td {
                    renderSignerContent(signer, isTopLevel: true)
                }
            }
        }
        .borderCollapse(.collapse)
        .margin(bottom: 30.px)
//        .then {
//            if style.showBorder {
//                $0.border(.all(width: 1.px, style: .solid, color: .hex("ccc")))
//            }
//        }
//        .then {
//            if let bgColor = style.backgroundColor {
//                $0.backgroundColor(bgColor)
//            }
//        }
        .padding(style.padding.px)
    }
    
    // Helper functions using AnyHTML to make the types explicit
    private func renderSignerContent(_ signer: Signer, isTopLevel: Bool) -> AnyHTML {
        switch signer {
        case .naturalPerson(let person):
            return AnyHTML(renderNaturalPersonContent(person, isTopLevel: isTopLevel))
        case .legalEntity(let entity):
            return AnyHTML(renderLegalEntityContent(entity, isTopLevel: isTopLevel))
        }
    }
    
    private func renderNaturalPersonContent(_ person: Signer.NaturalPerson, isTopLevel: Bool) -> some HTML {
        div {
            if isTopLevel {
                b { person.name }
            } else {
                person.name
            }
            
            // Create combined table for all metadata
            table {
                // Person metadata (title, position, etc.)
                if !person.metadata.isEmpty {
                    HTMLForEach(person.metadata.map { $0 }) { key, value in
                        tr {
                            td {
                                key.map { $0.capitalizingFirstLetter() }
                            }
                            .width(style.metadataColumnWidth.px)
                            .padding(right: 15.px)
                            .verticalAlign(.top)
                            
                            td {
                                value
                            }
                            .verticalAlign(.top)
                        }
                    }
                }
                
                // Block metadata (date, location) for top-level signers
                if isTopLevel && !metadata.isEmpty {
                    HTMLForEach(metadata.map { $0 }) { key, value in
                        tr {
                            td {
                                key
                            }
                            .width(style.metadataColumnWidth.px)
                            .padding(right: 15.px)
                            .verticalAlign(.top)
                            
                            td {
                                value
                            }
                            .verticalAlign(.top)
                        }
                    }
                }
            }
            .borderCollapse(.collapse)
            .padding(top: 5.px)
            
            // Render representatives if any
            if !person.representatives.isEmpty {
                div {
                    h5 {
                        TranslatedString(dutch: "Vertegenwoordigd door", english: "Represented by")
                    }
                    
                    HTMLForEach(person.representatives) { representative in
                        div {
                            renderSignerContent(representative.signer, isTopLevel: false)
                            
                            table {
                                tr {
                                    td {
                                        TranslatedString(dutch: "Hoedanigheid", english: "Capacity")
                                    }
                                    .width(style.metadataColumnWidth.px)
                                    .padding(right: 15.px)
                                    .verticalAlign(.top)
                                    
                                    td {
                                        representative.capacity
                                    }
                                    .verticalAlign(.top)
                                }
                            }
                            .borderCollapse(.collapse)
                            .padding(top: 5.px)
                            
                            renderSignatureArea()
                        }
                        .padding(top: 10.px)
                    }
                }
                .padding(top: 10.px)
            }
            
            // Add signature area for natural persons if top level
            if isTopLevel {
                renderSignatureArea()
            }
        }
    }
    
    private func renderLegalEntityContent(_ entity: Signer.LegalEntity, isTopLevel: Bool) -> some HTML {
        div {
            // Entity name
            if isTopLevel {
                h4 { entity.name }
                    .margin(vertical: 10.px)
            } else {
                b { entity.name }
            }
            
            // Entity metadata in a table with fixed column width
            if !entity.metadata.isEmpty {
                table {
                    HTMLForEach(entity.metadata.map { $0 }) { key, value in
                        tr {
                            td {
                                key.map { $0.capitalizingFirstLetter() }
                            }
                            .width(style.metadataColumnWidth.px)
                            .padding(right: 15.px)
                            .verticalAlign(.top)
                            
                            td {
                                value
                            }
                            .verticalAlign(.top)
                        }
                    }
                }
                .borderCollapse(.collapse)
                .padding(top: 5.px)
            }
            
            // Representatives with signature lines
            if !entity.representatives.isEmpty {
                div {
                    h5 {
                        TranslatedString(dutch: "Vertegenwoordigd door", english: "Represented by")
                    }
                    
                    HTMLForEach(entity.representatives) { representative in
                        div {
                            renderSignerContent(representative.signer, isTopLevel: false)
                            
                            // Combined table for capacity (title) and metadata
                            table {
                                // Capacity (title) in a table row
                                tr {
                                    td {
                                        TranslatedString(dutch: "Hoedanigheid", english: "Capacity")
                                    }
                                    .width(style.metadataColumnWidth.px)
                                    .padding(right: 15.px)
                                    .verticalAlign(.top)
                                    
                                    td {
                                        representative.capacity
                                    }
                                    .verticalAlign(.top)
                                }
                                
                                // Block metadata (date/location) before signature line
                                if isTopLevel && !metadata.isEmpty {
                                    HTMLForEach(metadata.map { $0 }) { key, value in
                                        tr {
                                            td {
                                                key
                                            }
                                            .width(style.metadataColumnWidth.px)
                                            .padding(right: 15.px)
                                            .verticalAlign(.top)
                                            
                                            td {
                                                value
                                            }
                                            .verticalAlign(.top)
                                        }
                                    }
                                }
                            }
                            .borderCollapse(.collapse)
                            .padding(top: 5.px)
                            
                            // Signature area per representative
                            renderSignatureArea()
                        }
                        .padding(top: 10.px)
                    }
                }
            }
        }
    }
    
    private func renderSignatureArea() -> AnyHTML {
        switch signatureStyle {
        case .line:
            return AnyHTML(
                div {
                    String(repeating: "_", count: 40)
                }
                .padding(vertical: 30.px)
                .maxWidth(300.px)
            )
            
        case .box(let label):
            return AnyHTML(
                div {
                    div {
                        label
                    }
                    .fontStyle(.italic)
                    .fontSize(12.px)
                    .margin(bottom: 5.px)
                    
                    div { }
                    .border(.all(width: 1.px, style: .solid, color: .hex("ccc")))
                    .height(80.px)
                    .width(200.px)
                }
                .padding(vertical: 20.px)
            )
            
        case .lineWithName:
            return AnyHTML(
                div {
                    div {
                        String(repeating: "_", count: 40)
                    }
                    .padding(vertical: 20.px)
                    .maxWidth(300.px)
                    
                    div {
                        switch signer {
                        case .naturalPerson(let person):
                            person.name
                        case .legalEntity(let entity):
                            entity.name
                        }
                    }
                    .fontStyle(.italic)
                    .fontSize(12.px)
                }
            )
            
        case .none:
            return AnyHTML(div { })
            
        case .imagePlaceholder:
            return AnyHTML(
                div {
                    div {
                        TranslatedString(dutch: "Digitale handtekening", english: "Digital Signature")
                    }
                    .fontStyle(.italic)
                    .fontSize(12.px)
                    .margin(bottom: 5.px)
                    
                    div { }
                    .border(.all(width: 1.px, style: .dashed, color: .hex("ccc")))
                    .backgroundColor(.hex("f9f9f9"))
                    .height(80.px)
                    .width(200.px)
                }
                .padding(vertical: 20.px)
            )
        }
    }
}
