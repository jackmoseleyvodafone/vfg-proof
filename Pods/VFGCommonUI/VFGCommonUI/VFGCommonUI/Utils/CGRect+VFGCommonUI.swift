//
//  CGRect+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 01/02/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

extension CGRect {
    var center : CGPoint {
        return CGPoint(x:self.midX, y:self.midY)
    }
}
