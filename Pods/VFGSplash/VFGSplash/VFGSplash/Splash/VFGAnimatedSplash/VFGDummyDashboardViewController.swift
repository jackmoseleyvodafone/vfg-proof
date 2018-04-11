//
//  VFGDummyDashboardViewController.swift
//  VFGSplash
//
//  Created by ahmed elshobary on 8/30/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
fileprivate let storyboardName: String = "VFGAnimatedSplash"
class VFGDummyDashboardViewController: UIViewController {
    /** status bar style for splash  */
    public var statusBarStyle: UIStatusBarStyle = .default
    
    
    /**
     Initialize an instance of Splash View Controller from storyboard
     - returns: returns VFGSplashViewController
     */
    open class func dummyDashBoardViewController() -> VFGDummyDashboardViewController {
        
        return UIStoryboard(name:storyboardName, bundle:VFGSplashBundle.bundle()).instantiateViewController(withIdentifier: String(describing: self)) as! VFGDummyDashboardViewController
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
}
