//
//  VFGCommonUIAnimations.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 01/02/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/** 
 Class contains helpers for animations of common ui components
 */
class VFGCommonUIAnimations: NSObject {

    //Formulas based on https://github.com/nicolausYes/easing-functions/blob/master/src/easing.cpp

    /**
     Animation timing based on http://easings.net/#easeInOutExpo used by RBBTweenAnimation
     */
    static let RBBEasingFunctionEaseInOutExpo: (@convention(block) (CGFloat) -> CGFloat) = { (input : CGFloat) -> CGFloat in
        if input < 0.5 {
            return (CGFloat) ((pow(2, 16 * input) - 1) / 510)
        } else {
            return (CGFloat) (1 - 0.5 * pow(2, -16 * (input - 0.5)))
        }
    }

    /**
     Animation timing based on http://easings.net/#easeInOutExpo used by RBBTweenAnimation
     */
    static let RBBEasingFunctionEaseOutExpo: (@convention(block) (CGFloat) -> CGFloat) = { (input : CGFloat) -> CGFloat in
         return (CGFloat) (1 - pow(2, -8 * input))
    }
}
