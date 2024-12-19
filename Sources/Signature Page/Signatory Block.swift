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
            
            // Block-specific metadata
            if !metadata.isEmpty {
                tr {
                    td {
                        table {
                            HTMLForEach(metadata.map { $0 }) { key, value in
                                tr {
                                    td {
                                         key
                                    }
                                    .padding(right: 15.px)
                                    
                                    td {
                                        value
                                    }
                                }
                            }
                        }
                        .borderCollapse(.collapse)
                        .padding(top: 10.px)
                    }
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
            
            if !person.metadata.isEmpty {
                table {
                    HTMLForEach(person.metadata.map { $0 }) { key, value in
                        tr {
                            td {
                                key
                            }
                            .padding(right: 10.px)
                            
                            td {
                                value
                            }
                        }
                    }
                }
                .borderCollapse(.collapse)
                .padding(top: 5.px)
            }
            
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
            
            // Entity metadata
            if !entity.metadata.isEmpty {
                table {
                    HTMLForEach(entity.metadata.map { $0 }) { key, value in
                        tr {
                            td {
                                key
                            }
                            .padding(right: 10.px)
                            
                            td { value }
                        }
                    }
                }
                .borderCollapse(.collapse)
                .padding(vertical: 5.px)
            }
            
            // Representatives with signature lines
            HTMLForEach(entity.representatives) { representative in
                div {
                    renderSignatoryContent(representative.signatory, isTopLevel: false)
                    TranslatedString.inCapacityOf
                    " "
                    representative.capacity
                    
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
