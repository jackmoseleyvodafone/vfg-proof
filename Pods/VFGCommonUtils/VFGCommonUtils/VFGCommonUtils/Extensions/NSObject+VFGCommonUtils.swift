//
//  NSObject+VFGCommonUtils.swift
//  VFGCommonUtils
//
//  Created by Mohamed Magdy on 5/23/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

public extension NSObject {
    public var theClassName: String {
        return String(describing: type(of: self))
    }
}
