//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Foundation
import CoenttbHTML
import TranslatedString
import OrderedCollections

public struct SignatoryBlock {
    public let title: TranslatedString?
    public let signatory: Signatory
    public let metadata: SignaturePage.Metadata
    
    public init(
        title: TranslatedString? = nil,
        signatory: Signatory,
        metadata: SignaturePage.Metadata = [:]
    ) {
        self.title = title
        self.signatory = signatory
        self.metadata = metadata
    }
    
    public init(
        title: TranslatedString? = nil,
        signatory: Signatory,
        date: Date,
        location: TranslatedString,
        other metadata: SignaturePage.Metadata = [:]
    ) {
        self.title = title
        self.signatory = signatory
        var metadata = metadata
        metadata[.date.capitalizingFirstLetter()] = .init(date.formatted(date: .numeric, time: .omitted))
        metadata[.location.capitalizingFirstLetter()] = location
        self.metadata = metadata
    }
}

extension SignatoryBlock: HTML {
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
                    renderSignatoryContent(signatory, isTopLevel: true)
                }
            }
        }
        .borderCollapse(.collapse)
        .margin(bottom: 30.px)
    }
    
    // Helper functions using AnyHTML to make the types explicit
    private func renderSignatoryContent(_ signatory: Signatory, isTopLevel: Bool) -> AnyHTML {
        switch signatory {
        case .naturalPerson(let person):
            return AnyHTML(renderNaturalPersonContent(person, isTopLevel: isTopLevel))
        case .legalEntity(let entity):
            return AnyHTML(renderLegalEntityContent(entity, isTopLevel: isTopLevel))
        }
    }
    
    private func renderNaturalPersonContent(_ person: Signatory.NaturalPerson, isTopLevel: Bool) -> some HTML {
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
                            .width(80.px)
                            .padding(right: 15.px)
                            .verticalAlign(.top)
                            
                            td {
                                value
                            }
                            .verticalAlign(.top)
                        }
                    }
                }
                
                // Block metadata (date, location) for top-level signatories
                if isTopLevel && !metadata.isEmpty {
                    HTMLForEach(metadata.map { $0 }) { key, value in
                        tr {
                            td {
                                key
                            }
                            .width(80.px)
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
            
            // Add signature line for natural persons
            if isTopLevel {
                div {
                    String(repeating: "_", count: 40)
                }
                .padding(vertical: 30.px)
                .maxWidth(300.px)
            }
        }
    }
    
    private func renderLegalEntityContent(_ entity: Signatory.LegalEntity, isTopLevel: Bool) -> some HTML {
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
                            .width(80.px)
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
            HTMLForEach(entity.representatives) { representative in
                div {
                    renderSignatoryContent(representative.signatory, isTopLevel: false)
                    
                    // Combined table for capacity (title) and metadata
                    table {
                        // Capacity (title) in a table row
                        tr {
                            td {
                                "Title"
                            }
                            .width(80.px)
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
                                    .width(80.px)
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
                    
                    // Signature line per representative
                    div {
                        String(repeating: "_", count: 40)
                    }
                    .padding(vertical: 30.px)
                    .maxWidth(300.px)
                }
                .padding(top: 5.px)
            }
        }
    }
}
