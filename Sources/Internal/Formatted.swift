//
//  File.swift
//  
//
//  Created by Coen ten Thije Boonkkamp on 30/07/2024.
//

import Dependencies
import Foundation

extension Date.FormatStyle {
    package static func dependency(
        date: DateStyle?,
        time: TimeStyle?
    ) -> Date.FormatStyle {
        @Dependency(\.locale) var locale

        return  .init(
            date: date,
            time: time,
            locale: locale,
            calendar: locale.calendar,
            timeZone: locale.timeZone ?? .autoupdatingCurrent,
            capitalizationContext: .unknown
        )
    }
}

extension Date {
    public func formatted(
        usingLocaleDependency: Bool,
        date: Date.FormatStyle.DateStyle = .long,
        time: Date.FormatStyle.TimeStyle = .omitted
    ) -> String {
        if usingLocaleDependency {
            return self.formatted(Date.FormatStyle.dependency(date: date, time: time))
        } else {
            return self.formatted(date: date, time: time)
        }

    }
}

extension NumberFormatter {
    public static let money: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.currencyCode = "EUR"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.locale = Locale(identifier: "nl_NL")
        return formatter
    }()
}
