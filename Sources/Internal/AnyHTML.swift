//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Foundation
import HTML

public struct AnyHTML: HTML {
    private let _render: (inout HTMLPrinter) -> Void
    private let _body: () -> AnyHTML

    public init<T: HTML>(_ html: T) {
        self._render = { printer in
            T._render(html, into: &printer)
        }
        self._body = {
            // If the body is of the same type, just wrap it in AnyHTML.
            AnyHTML(html.body)
        }
    }

    public var body: AnyHTML {
        _body()
    }

    public static func _render(_ html: AnyHTML, into printer: inout HTMLPrinter) {
        html._render(&printer)
    }
}
