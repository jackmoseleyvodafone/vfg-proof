//
//  SpinnerView.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/19/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

class SpinnerView: UIView, CAAnimationDelegate{
    
    var lineWidth: CGFloat = 4.0 {
        didSet {
            animatingCircle.lineWidth = lineWidth
            containAnimatingCircle()
        }
    }
    
    // MARK: UIView
    
    override init(frame: CGRect) {
        func setupAnimatingCircle(_ frame: CGRect) {
            animatingCircle.frame = bounds
            
            // Account for animating circle line width
            containAnimatingCircle()
            setAnimatingCirclePathAndAnimations()
        }
        
        super.init(frame: frame)
        layer.addSublayer(animatingCircle)
        setupAnimatingCircle(frame)
        stopAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("SpinnerView does not support being loaded from nibs or storyboards")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animatingCircle.frame = bounds
        containAnimatingCircle()
        setAnimatingCirclePathAndAnimations()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        animatingCircle.strokeColor = tintColor.cgColor
    }
    
    // MARK: Public functions
    
    func startAnimating() {
        stopAnimating()
        animatingCircle.resumeAllAnimations()
    }
    
    func stopAnimating() {
        animatingCircle.removeAllAnimations()
        animatingCircle.add(animations, forKey: "animations")
        animatingCircle.pauseAllAnimations()
    }
    
    // MARK: Private functions
    
    fileprivate func containAnimatingCircle() {
        var circleBounds = bounds
        circleBounds.origin.x += animatingCircle.lineWidth
        circleBounds.origin.y += animatingCircle.lineWidth
        circleBounds.size.width -= animatingCircle.lineWidth
        circleBounds.size.height -= animatingCircle.lineWidth
        animatingCircle.bounds = circleBounds
    }
    
    fileprivate func setAnimatingCirclePathAndAnimations() {
        let centerPoint = CGPoint (x: animatingCircle.bounds.width / 2, y: animatingCircle.bounds.width / 2);
        let circleRadius : CGFloat = animatingCircle.bounds.width / 2 * 0.83;
        
        let newPath =  UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true  );
        
        animatingCircle.path = newPath.cgPath
        animatingCircle.add(animations, forKey: "animations")
    }
    
    // MARK: Lazy properties
    
    fileprivate lazy var strokeEndAnimation: CABasicAnimation = {
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.isRemovedOnCompletion = false
        strokeEndAnimation.fillMode = kCAFillModeForwards
        strokeEndAnimation.duration = 0.9
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return strokeEndAnimation
    }()
    
    fileprivate lazy var strokeBeginAnimation: CABasicAnimation = {
        let strokeBeginAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeBeginAnimation.isRemovedOnCompletion = false
        strokeBeginAnimation.fillMode = kCAFillModeForwards
        strokeBeginAnimation.duration = 0.9
        strokeBeginAnimation.fromValue = 0
        strokeBeginAnimation.toValue = 1
        strokeBeginAnimation.beginTime = 0.9
        strokeBeginAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        return strokeBeginAnimation
    }()
    
    fileprivate lazy var strokeWrapAroundAnimations: CAAnimationGroup = {
        let strokeWrapAroundAnimations = CAAnimationGroup()
        
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.isRemovedOnCompletion = false
        endAnimation.fillMode = kCAFillModeForwards
        endAnimation.duration = 0.85
        endAnimation.fromValue = 1
        endAnimation.toValue = 0.0
        endAnimation.beginTime = 1.95
        endAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.isRemovedOnCompletion = false
        startAnimation.fillMode = kCAFillModeForwards
        startAnimation.duration = 0.8
        startAnimation.fromValue = 1
        startAnimation.toValue = 0.0
        startAnimation.beginTime = 1.9
        startAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        strokeWrapAroundAnimations.animations = [startAnimation, endAnimation]
        
        return strokeWrapAroundAnimations
    }()
    
    fileprivate lazy var animations: CAAnimationGroup = {
        let animations = CAAnimationGroup()
        animations.fillMode = kCAFillModeForwards
        animations.isRemovedOnCompletion = false
        animations.repeatCount = Float.infinity
        animations.duration = 2.75
        animations.animations = [self.strokeEndAnimation, self.strokeBeginAnimation, self.strokeWrapAroundAnimations]
        animations.delegate = self
        return animations
    }()
    
    fileprivate lazy var animatingCircle: CAShapeLayer = {
        let outlineCircle = CAShapeLayer()
        outlineCircle.strokeColor = self.tintColor.cgColor
        outlineCircle.lineWidth = 4.0
        outlineCircle.lineCap = kCALineCapRound
        outlineCircle.fillColor = UIColor.clear.cgColor
        return outlineCircle
    }()
    
}
