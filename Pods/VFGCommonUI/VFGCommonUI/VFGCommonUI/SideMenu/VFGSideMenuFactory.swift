//
//  VFGSideMenuFactory.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 12/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

class VFGSideMenuFactory: NSObject {

    func frameGenerator() -> VFGSideMenuFrameGenerator {
        return VFGSideMenuFrameGenerator()
    }

    func positionAnimator() -> VFGSideMenuPositionAbstractAnimator {
        return VFGSideMenuPositionAnimator()
    }

    func tableModel() -> VFGSideMenuTableModel {
        return VFGSideMenuTableModel()
    }

}
