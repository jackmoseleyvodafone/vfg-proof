//
//  CALayer+Animations.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/19/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

extension CALayer {
    
    // MARK:
    // MARK: Layer animation helpers
    
    /**
     Pauses all animations for the layer, including animations on sublayers.
     */
    func pauseAllAnimations() {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime
    }
    
    /**
     Resumes all animations for the layer, including animations on sublayers.
     */
    func resumeAllAnimations() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
    
}
