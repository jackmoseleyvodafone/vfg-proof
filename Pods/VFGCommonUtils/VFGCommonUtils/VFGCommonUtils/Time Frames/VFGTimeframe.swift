//
//  VFGTimeFrame.swift
//  VFGCommonUtils
//
//  Created by Emilio Alberto Ojeda Mendoza on 2/6/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

/// `Struct` used to model timeframes by defining a **starting date** and an **ending date**.
/// It also allows defining the **label** (`String`) to be set when matching a `Date`.
public class VFGTimeframe {
    /// The **starting date**.
    public let from: Date
    /// The **ending date**.
    public let to: Date
    /// The **label** to be set.
    public let label: String

    /// Initializer.
    ///
    /// - Parameters:
    ///   - startingDate: The **starting date** of the timeframe.
    ///   - endingDate: The **ending date** if the timeframe.
    ///   - label: The **string** to resolve when matching the timeframe.
    public init(from startingDate: Date, to endingDate: Date, label: String) {
        from = startingDate
        to = endingDate
        self.label = label
    }
}
