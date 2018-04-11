//
//  VFGNavigationControllerTransitionAnimation.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 4/28/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

open class VFGNavigationControllerTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var isPush = false
    open var transitionDuration = 0.66
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let containerView = transitionContext.containerView
        
        let containerViewFrame = containerView.frame

        var offScreenRightFrame = containerViewFrame
        offScreenRightFrame.origin.x = -containerView.frame.width * (isPush ? -1 : 1)
        toViewController?.view.frame = offScreenRightFrame

        guard var offScreenLeftFrame : CGRect = fromViewController?.view?.frame else{
            VFGLogger.log("animateTransition() cannot unwrap fromViewController?.view?.frame")
            return
        }
        offScreenLeftFrame.origin.x = -containerView.frame.width * (isPush ? 1 : -1)
        
        if let toViewControllerView = toViewController?.view {
            containerView.addSubview(toViewControllerView)
        }
        else {
            VFGLogger.log("animateTransition toViewController?.view optional is empty")
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       usingSpringWithDamping: 1.5,
                       initialSpringVelocity: 1.8,
                       options: UIViewAnimationOptions(rawValue: 0),
                       animations: {

                        toViewController?.view.frame = containerViewFrame
                        fromViewController?.view.frame = offScreenLeftFrame

        }, completion: { (finished) in
            transitionContext.completeTransition(true)
        })
    }
}
