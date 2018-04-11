//
//  BubbleTransition.swift
//  BubbleTransition
//
//  Created by Ahmed  Elshobary on 13/05/17.
//  Copyright (c) 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 - fixing issue statusBar height increases in case of InCall or Hotspot
 - returning statusBar height only without extra height added when InCall or Hotspot by subtracting window rootViewController y offset
 which is Zero when statusBar is at it's normal state
 - Important: Used instead of UIApplication.shared.statusBarFrame.size.height
 */
var statusBarHeight: CGFloat {
    guard let rootWindow = UIApplication.shared.keyWindow else {
        return UIApplication.shared.statusBarFrame.size.height
    }
    guard let rootViewController = rootWindow.rootViewController else {
        return UIApplication.shared.statusBarFrame.size.height
    }
    return UIApplication.shared.statusBarFrame.size.height - ( rootViewController.view.frame.origin.y )
}

/**
 A custom modal transition that presents and dismiss a controller with an expanding bubble effect.
 
 - Prepare the transition:
 ```swift
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 let controller = segue.destination
 controller.transitioningDelegate = self
 controller.modalPresentationStyle = .custom
 }
 ```
 - Implement UIViewControllerTransitioningDelegate:
 ```swift
 func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
 transition.transitionMode = .present
 transition.startingPoint = someButton.center
 transition.bubbleColor = someButton.backgroundColor!
 return transition
 }
 
 func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
 transition.transitionMode = .dismiss
 transition.startingPoint = someButton.center
 transition.bubbleColor = someButton.backgroundColor!
 return transition
 }
 ```
 */
open class BubbleTransition: NSObject {
    
    /**
     The point that originates the bubble. The bubble starts from this point
     and shrinks to it on dismiss
     */
    open var startingPoint = CGPoint.zero {
        didSet {
            bubble.center = startingPoint
        }
    }
    
    /**
     The transition duration. The same value is used in both the Present or Dismiss actions
     Defaults to `0.5`
     */
    open var duration = 0.67
    open var opacityDuration = 0.07
    open var chabgeColorDuration = 1.17
    open var bubbleGrayColor = UIColor(red: 227.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)
    /**
     The transition direction. Possible values `.present`, `.dismiss` or `.pop`
     Defaults to `.Present`
     */
    open var transitionMode: BubbleTransitionMode = .present
    
    /**
     The color of the bubble. Make sure that it matches the destination controller's background color.
     */
    open var bubbleColor: UIColor = .white
    
    open fileprivate(set) var bubble = UIView()
    open var clipedView  = UIView()
    open var shadowView  = UIView()
    /**
     The possible directions of the transition.
     
     - Present: For presenting a new modal controller
     - Dismiss: For dismissing the current controller
     - Pop: For a pop animation in a navigation controller
     */
    @objc public enum BubbleTransitionMode: Int {
        case present, dismiss, pop
    }
}

extension BubbleTransition: UIViewControllerAnimatedTransitioning {
    
    // MARK:- Constants
    struct constants {
        static var clippedViewTopInset: CGFloat = 5
        static var clippedViewLeadingInset: CGFloat = 5
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     */
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    /**
     Required by UIViewControllerAnimatedTransitioning
     
     */
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        shadowView = UIView()
        if #available(iOS 9.0, *){
            
            VFGLogger.log("Configure BubbleTransition shadowView for iOS 9")
            
            shadowView.frame = CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height)
        } else {
            
            VFGLogger.log("Configure BubbleTransition shadowView for iOS 8")
            
            shadowView.frame = CGRect(x: 0, y: 20, width: containerView.frame.size.width, height: containerView.frame.size.height)
        }
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0)
        clipedView = UIView()
        clipedView.frame = CGRect(x: constants.clippedViewLeadingInset, y: statusBarHeight + constants.clippedViewTopInset, width: containerView.frame.size.width - (2 * constants.clippedViewLeadingInset), height: containerView.frame.size.height - (statusBarHeight + (2 * constants.clippedViewTopInset)))
        // clipedView.alpha = 1
        clipedView.layer.cornerRadius = 7
        clipedView.backgroundColor = UIColor.clear
        containerView.addSubview(shadowView)
        containerView.addSubview(clipedView)
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        fromViewController?.view.transform = .identity
        toViewController?.view.transform = .identity
        fromViewController?.view.alpha = 1
        toViewController?.view.alpha = 1
        
        toViewController?.view.frame = clipedView.bounds
        
        VFGLogger.log("Transition mode is " + String(transitionMode.rawValue))
        
        if transitionMode == .present {
            guard let presentedControllerView : UIView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                VFGLogger.log("Cannot unwrap data for presentedControllerView. Exiting from animateTransition()")
                return
            }
            let originalCenter = presentedControllerView.center
            let originalSizeHieght = presentedControllerView.frame.size.height
            let originalSizeWidth  = presentedControllerView.frame.size.width
            let originalSize       = CGSize(width: originalSizeWidth, height: originalSizeHieght)
            
            
            
            bubble = UIView()
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            bubble.center = startingPoint
            bubble.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            //   self.bubble.layer.opacity = 0
            clipedView.addSubview(bubble)
            clipedView.addSubview(presentedControllerView)
            clipedView.clipsToBounds = true
            
            
            
            presentedControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            presentedControllerView.backgroundColor = UIColor.clear
            presentedControllerView.center = startingPoint
            
            
            clipedView.addSubview(presentedControllerView)
            clipedView.addSubview(presentedControllerView)
            //clipedView.clipsToBounds = true
            
            UIView.animate(withDuration: duration, animations: {
                self.bubble.transform = CGAffineTransform.identity
                presentedControllerView.transform = CGAffineTransform.identity
                self.shadowView.backgroundColor = self.shadowView.backgroundColor?.withAlphaComponent(0.5)
                
                self.bubble.backgroundColor = self.bubbleColor.withAlphaComponent(1)
                presentedControllerView.center = originalCenter
            }, completion: { (_) in
                transitionContext.completeTransition(true)
                
                //      self.perform(#selector(self.hideBubble), with: self, afterDelay: 0.5)
            })
        } else {
            toViewController?.view.frame = containerView.frame
            let key = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            guard let returningControllerView : UIView = transitionContext.view(forKey: key) else {
                VFGLogger.log("Cannot unwrap data for returningControllerView. Exiting from animateTransition()")
                return
            }
            let originalCenter = returningControllerView.center
            let originalSize = returningControllerView.frame.size
            
            bubble.frame = frameForBubble(originalCenter, size: originalSize, start: startingPoint)
            bubble.layer.cornerRadius = bubble.frame.size.height / 2
            bubble.center = startingPoint
            UIView.animate(withDuration : duration , animations:{
                UIView.setAnimationDelay(0.1)
                
                containerView.subviews.first?.alpha = 0.0
                
            })
            
            
            UIView.animate(withDuration: duration, animations: {
                UIView.setAnimationDelay(0.15)
                containerView.subviews.first?.alpha = 0.0
                
                self.bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.frame = self.clipedView.frame
                returningControllerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                returningControllerView.center = self.startingPoint
                returningControllerView.alpha = 0
                
                if self.transitionMode == .pop {
                    containerView.insertSubview(returningControllerView, belowSubview: returningControllerView)
                    containerView.insertSubview(self.bubble, belowSubview: returningControllerView)
                }
            }, completion: { (_) in
                returningControllerView.center = originalCenter
                returningControllerView.removeFromSuperview()
                self.bubble.removeFromSuperview()
                self.clipedView.alpha = 0
                transitionContext.completeTransition(true)
                
                
            })
        }
    }
}


private extension BubbleTransition {
    func frameForBubble(_ originalCenter: CGPoint, size originalSize: CGSize, start: CGPoint) -> CGRect {
        let lengthX = fmax(start.x, originalSize.width + originalSize.width/2 - start.x)
        let lengthY = fmax(start.y, originalSize.height + originalSize.height/2 - start.y)
        let offset = sqrt(lengthX * lengthX + lengthY * lengthY) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
