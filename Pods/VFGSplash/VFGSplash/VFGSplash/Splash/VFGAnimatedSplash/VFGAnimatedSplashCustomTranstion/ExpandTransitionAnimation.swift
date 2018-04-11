//
//  VFGAnimatedSplash.swift
//  VFGAnimatedSplash
//
//  Created by ahmed elshobary on 8/21/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUI
class ExpandTransitionAnimation: NSObject , UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    var endFrame : CGRect?
    var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return RedCircleAnimationConstants.redCircleExpandTime
    }
    /**
     With masking transition
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        if let fromViewController = VFGAnimatedSplash.sharedInstance.splashInstance as? VFGAnimatedSplashViewController {
            let destinationController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            let destinationView = destinationController.view
            
            let containerView = transitionContext.containerView
            
            let buttonFrame = fromViewController.circleMask.frame
            if UIScreen.isIpad{
                endFrame = CGRect(x: -1 * (RedCircleAnimationConstants.redCircleExpandSizeforIpad-(destinationView?.frame.width)!)/2, y: -1 * (RedCircleAnimationConstants.redCircleExpandSizeforIpad-(destinationView?.frame.height)!)/2, width: RedCircleAnimationConstants.redCircleExpandSizeforIpad, height: RedCircleAnimationConstants.redCircleExpandSizeforIpad)
            }
            else{
                endFrame = CGRect(x: -1 * (RedCircleAnimationConstants.redCircleExpandSizeforIphone-(destinationView?.frame.width)!)/2, y: -1 * (RedCircleAnimationConstants.redCircleExpandSizeforIphone-(destinationView?.frame.height)!)/2, width: RedCircleAnimationConstants.redCircleExpandSizeforIphone, height: RedCircleAnimationConstants.redCircleExpandSizeforIphone)
            }
            
            fromViewController.removeFromParentViewController()
            containerView.addSubview(fromViewController.view)
            containerView.addSubview(destinationView!)
            
            let maskPath = UIBezierPath(ovalIn: buttonFrame)
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = (destinationView?.frame)!
            maskLayer.path = maskPath.cgPath
            destinationController.view.layer.mask = maskLayer
            
            let bigCirclePath = UIBezierPath(ovalIn: endFrame!)
            
            let pathAnimation = CABasicAnimation(keyPath: BasicAnimationsKeys.pathKey)
            pathAnimation.delegate = self as? CAAnimationDelegate
            pathAnimation.fromValue = maskPath.cgPath
            pathAnimation.timingFunction = CAMediaTimingFunction.easeInOutQuint
            pathAnimation.toValue = bigCirclePath
            
            pathAnimation.duration = transitionDuration(using: transitionContext)
            maskLayer.path = bigCirclePath.cgPath
            maskLayer.add(pathAnimation, forKey: BasicAnimationsKeys.pathAnimationKey)
        }
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = self.transitionContext {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}
