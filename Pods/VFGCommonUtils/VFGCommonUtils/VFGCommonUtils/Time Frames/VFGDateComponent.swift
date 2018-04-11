//
//  VFGDateComponent.swift
//  VFGCommonUtils
//
//  Created by Emilio Alberto Ojeda Mendoza on 2/6/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation

public enum VFGDateComponent {
    case seconds(Int)
    case minutes(Int)
    case hours(Int)
    case days(Int)
    case weeks(Int)
    case months(Int)
    case years(Int)

    public var rawValue: (component: Calendar.Component, value: Int) {
        switch self {
        case .seconds(let value):
            return (component: .second, value: value)
        case .minutes(let value):
            return (component: .minute, value: value)
        case .hours(let value):
            return (component: .hour, value: value)
        case .days(let value):
            return (component: .day, value: value)
        case .weeks(let value):
            return (component: .day, value: value * 7)
        case .months(let value):
            return (component: .month, value: value)
        case .years(let value):
            return (component: .year, value: value)
        }
    }
}

// MARK: - Equatable

extension VFGDateComponent: Equatable {
    public static func ==(leftComponent: VFGDateComponent, rightComponent: VFGDateComponent) -> Bool {
        return leftComponent.rawValue.component == rightComponent.rawValue.component
            && leftComponent.rawValue.value == rightComponent.rawValue.value
    }
}
