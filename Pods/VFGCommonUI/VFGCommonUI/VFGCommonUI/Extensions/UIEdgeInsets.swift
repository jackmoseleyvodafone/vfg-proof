//
//  UIEdgeInsets.swift
//  VFGCommonUI
//
//  Created by Emilio Alberto Ojeda Mendoza on 1/24/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit

/// It enables the `subtraction` operation between 2 `UIEdgeInsets`.
///
///
/// - Parameters:
///   - leftUIEdgeInsets: The value on the **left** side of the operator.
///   - rightUIEdgeInsets: The value on the **right** side of the operator.
/// - Returns: A new `UIEdgeInsets` value containing the result of the operation.
internal func -(leftUIEdgeInsets: UIEdgeInsets, rightUIEdgeInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(
        top: leftUIEdgeInsets.top - rightUIEdgeInsets.top,
        left: leftUIEdgeInsets.left - rightUIEdgeInsets.left,
        bottom: leftUIEdgeInsets.bottom - rightUIEdgeInsets.bottom,
        right: leftUIEdgeInsets.right - rightUIEdgeInsets.right
    )
}
