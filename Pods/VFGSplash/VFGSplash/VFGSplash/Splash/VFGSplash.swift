//
//  VFGSplash.swift
//  VFGSplash
//
//  Created by Ahmed Naguib on 11/14/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation
import UIKit
import VFGCommonUtils

/**
 SplashTriangleDirection enum for specifing starting position and rotation direction for Splash Triangle
 */
@objc public enum SplashTriangleDirection: Int {
    case SplashTriangleDirectionLeft
    case SplashTriangleDirectionRight
}

/**
 * VFGSplash is a wrapper for Splash View Controller that manages the initial introduction animation from the launch screen of the application. The order of the animations is as follows:
 * Fade in the BackgroundImageView and vodafoneTextLabel
 * Slow rotate the triangle
 * Fast rotate, translate, blur and scale the triangle + translate and scale the vodafoneLogoImageView + Zoom out backgroundImageView
 */
open class VFGSplash: NSObject {

    /** The Splash View Controller */
    private let splash: VFGSplashViewController = VFGSplashViewController.splashViewController()

    /** Day/Night Boolean for changing the background according to the current time */
    open var shouldShowNightBackground: Bool = false

    /** The animation duration factor that is multiplied in the whole animations durations */
    open var totalAnimationDurationFactor: Double = 1.0

    /** The duration of the background fading in the animation */
    open var backgroundFadeAnimationDuration: Double = 0.4

    /** The duration of the slow rotation in the animation */
    open var slowRotationAnimationDuration: Double = 3.0

    /** The duration of the fast rotation in the animation */
    open var fastRotationAnimationDuration: Double = 0.60

    /** The duration of the changing position for the logo and triangle over X-Axis */
    open var xTranslationAnimationDuration: Double = 0.67

    /** The duration of the changing position for the logo and triangle over Y-Axis */
    open var yTranslationAnimationDuration: Double = 0.67

    /** The duration of the scaling for the logo and triangle */
    open var scaleAnimationDuration: Double = 0.67

    /** The duration of the title fading in the animation */
    open var titleFadeAnimationDuration: Double = 0.87

    /** The duration of blurring the triangle in the animation */
    open var blurAnimationDuration: Double = 0.87

    /** The duration of background Zooming Out in the animation */
    open var zoomOutAnimationDuration: Double = 1.27

    /** The background color for Splash View */
    open var backgroundColor: UIColor!

    /** The title color */
    open var titleLabelColor: UIColor!

    /** The title font */
    open var titleLabelFont: UIFont!

    /** The title text */
    open var titleLabelText: String!

    /** The Attributed title text */
    open var titleLabelAttributedText: NSAttributedString!

    /** The background image on the Splash */
    open var backgroundImage: UIImage!

    /** The night background image on Splash (needs shouldShowNightBackground to be true) */
    open var nightBackgroundImage: UIImage!

    /** The logo Image on Splash */
    open var logoImage: UIImage!

    /** The fill color for the triangle */
    open var fillColor: UIColor!

    /** The rotation direction for the triangle */
    open var rotationDirection: SplashTriangleDirection!

    /** The starting position for the triangle */
    open var startingPosition: SplashTriangleDirection!

    /**
     * Add Splash View on a View Controller's View with submitting completion handler block that excutes when the animation finished
     
     - parameter ViewController: The view controller which the splash will be added to it's view
     - parameter completionHandler: A block which will be excuted once the animations finish
     */
    open func addSplashViewOnViewController(_ viewController: UIViewController, withCompletionHandler completionHandler: @escaping (_ finished: Bool) -> ()) {
        
        splash.completionHandler = completionHandler
        splash.shouldShowNightBackground = shouldShowNightBackground
        splash.totalAnimationDurationFactor = totalAnimationDurationFactor
        splash.backgroundFadeAnimationDuration = backgroundFadeAnimationDuration
        splash.slowRotationAnimationDuration = slowRotationAnimationDuration
        splash.fastRotationAnimationDuration = fastRotationAnimationDuration
        splash.xTranslationAnimationDuration = xTranslationAnimationDuration
        splash.yTranslationAnimationDuration = yTranslationAnimationDuration
        splash.scaleAnimationDuration = scaleAnimationDuration
        splash.titleFadeAnimationDuration = titleFadeAnimationDuration
        splash.blurAnimationDuration = blurAnimationDuration
        splash.zoomOutAnimationDuration = zoomOutAnimationDuration

        if backgroundColor != nil {
            splash.backgroundColor = backgroundColor
        }

        if self.titleLabelColor != nil {
            splash.titleLabelColor = titleLabelColor
        }

        if self.titleLabelFont != nil {
            splash.titleLabelFont = titleLabelFont
        }

        if self.titleLabelText != nil {
            splash.titleLabelText = titleLabelText
        }

        if titleLabelAttributedText != nil {
            splash.titleLabelAttributedText = titleLabelAttributedText
        }

        if backgroundImage != nil {
            splash.backgroundImage = backgroundImage
        }

        if nightBackgroundImage != nil {
            splash.nightBackgroundImage = nightBackgroundImage
        }

        if logoImage != nil {
            splash.logoImage = logoImage
        }

        if fillColor != nil {
            splash.fillColor = fillColor
        }

        if rotationDirection != nil {
            splash.rotationDirection = rotationDirection
        }

        if startingPosition != nil {
            splash.startingPosition = startingPosition
        }

        splash.view.frame = viewController.view.bounds
        
        VFGLogger.log("Adding splash to view controller: %@.",viewController);
        
        viewController.view.addSubview(splash.view)
    }

    /**
     Start Splash Animation
     */
    open func startSplashAnimation() {
        splash.startAnimation()
    }
    
    /**
     Stop Splash Animation
     */
    open func stopSplashAnimation() {
        splash.stopAnimation()
    }
    
    /**
     Remove Splash View
     */
    open func removeSplashView() {
        VFGLogger.log("Removing splash from superview.");
        splash.view.removeFromSuperview()
    }
    
    /**
     Show or hide Splash background
     @param show: a boolean for showing or hiding the background
     */
    open func toggleShowingBackground(show: Bool) {
        VFGLogger.log(show ? "Show splash background" : "Hide splash background")
        splash.toggleShowingBackground(show: show)
    }
    
    /**
     Splash View Controller's View
     - returns: The Splash View
     */
    open func splashView() -> UIView {
        return splash.view
    }

}
