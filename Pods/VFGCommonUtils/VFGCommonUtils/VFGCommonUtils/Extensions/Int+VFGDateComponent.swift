//
//  Int+VFGDateComponent.swift
//  VFGCommonUtils
//
//  Created by Emilio Alberto Ojeda Mendoza on 2/6/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

// MARK: - VFGDateComponent

public extension Int {
    public var seconds: VFGDateComponent {
        return .seconds(self)
    }

    public var minutes: VFGDateComponent {
        return .minutes(self)
    }

    public var hours: VFGDateComponent {
        return .hours(self)
    }

    public var days: VFGDateComponent {
        return .days(self)
    }

    public var weeks: VFGDateComponent {
        return .weeks(self)
    }

    public var months: VFGDateComponent {
        return .months(self)
    }

    public var years: VFGDateComponent {
        return .years(self)
    }
}
