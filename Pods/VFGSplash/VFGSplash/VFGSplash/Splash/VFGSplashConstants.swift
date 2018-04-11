//
//  VFGSplashConstants.swift
//  VFGSplash
//
//  Created by Ahmed Naguib on 4/1/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

// MARK: SplashViewController Constants

let appDisplayNameKey: String = "CFBundleDisplayName"
let appNameKey: String = "CFBundleName"
let defaultBackgroundImageName: String = "bg_splash"
let eveningBackgroundImageName: String = "evening-background"
let logoImageName: String = "logo"

let animationKey: String = "animations"
let rotationAnimationKey: String = "transform.rotation.z"
let xTranslationKey: String = "transform.translation.x"
let yTranslationKey: String = "transform.translation.y"
let xScaleKey: String = "transform.scale.x"
let yScaleKey: String = "transform.scale.y"
let zScaleKey: String = "transform.scale.z"
let opacityKey: String = "opacity"
let rasterizationBlurKey: String = "rasterizationScale"

let backgroundZoomingBeginValue: Double = 1.35
let backgroundZoomingEndValue: Double = 1.0
let rasterizationBlurBeginValue: Double = 0.3
let rasterizationBlurEndValue: Double = 0.8
let fadeBeginValue: Double = 0.0
let fadeEndValue: Double = 1.0
let scaleFactor: Double = 0.6

let slowRotationAngle: CGFloat = CGFloat(M_PI / 60)
let redTriangleColor: UIColor = UIColor.VFGVodafoneRedRhombus

let leftTriangleStartDegrees: CGFloat = 135.0
let leftTriangleEndDegrees: CGFloat = 225.0
let rightTriangleStartDegrees: CGFloat = 315.0
let rightTriangleEndDegrees: CGFloat = 405.0

let titleFont: UIFont? = UIFont.vodafoneRegularFont(30)
let titleLabelFontMinimumScaleFactor: CGFloat = 0.3

let fastRotationLeftDirectionAngle: CGFloat = CGFloat(1.5 * M_PI)
let fastRotationRightDirectionAngle: CGFloat = CGFloat(M_PI / 2)

let triangleLogoRadiusPercentToViewWidth: CGFloat = 0.077
let yTranslationEndPointPercentToViewHeightIPad: CGFloat = 0.3
let yTranslationEndPointPercentToViewHeightIPhone: CGFloat = 0.3355
let xTranslationEndPointPercentToViewWidth: CGFloat = 0.19

let RTLNibName: String = "SplashRTL"
let LTRNibName: String = "SplashLTR"
let bundle: Bundle = VFGSplashBundle.bundle()!

let isRTLLanguage = Locale.characterDirection(forLanguage: Locale.preferredLanguages.first!) == NSLocale.LanguageDirection.rightToLeft

let easeInOutQuart: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
let easeOutExpo: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
let easeInQuart: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)

// MARK: TriangleView Constants

let splashTraingleRadius: CGFloat = 20.0
let splashTraingleStartDegrees: CGFloat = 90.0
let splashTraingleEndDegrees: CGFloat = 270.0
let PIRadiansInDegrees: CGFloat = 180.0

let leftDirectionTriangleMaxXPosition: CGFloat = 4000
let leftDirectionTriangleMinYPositionIPhone: CGFloat = -3500
let leftDirectionTriangleMinYPositionIPad: CGFloat = -3200
let leftDirectionTriangleMaxYPosition: CGFloat = 4200

let rightDirectionTriangleMaxXPosition: CGFloat = -3000
let rightDirectionTriangleMinYPosition: CGFloat = -2900
let rightDirectionTriangleMaxYPositionIPhone: CGFloat = 3500
let rightDirectionTriangleMaxYPositionIPad: CGFloat = 4000
