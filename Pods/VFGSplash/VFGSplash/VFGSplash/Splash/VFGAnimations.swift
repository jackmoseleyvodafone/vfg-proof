//
//  VFGAnimations.swift
//  VFGSplash
//
//  Created by Ahmed Naguib on 11/30/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

public extension CABasicAnimation {

    public convenience init(forwardAnimationWithKeyPath keyPath: String) {
        self.init(keyPath: keyPath)
        self.isRemovedOnCompletion = false
        self.fillMode = kCAFillModeForwards
    }
}

public extension CAAnimationGroup {

    public convenience init(forwardAnimationGroupWithDuration duration: Double, animations: [CAAnimation]) {
        self.init()
        self.fillMode = kCAFillModeForwards
        self.isRemovedOnCompletion = false
        self.duration = duration
        self.animations = animations
    }
}
