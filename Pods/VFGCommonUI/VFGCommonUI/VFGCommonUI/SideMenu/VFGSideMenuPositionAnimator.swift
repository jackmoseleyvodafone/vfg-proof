//
//  VFGSideMenuAnimationDelegate.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 12/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import RBBAnimation

class VFGSideMenuPositionAnimator: NSObject, VFGSideMenuPositionAbstractAnimator {

    static let duration : TimeInterval = 0.6
    static let animationKeyPath : String = "position"

    weak var sideMenu : UIView!
    var completion : ((_ : Bool) -> Void)?

    func animatePositionChange(fromPosition: CGPoint, toPosition: CGPoint) {
        self.sideMenu.layer.add(self.positionChangeAnimation(fromPosition: fromPosition, toPosition: toPosition), forKey: VFGSideMenuPositionAnimator.animationKeyPath)
    }

    private func positionChangeAnimation(fromPosition: CGPoint, toPosition: CGPoint) -> RBBTweenAnimation {
        let animation : RBBTweenAnimation = RBBTweenAnimation(keyPath: VFGSideMenuPositionAnimator.animationKeyPath)
        animation.fromValue = self.value(fromPoint: fromPosition)
        animation.toValue = self.value(fromPoint: toPosition)
        animation.easing = VFGCommonUIAnimations.RBBEasingFunctionEaseInOutExpo
        animation.duration = VFGSideMenuPositionAnimator.duration

        return animation
    }

    private func value(fromPoint: CGPoint) -> NSValue {
        return NSValue(cgPoint: fromPoint)
    }
}
