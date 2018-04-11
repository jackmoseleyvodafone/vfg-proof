//
//  VFGNavigationController.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 4/28/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/*
 Vodafone navigation controller that uses generic custom animation transition and background logic across all Vodafone apps
 */
open class VFGNavigationController: UINavigationController {
    
    private static let splashNightModeKey: String = "SplashNightMode"
    private static let morningLevelOneImageName: String = "morning_bg"
    private static let morningLevelTwoImageName: String = "morning_sl"
    private static let eveningLevelOneImageName: String = "evening_bg"
    private static let eveningLevelTwoImageName: String = "evening_sl"
    
    private var fadingOutBackgroundImageView = UIImageView()
    private var fadingInBackgroundImageView = UIImageView()
    
    /**
     a boolean for enable night mode for the navigation controller
     */
    open var nightMode : Bool = UserDefaults.standard.bool(forKey: splashNightModeKey)
    
    /**
     a boolean for enable background animation in transation
     */
    open var backGroundAnimation : Bool = true
    /**
     Custom background image for the navigation controller
     */
    open var backgroundImage: UIImage? {
        didSet {
            displayedBackgroundImage = backgroundImage
        }
    }
    
    /**
     Default morning image for first level view controller
     */
    open var morningLevelOneImage: UIImage? = {
        return UIImage(named: morningLevelOneImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    }()
    
    /**
     Default morning image for second level view controllers
     */
    open var morningLevelTwoImage: UIImage? = {
        return UIImage(named: morningLevelTwoImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    }()
    
    /**
     Default evening image for first level view controller
     */
    open var eveningLevelOneImage: UIImage? = {
        return UIImage(named: eveningLevelOneImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    }()
    
    /**
     Default evening image for second level view controllers
     */
    open var eveningLevelTwoImage: UIImage? = {
        return UIImage(named: eveningLevelTwoImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    }()
    
    fileprivate var displayedBackgroundImage: UIImage? {
        willSet (newValue) {
            if self.displayedBackgroundImage != newValue {
                if (self.displayedBackgroundImage != nil) {
                    
                    VFGLogger.log("Replacing previous displayBackgroundImage property")
                    
                    self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    self.fadingOutBackgroundImageView.alpha = 1
                    
                    self.fadingInBackgroundImageView.image = newValue
                    self.fadingInBackgroundImageView.alpha = 0
                    if backGroundAnimation{
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut], animations: {
                        self.fadingInBackgroundImageView.alpha = 1
                    }, completion: { (finished) in
                        self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    })
                    }
                    else{
                      self.fadingInBackgroundImageView.alpha = 1
                         self.fadingOutBackgroundImageView.image = self.fadingInBackgroundImageView.image
                    }
                }  else {
                    
                    VFGLogger.log("Configuring new displayBackgroundImage property")
                    
                    self.fadingOutBackgroundImageView.image = newValue
                    self.fadingInBackgroundImageView.image = newValue
                }
            }
        }
    }
    
    
    // MARK: Setup
    
    private func setupBackground() -> Void {
        
        VFGLogger.log("Setting up VFGNavigationController background")
        
        self.fadingInBackgroundImageView.frame = view.bounds
        self.fadingInBackgroundImageView.alpha = 0
        
        self.fadingOutBackgroundImageView.frame = view.bounds
        self.fadingOutBackgroundImageView.alpha = 1
        
        view.addSubview(self.fadingInBackgroundImageView)
        view.sendSubview(toBack: self.fadingInBackgroundImageView)
        
        view.addSubview(self.fadingOutBackgroundImageView)
        view.sendSubview(toBack: self.fadingOutBackgroundImageView)
        
        self.updateBackgroundFor(viewControllers: self.viewControllers)
    }
    
    
    // MARK: - UIViewController
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.setupBackground()
    }
    
    
    // MARK: - UINavigationController
    
    override open func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        self.updateBackgroundFor(viewControllers: viewControllers)
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    
    // MARK: - Background Logic
    
    fileprivate func updateBackgroundFor(viewControllers: [UIViewController]) {
        
        if self.backgroundImage == nil {
            
            VFGLogger.log("BackgroundImage is nil")
            
            //Transitioning to level 1
            if viewControllers.count < 2 {
                
                VFGLogger.log("Setting level 1 default background image")
                
                self.displayedBackgroundImage = self.levelOneDefaultBackgroundImage()
            }
                //Transitioning to level 2+
            else {
                
                VFGLogger.log("Setting level 2 default background image")
                
                self.displayedBackgroundImage = self.levelTwoDefaultBackgroundImage()
            }
        } else {
            //Use overriding VC background image
            self.displayedBackgroundImage = self.backgroundImage
        }
    }
    
    private func levelOneDefaultBackgroundImage() -> UIImage? {
        self.updateNightMode()
        return self.nightMode ? self.eveningLevelOneImage : self.morningLevelOneImage
    }
    
    private func levelTwoDefaultBackgroundImage() -> UIImage? {
        self.updateNightMode()
        return self.nightMode ? self.eveningLevelTwoImage : self.morningLevelTwoImage
    }
    
    private func updateNightMode() {
        self.nightMode = UserDefaults.standard.bool(forKey: VFGNavigationController.splashNightModeKey)
    }
}


// MARK: - UINavigationControllerDelegate

extension VFGNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.updateBackgroundFor(viewControllers: self.viewControllers)
        
        let animation = VFGNavigationControllerTransitionAnimation()
        animation.isPush = (operation == .push)
        return animation
    }
}
