//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 28/07/2024.
//

import Foundation
import HTML
import TranslatedString

extension TranslatedString: @retroactive HTML {
    public var body: some HTML {
        HTMLText("\(self)")
    }
}

extension HTMLText {
    public init(_ translatedString: TranslatedString) {
        self = .init("\(translatedString)")
    }
}
