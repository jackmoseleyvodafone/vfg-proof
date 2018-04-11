//
//  VFGAnimatedSplash.swift
//  VFGAnimatedSplash
//
//  Created by ahmed elshobary on 8/20/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import UIKit

struct JsonNames {
    static let logoLoadingLoopJson:  String = "Loading_loop_white"
    static let logoCircleLockupJson: String = "Circle_loop_white"
    static let jsonFormate:          String = ".json"
    
}

struct LogoLoopLottieAnimationConstants {
    static let frameDuration:           Double = 2.0
    static let removeLogoLoopDelay:     Double = 0.33
    static let logoLoopFadeOutDuration: Double = 0.33
    static let logoLoopDeafultTimeOut:  Double = 2.0
    
}

struct LogoAnimationConstants{
    static let logoScaleTime:                  Double = 1.20
    static let logoScaleDelay:                 Double = 0.83
    static let logoScaleFactor:                Double = 0.14
    static let xPositionFactor:                CGFloat = 0.4
    static let yPositionFactor:                CGFloat = 0.42
    static let changePositionDuration:         Double = 1.0
    static let changePositionDelay:            Double = 1.13
    static let logoWidthAfterScale:            CGFloat = 40.0
    static let logoHeightAfterScale:           CGFloat = 40.0
    static let logoRatioSizeAfterScale:        Double = 43/350
    
}

struct RedCircleAnimationConstants {
    static let redCircleExpandTime:                  Double = 1.0
    static let redCircleExpandDelay:                 Double = 1.0
    static let redCircleExpandScaleFactor:           Double = 3.0
    static let redCircleExpandSizeforIphone:         CGFloat = 1050.0
    static let redCircleExpandSizeforIpad:           CGFloat = 2000.0
    
}

struct DashBoardAnimationConstants {
    static let dashboardZoomAnimationDuration:         Double = 1.67
    static let dashboardZoomAnimationDelay:            Double = 1.17
    static let dashboardZommAnimationBeginValueFactor: Double = 1.5
    static let dashboardZommAnimationEndValueFactor:   Double = 1.0
}

struct BasicAnimationsKeys {
    static let xScaleKey: String = "transform.scale.x"
    static let yScaleKey: String = "transform.scale.y"
    static let zScaleKey: String = "transform.scale.z"
    static let animationKey: String = "animations"
    static let xTranslationKey: String = "transform.translation.x"
    static let yTranslationKey: String = "transform.translation.y"
    static let pathKey: String = "path"
    static let pathAnimationKey: String = "pathAnimation"
    static let opacityKey: String = "opacity"
}

