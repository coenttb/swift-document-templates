//
//  File.swift
//  swift-document-templates
//
//  Created by Coen ten Thije Boonkkamp on 06/12/2024.
//

import Languages

extension TranslatedString {
    public static let signatures = TranslatedString(
        dutch: "Ondertekening",
        english: "Signatures"
    )
    
    public static let signedAt = TranslatedString(
        dutch: "Getekend te",
        english: "Signed at"
    )
    
    public static let signedOn = TranslatedString(
        dutch: "Getekend op",
        english: "Signed on"
    )
    
    public static let onBehalfOf = TranslatedString(
        dutch: "Namens",
        english: "On behalf of"
    )
    
    public static let inCapacityOf = TranslatedString(
        dutch: "In hoedanigheid van",
        english: "In capacity of"
    )
}


extension String {
    func repeated(_ count: Int) -> String {
        String(repeating: self, count: count)
    }
}
