//
//  UIView+Animation.swift
//  VFGCommonUI
//
//  Created by Manar Magdy on 4/18/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//


import UIKit



public extension UIView {
    
    /**
     This method provides horizontal animation from the current point "predefined" to the target point.
     
     - parameter targetView: the view that will be moved with animation
     - parameter to: the view the destination point
     - parameter animationDuration: the animation duration
     
     */
    static func animateHorizontally(targetView: UIView, to destinationPoint: CGFloat, animationDuration: TimeInterval)  {
        
        UIView.animateKeyframes(withDuration: animationDuration,
                                delay: 0,
                                options: .calculationModeLinear,
                                animations: {
                                    var frame : CGRect = targetView.frame
                                    frame.origin.x = destinationPoint
                                    targetView.frame = frame
        },
                                completion: nil)
    }
    
    
    
    
    
    /**
     This method provides horizontal slide animation from the current view controller to another view controller.
     
     - parameter oldVC: the current view controller
     - parameter newVC: the view controller that we want to navigate to
     - parameter containerView: the parent view controller that will contain all this animation
     - parameter isForward: the slide animation direction "Forward/Backward"
     - parameter animationDuration: the animation duration
     
     */
    static func cycleFromViewController(oldVC: UIViewController, newVC: UIViewController, containerView: UIView, isForward: Bool, animationDuration: TimeInterval, completionHandler: (() -> Void)?)  {
        
        let offScreenRight = CGAffineTransform(translationX: -containerView.frame.width * (isForward ? -1 : 1), y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -containerView.frame.width * (isForward ? 1 : -1), y: 0)
        newVC.view.transform = offScreenRight
        
        //        containerView.frame = newVC.view.bounds
        containerView.addSubview(newVC.view)
        newVC.view.superview?.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 1.5,
                       initialSpringVelocity: 1.8,
                       options: UIViewAnimationOptions(rawValue: 0),
                       animations: {
                        
                        oldVC.view.transform = offScreenLeft
                        newVC.view.transform = CGAffineTransform.identity
                        
        }, completion: { (finished) in
            completionHandler?()
            oldVC.view.removeFromSuperview()
            newVC.view.superview?.isUserInteractionEnabled = true
        })
    }
    
    
    
    /**
     This method adds shadow effect to a specific view.
     
     - parameter view: the targeted view that we want to add shadow to
     - parameter shadowColor: the shadow color
     - parameter shadowOpacity: the shadow opacity
     - parameter shadowRadius: the shadow radius
     
     */
    static func addShadowEffect(view: UIView, shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
    }
    
    /**
     This method provides Scale Animation to a specific view.
     
     - targetView view: the targeted view that we want to add shadow to
     - parameter animationDuration: the animaiton Duration
     - parameter scaleFactor: the animaiton Scale Factor
     - parameter animationDelay: Delay of the animation
     
     */
    
    static func scaleAnimation (targetView:UIView , animationDuration : TimeInterval , scaleFactor : Double , animationDelay : Double ){
        
        UIView.animateKeyframes(withDuration: animationDuration,
                                delay: animationDelay,
                                options: .calculationModeLinear,
                                animations: {
                                    targetView.transform = CGAffineTransform(scaleX: CGFloat(scaleFactor), y: CGFloat(scaleFactor))
        },
                                completion: nil)
    }
    

    
    
    
    
    /**
     This method provides fading animation for a specific view
     
     - parameter animationDuration: the needed time to finish this animation
     - parameter opacity: the faded view opacity
     - parameter targetView: the view that we will apply the fading animation on
     
     */
    
    static func fadeView(animationDuration: TimeInterval, opacity: CGFloat, targetView: UIView) {
        
        UIView.animate(withDuration: animationDuration, animations: {
            targetView.alpha = opacity
        })
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
}
