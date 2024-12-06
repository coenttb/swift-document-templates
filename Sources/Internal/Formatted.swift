//
//  File.swift
//
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Dependencies
import Foundation

extension Date {
    public func formatted(date: FormatStyle.DateStyle, time: FormatStyle.TimeStyle) -> FormattedDate {
        FormattedDate(date: self, formatStyle: .init(date: date, time: time))
    }
}

public struct FormattedDate {
    let date: Date
    let formatStyle: Date.FormatStyle
    
    public var localized: String {
        @Dependency(\.locale) var locale
        return date.formatted(formatStyle.locale(locale))
    }
}

extension FormatStyle where Self == Date.FormatStyle {
    public static var longDate: Self {
        
        @Dependency(\.locale) var locale
        
        return .init(date: .long, time: .omitted)
            .locale(locale)
    }
}
