//
//  UILayoutPriority+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by Ehab on 12/18/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public extension UILayoutPriority{
    #if swift(>=4.1)
    public static let high: UILayoutPriority = UILayoutPriority(rawValue: 999)
    public static let low: UILayoutPriority = UILayoutPriority(rawValue: 250)
    #else
    public static let high: UILayoutPriority = 999
    public static let low: UILayoutPriority = 250
    #endif
}
