//
//  CGFloat+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 01/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

extension CGFloat {

    static let floatDiffEpsilon : CGFloat = 0.00001

    public func equalsWithEpsilon(other: CGFloat) -> Bool {
        return fabs(self - other) < CGFloat.floatDiffEpsilon
    }
}
