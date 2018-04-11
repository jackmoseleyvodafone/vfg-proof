//
//  VFGAnimatedSplash.swift
//  VFGAnimatedSplash
//
//  Created by ahmed elshobary on 8/20/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 SplashLogoPosition enum for specifing starting position and end position for Splash Logo in Dashboard
 */
@objc public enum SplashlogoPosition: Int {
    case left
    case right
}

/**
 * VFGSplash is a wrapper for Splash View Controller that manages the initial introduction animation from the launch screen of the application. The order of the animations is as follows:
 * Logo loading indicator
 * logo Circle Lockup
 * Expand Red Circle , Scale and translate the Vodafone logo
 */
open  class VFGAnimatedSplash: NSObject {
    
    /** Shared Instance of VFGAnimatedSplash */
    
    public static let sharedInstance: VFGAnimatedSplash = VFGAnimatedSplash()
    
    /**  Instance of Splash */
    
    open var splashInstance: UIViewController?
    
    
    /** The Splash View Controller */
    
    private let splash: VFGAnimatedSplashViewController = VFGAnimatedSplashViewController.animatedSplashViewController()
    
    
    /** The Dummy DashBoard View Controller */
    
    private let dummyView: VFGDummyDashboardViewController = VFGDummyDashboardViewController.dummyDashBoardViewController()
    

    /**
     Start Splash Animation
     */
    
    open func startSplashAnimation() {
        VFGAnalyticsHandler.trackSplashAppLaunch()
        splash.startAnimation()
    }
    
    /**
     - Parameter completionHandler: Complition Handler for the animation
     */
    
    open func setComplitionHandler(completionHandler: @escaping (_ finished: Bool) -> ()) {
        splash.completionHandler = completionHandler
    }
    
    /**
     Remove Splash View
     */
    
    open func removeSplashView(completionHandler: ((_ finished: Bool) -> ())? ) {
        splash.dismissAllPresentedView(completionHandler: completionHandler)
    }

    
    
    /**
     Splash View Controller's View
     - returns: The Splash View
     */
    
    open func splashView() -> UIView {
        return splash.view
    }
    
    /**
     Complete Animation when DashBoard Loaded
     */
    open func endSplashAnimation() {
        return splash.completeAnimation()
    }
    
    /**
     - Parameter timeOut: Timeout for the logoLoading indicator.
     */
    open func runSplashAnimationFor(timeOut : Int) {
        VFGAnalyticsHandler.trackSplashAppLaunch()
        if timeOut > Int(LogoLoopLottieAnimationConstants.logoLoopDeafultTimeOut){
            splash.logoLoadingTimeOut = Double(timeOut)
            splash.startAnimationWithTimeOut()
        } else {
            splash.startAnimationWithTimeOut()
        }
    }
    /**
     - Parameter positionX: x position for Vodafone logo in the dashboard
     - Parameter positionY: Y position for Vodafone logo in the dashboard
     */
    open func setFinalLogoPosition(positionX : CGFloat , positionY : CGFloat) {
        splash.xPositionForLogo = positionX
        splash.yPositionForLogo = positionY
        
    }
    
    /**
     - Parameter visibility: for show or hide Vodafonelogo
     */
    open func isLogoVisible(visibility:Bool){
        splash.showOrHideVodafoneLogo(visibility: !visibility)
        
    }
    
    /**
     - Parameter imageView: for show the background image
     */
    open func DashBoardBackgroundImage(imageView:UIImageView){
        if imageView.image != nil{
            splash.backGroundImage = imageView
        }
        
    }
    
    /**
     Splash View Controller
     - returns: The Splash View Controller
     */
    
    open func returnViewController()-> UIViewController{
        return splash
    }
    
    /**
     
     - Paramter StatusBarStyle: for status bar style in splash
     */
    
    open func setStatusBarStyle(statusBarStyle:UIStatusBarStyle){
        splash.statusBarStyle = statusBarStyle
        dummyView.statusBarStyle = statusBarStyle
    }
    
    /**
     - Paramter customWindow: for adding logo in Window
     */
    
    open func setWindow(customWindow:UIWindow){
        splash.customWindow = customWindow
    }
    
    /**
     - add Vodafone Logo In your View
     **/
    
    open func addLogoImageToTopViewController(){
        splash.addLogoImageToTopViewController()
    }
    
}
