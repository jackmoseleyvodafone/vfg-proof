//
//  VFGTimeframeControl.swift
//  VFGCommonUtils
//
//  Created by Emilio Alberto Ojeda Mendoza on 2/6/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

/// Control used to resolve a `String` (representing a timeframe) based on a given `Date`.
public class VFGTimeframeControl {

    internal enum Constants {
        static let defaultDateFormat: String = "MMM d, h:mm a"
        static let defaultLocale: Locale = .autoupdatingCurrent
    }

    /// The timeframes used to compare and resolve the label to return when calling `string(forDate:)`.
    public var timeframes: [VFGTimeframe]

    /// The `DateFormatter` used to format the returned `String` by `string(forDate:)` when no *timeframes* set.
    /// As default, the `DateFormatter` is configured as:
    /// - **dateFormate:** "MMM d, h:mm a"
    /// - **locale:** .autoupdatingCurrent
    public lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.defaultDateFormat
        dateFormatter.locale = Constants.defaultLocale
        return dateFormatter
    }()

    /// Initializer.
    ///
    /// - Parameters:
    ///   - timeframes: The array of `VFGTimeframe`.
    public init(timeframes: [VFGTimeframe]) {
        self.timeframes = timeframes
    }

    /// Returns a `String` defined by the given timeframes or the given `dateFormatter`.
    /// If the given `Date` does not match any `VFGTimeframe`, it will return a `String` using the given `dateFormatter`.
    ///
    /// - Parameter date: The `Date` to compare against to the given array of timeframes.
    /// - Returns: The `label` set by the timeframe that matches the given `Date`, or a `String` formated by the given `dateFormatter`.
    public func string(forDate date: Date) -> String {
        for timeframe in timeframes where date.isBetween(timeframe.from, and: timeframe.to) {
            return timeframe.label
        }

        return dateFormatter.string(from: date)
    }

}
