//
//  VFGSplashViewController.swift
//  VFGSplash
//
//  Created by Ahmed Naguib on 11/14/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUI
import VFGCommonUtils

/**
 VFGSplashViewController manages the initial introduction animation from the launch screen of the application. The order of the
 animations is as follows:
 * Fade in the vodafoneLogoImageView, vodafoneTextLabel and splashTriangleView
 * Slow rotate the triangle
 * Fast rotate, translate and scale the triangle + translate and scale the vodafoneLogoImageView
 
 This is managed through the use of |CAAnimationGroup|'s that control all of the timings. All of the animations are lazily loaded. The triangle is
 drawn in a separate class.
 */
open class VFGSplashViewController: UIViewController, CAAnimationDelegate {

    // MARK: IBOutlets

    @IBOutlet fileprivate weak var animationContainerView: UIView!
    @IBOutlet fileprivate weak var backgroundImageView: UIImageView!
    @IBOutlet fileprivate weak var vodafoneLogoImageView: UIImageView!
    @IBOutlet fileprivate weak var vodafoneTextLabel: UILabel!
    @IBOutlet fileprivate weak var splashTriangleView: VFGSplashTriangleView!
    @IBOutlet fileprivate weak var maskTriangleView: VFGSplashTriangleView!

    // MARK: Properties
    
    /** Day/Night Boolean for changing the background according to the current time */
    @IBInspectable open var shouldShowNightBackground: Bool = false
    
    /** The begin Time of title fading in the animation */
    @IBInspectable open var titleFadeAnimationBeginTime: Double = 0.13
    
    /** The duration of the background fading in the animation */
    @IBInspectable open var backgroundFadeAnimationDuration: Double = 0.4
    
    /** The duration of the slow rotation in the animation */
    @IBInspectable open var slowRotationAnimationDuration: Double = 3.0
    
    /** The duration of the fast rotation in the animation */
    @IBInspectable open var fastRotationAnimationDuration: Double = 0.60
    
    /** The duration of the changing position for the logo and triangle over X-Axis */
    @IBInspectable open var xTranslationAnimationDuration: Double = 0.67
    
    /** The duration of the changing position for the logo and triangle over Y-Axis */
    @IBInspectable open var yTranslationAnimationDuration: Double = 0.67
    
    /** The duration of the scaling for the logo and triangle */
    @IBInspectable open var scaleAnimationDuration: Double = 0.67
    
    /** The duration of the title fading in the animation */
    @IBInspectable open var titleFadeAnimationDuration: Double = 0.87
    
    /** The duration of blurring the triangle in the animation */
    @IBInspectable open var blurAnimationDuration: Double = 0.87
    
    /** The duration of background Zooming Out in the animation */
    @IBInspectable open var zoomOutAnimationDuration: Double = 1.27
    
    /** The background color for Splash View */
    @IBInspectable open var backgroundColor: UIColor = UIColor.white
    
    /** The title text */
    @IBInspectable open var titleLabelText: String? = Bundle.main.object(forInfoDictionaryKey: appDisplayNameKey) as? String ?? Bundle.main.object(forInfoDictionaryKey: appNameKey) as? String
    
    /** The title color */
    @IBInspectable open var titleLabelColor: UIColor = UIColor.white
    
    /** The background image on the Splash */
    @IBInspectable open var backgroundImage: UIImage = UIImage(named: defaultBackgroundImageName, in: bundle, compatibleWith: nil)!
    
    /** The night background image on Splash (needs shouldShowNightBackground to be true) */
    @IBInspectable open var nightBackgroundImage: UIImage = UIImage(named: eveningBackgroundImageName, in: bundle, compatibleWith: nil)!
    
    /** The logo Image on Splash */
    @IBInspectable open var logoImage: UIImage = UIImage(named: logoImageName, in: bundle, compatibleWith: nil)!
    
    /** The fill color for the triangle */
    @IBInspectable open var fillColor: UIColor = redTriangleColor
    
    /** Completion handler for when the splash animation finishes */
    open var completionHandler: (_ finished: Bool) -> () = { finished in }
    
    /** The title font for title text */
    open var titleLabelFont: UIFont? = titleFont
    
    /** The Attributed title text */
    open var titleLabelAttributedText: NSAttributedString!
    
    /** The rotation direction for the triangle */
    open var rotationDirection: SplashTriangleDirection = .SplashTriangleDirectionLeft
    
    /** The starting position for the triangle */
    open var startingPosition: SplashTriangleDirection = {
        
        if isRTLLanguage {
            return .SplashTriangleDirectionRight
        }
        
        return .SplashTriangleDirectionLeft
    }()
    
    /** The animation duration factor that is multiplied in the whole animations durations */
    @IBInspectable open var totalAnimationDurationFactor = 1.0 {
        didSet {
            slowRotationAnimationDuration = slowRotationAnimationDuration * totalAnimationDurationFactor
            fastRotationAnimationDuration = fastRotationAnimationDuration * totalAnimationDurationFactor
            xTranslationAnimationDuration = xTranslationAnimationDuration * totalAnimationDurationFactor
            yTranslationAnimationDuration = yTranslationAnimationDuration * totalAnimationDurationFactor
            scaleAnimationDuration = scaleAnimationDuration * totalAnimationDurationFactor
            titleFadeAnimationDuration = titleFadeAnimationDuration * totalAnimationDurationFactor
            backgroundFadeAnimationDuration = backgroundFadeAnimationDuration * totalAnimationDurationFactor
            zoomOutAnimationDuration = zoomOutAnimationDuration * totalAnimationDurationFactor
            blurAnimationDuration = blurAnimationDuration * totalAnimationDurationFactor
        }
    }
    
    /** Check if the splash animation is stopped or finished */
    fileprivate var animationDone: Bool = false
    
    // MARK: Init
    
    /**
     Initialize an instance of Splash View Controller from storyboard
     - returns: returns VFGSplashViewController
     */
    open class func splashViewController() -> VFGSplashViewController {
        
        let nibName = isRTLLanguage ? RTLNibName : LTRNibName
        return VFGSplashViewController(nibName: nibName, bundle: bundle)
    }
    
    // MARK: UIViewController
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupSplashDirection()
        setupLayersInitialState()
        setupBackgroundImageView()
        setupVodafoneTextLabel()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupVodafoneTriangleView()
        setupTextMask()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !animationDone else { return }
        
        startAnimation()
    }
    
    // MARK: Public methods
    
    /**
     Show or hide Splash background
     @param show: a boolean for showing or hiding the background
     */
    open func toggleShowingBackground(show: Bool) {
        view.backgroundColor = show ? .white : .clear
        backgroundImageView.isHidden = !show
    }
    
    /**
     Start Splash Animations
     */
    open func startAnimation() {
        
        VFGLogger.log("Starting splash animation.");
        
        self.backgroundImageView.layer.add(self.backgroundAnimationGroup, forKey: animationKey)
        self.splashTriangleView.triangleShapeLayer.add(self.triangleLayerAnimationGroup, forKey: animationKey)
        self.splashTriangleView.layer.add(self.triangleViewAnimationGroup, forKey: animationKey)
        self.vodafoneLogoImageView.layer.add(self.vodafoneLogoAnimationGroup, forKey: animationKey)
        self.vodafoneTextLabel.layer.add(self.textLabelAnimationGroup, forKey: animationKey)
        self.maskTriangleView.layer.add(self.triangleViewAnimationGroup, forKey: animationKey)
    }
    
    /**
     Stop Splash Animations
     */
    open func stopAnimation() {
        self.backgroundImageView.layer.removeAnimation(forKey: animationKey)
        self.splashTriangleView.triangleShapeLayer.removeAnimation(forKey: animationKey)
        self.splashTriangleView.layer.removeAnimation(forKey: animationKey)
        self.vodafoneLogoImageView.layer.removeAnimation(forKey: animationKey)
        self.vodafoneTextLabel.layer.removeAnimation(forKey: animationKey)
        self.maskTriangleView.layer.removeAnimation(forKey: animationKey)
    }
    
    // MARK: Private methods
    
    fileprivate func setupSplashDirection() {
        
        if startingPosition == .SplashTriangleDirectionRight {
            self.view = bundle.loadNibNamed(RTLNibName, owner: self, options: nil)?.first as! UIView!
        } else {
            self.view = bundle.loadNibNamed(LTRNibName, owner: self, options: nil)?.first as! UIView!
        }
    }
    
    fileprivate func setupLayersInitialState() {
        
        vodafoneTextLabel.layer.opacity = Float(fadeBeginValue)
        backgroundImageView.layer.opacity = Float(fadeBeginValue)
        backgroundImageView.layer.transform = CATransform3DMakeScale(CGFloat(backgroundZoomingBeginValue),
                                                                     CGFloat(backgroundZoomingBeginValue),
                                                                     CGFloat(backgroundZoomingBeginValue))
    }
    
    fileprivate func setupBackgroundImageView() {
        
        backgroundImageView.image = shouldShowNightBackground ? nightBackgroundImage : backgroundImage
    }
    
    fileprivate func setupVodafoneTextLabel() {
        
        vodafoneTextLabel.font = titleLabelFont
        vodafoneTextLabel.textColor = titleLabelColor
        
        if (titleLabelAttributedText != nil) {
            vodafoneTextLabel.attributedText = titleLabelAttributedText
        } else {
            vodafoneTextLabel.text = titleLabelText
        }
    }
    
    fileprivate func setupVodafoneTriangleView() {
        
        var startDegrees: CGFloat = leftTriangleStartDegrees
        var endDegrees: CGFloat = leftTriangleEndDegrees
        
        if (self.startingPosition == .SplashTriangleDirectionRight) {
            
            startDegrees = rightTriangleStartDegrees
            endDegrees = rightTriangleEndDegrees
        }
        
        vodafoneLogoImageView.layoutIfNeeded()
        
        splashTriangleView.radius = vodafoneLogoImageView.bounds.size.width/2
        splashTriangleView.startDegrees = startDegrees
        splashTriangleView.endDegrees = endDegrees
        splashTriangleView.arcDirection = self.startingPosition
        splashTriangleView.fillColor = self.fillColor
        
        maskTriangleView.radius = vodafoneLogoImageView.bounds.size.width/2
        maskTriangleView.startDegrees = startDegrees
        maskTriangleView.endDegrees = endDegrees
        maskTriangleView.arcDirection = self.startingPosition
    }
    
    fileprivate func setupTextMask() {
        
        view.layoutIfNeeded()
        
        // Set the maskTriangleView to the same position as the 'real' triangle view
        maskTriangleView.center = CGPoint(x: vodafoneLogoImageView.frame.midX, y: vodafoneLogoImageView.frame.midY)
        
        // Convert the triangles coordinate system to be that of the label in which it is masking
        let triangleRectAsMask = vodafoneTextLabel.convert(maskTriangleView.frame, from: view)
        
        vodafoneTextLabel.mask = maskTriangleView
        
        // Switch the frame of the maskTriangleView, as setting it as the 'maskView' repositions it in 'vodafoneTextLabel''s coordinate space
        // (i.e. (0,0) is now the top left of the label)
        maskTriangleView.frame = triangleRectAsMask
    }
    
    // MARK: Lazy properties - Splash Animations
    
    fileprivate lazy var slowRotationAnimation: CABasicAnimation = {
        
        let initialRotationAnimation = CABasicAnimation(forwardAnimationWithKeyPath: rotationAnimationKey)
        
        if (self.startingPosition == .SplashTriangleDirectionLeft) {
            
            if (self.rotationDirection == .SplashTriangleDirectionRight) {
                initialRotationAnimation.toValue = slowRotationAngle * -1.0
                
            } else {
                initialRotationAnimation.toValue = slowRotationAngle
            }
            
        } else {
            
            if (self.rotationDirection == .SplashTriangleDirectionLeft) {
                initialRotationAnimation.toValue = slowRotationAngle * -1.0
                
            } else {
                initialRotationAnimation.toValue = slowRotationAngle
            }
        }
        
        initialRotationAnimation.duration = self.slowRotationAnimationDuration +
            self.backgroundFadeAnimationDuration
        
        return initialRotationAnimation
    }()
    
    fileprivate lazy var fastRotationAnimation: CABasicAnimation = {
        
        let fastRotationAnimation = CABasicAnimation(forwardAnimationWithKeyPath: rotationAnimationKey)
        
        if (self.startingPosition == .SplashTriangleDirectionLeft) {
            if (self.rotationDirection == .SplashTriangleDirectionRight) {
                fastRotationAnimation.toValue = fastRotationRightDirectionAngle * -1.0
            } else {
                fastRotationAnimation.toValue = fastRotationLeftDirectionAngle
            }
        } else {
            if(self.rotationDirection == .SplashTriangleDirectionLeft) {
                fastRotationAnimation.toValue = fastRotationLeftDirectionAngle * -1.0
            } else {
                fastRotationAnimation.toValue = fastRotationRightDirectionAngle
            }
        }
        
        fastRotationAnimation.timingFunction = easeInOutQuart
        fastRotationAnimation.duration = self.fastRotationAnimationDuration
        fastRotationAnimation.beginTime = self.slowRotationAnimationDuration +
            self.backgroundFadeAnimationDuration
        return fastRotationAnimation
    }()
    
    fileprivate lazy var xTranslationAnimation: CABasicAnimation = {
        
        let xTranslationAnimation = self.translateAnimation(keyPath: xTranslationKey)
        
        if (self.startingPosition == .SplashTriangleDirectionLeft) {
            xTranslationAnimation.toValue = CGFloat(-self.view.frame.size.width * xTranslationEndPointPercentToViewWidth)
            
        } else {
            xTranslationAnimation.toValue = CGFloat(self.view.frame.size.width * xTranslationEndPointPercentToViewWidth)
        }
        xTranslationAnimation.duration = self.xTranslationAnimationDuration
        return xTranslationAnimation
    }()
    
    fileprivate lazy var yTranslationAnimation: CABasicAnimation = {
        
        let isIPadDevice = self.traitCollection.verticalSizeClass == .regular &&
            self.traitCollection.horizontalSizeClass == .regular
        
        let yPositionRatio: CGFloat = isIPadDevice ? yTranslationEndPointPercentToViewHeightIPad : yTranslationEndPointPercentToViewHeightIPhone
        
        let yTranslationAnimation = self.translateAnimation(keyPath: yTranslationKey)
        yTranslationAnimation.toValue = CGFloat(-self.view.frame.size.height*yPositionRatio)
        yTranslationAnimation.duration = self.yTranslationAnimationDuration
        return yTranslationAnimation
    }()
    
    fileprivate lazy var titleFadeAnimation: CABasicAnimation = {
        let titleFadeAnimation = self.fadeAnimation(keyPath: opacityKey)
        titleFadeAnimation.duration = self.titleFadeAnimationDuration
        titleFadeAnimation.beginTime = self.titleFadeAnimationBeginTime +
            self.backgroundFadeAnimationDuration
        return titleFadeAnimation
    }()
    
    fileprivate lazy var backgroundFadeAnimation: CABasicAnimation = {
        let backgroundFadeAnimation = self.fadeAnimation(keyPath: opacityKey)
        backgroundFadeAnimation.duration = self.backgroundFadeAnimationDuration
        return backgroundFadeAnimation
    }()
    
    fileprivate lazy var xScaleAnimation: CABasicAnimation = {
        return self.scaleAnimation(keyPath: xScaleKey)
    }()
    
    fileprivate lazy var yScaleAnimation: CABasicAnimation = {
        return self.scaleAnimation(keyPath: yScaleKey)
    }()
    
    fileprivate lazy var zScaleAnimation: CABasicAnimation = {
        return self.scaleAnimation(keyPath: zScaleKey)
    }()
    
    fileprivate lazy var xZoomOutAnimation: CABasicAnimation = {
        return self.zoomAnimation(keyPath: xScaleKey)
    }()
    
    fileprivate lazy var yZoomOutAnimation: CABasicAnimation = {
        return self.zoomAnimation(keyPath: yScaleKey)
    }()
    
    fileprivate lazy var zZoomOutAnimation: CABasicAnimation = {
        return self.zoomAnimation(keyPath: zScaleKey)
    }()
    
    // MARK: Animation Templates
    
    fileprivate func translateAnimation(keyPath: String) -> CABasicAnimation {
        
        let translateAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        translateAnimation.timingFunction = easeInOutQuart
        translateAnimation.beginTime = self.slowRotationAnimationDuration +
            self.backgroundFadeAnimationDuration
        return translateAnimation
    }
    
    fileprivate func fadeAnimation(keyPath: String) -> CABasicAnimation {
        
        let fadeAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        fadeAnimation.fromValue = NSNumber(value: fadeBeginValue as Double)
        fadeAnimation.toValue = NSNumber(value: fadeEndValue as Double)
        return fadeAnimation
    }
    
    fileprivate func scaleAnimation(keyPath: String) -> CABasicAnimation {
        
        let scaleAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        scaleAnimation.toValue = NSNumber (value: scaleFactor as Double)
        scaleAnimation.timingFunction = easeInOutQuart
        scaleAnimation.duration = self.scaleAnimationDuration
        scaleAnimation.beginTime = self.slowRotationAnimationDuration +
            self.backgroundFadeAnimationDuration
        return scaleAnimation
    }
    
    fileprivate func zoomAnimation(keyPath: String) -> CABasicAnimation {
        
        let zoomAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        zoomAnimation.toValue = NSNumber(value: backgroundZoomingEndValue as Double)
        zoomAnimation.timingFunction = easeOutExpo
        zoomAnimation.duration = self.zoomOutAnimationDuration
        zoomAnimation.beginTime = self.slowRotationAnimationDuration +
            self.backgroundFadeAnimationDuration
        return zoomAnimation
    }
    
    fileprivate lazy var blurAnimation: CABasicAnimation = {
        
        let blurAnimation = CABasicAnimation(keyPath: rasterizationBlurKey)
        blurAnimation.fromValue = NSNumber (value: rasterizationBlurBeginValue as Double)
        blurAnimation.toValue = NSNumber(value: rasterizationBlurEndValue as Double)
        blurAnimation.timingFunction = easeInQuart
        blurAnimation.duration = self.blurAnimationDuration
        blurAnimation.beginTime = self.slowRotationAnimationDuration +
            self.backgroundFadeAnimationDuration
        blurAnimation.isRemovedOnCompletion = true
        return blurAnimation
    }()
    
    // MARK: Animation Groups
    
    /** Animation group for the vodafone logo, which scales and translates. */
    fileprivate lazy var vodafoneLogoAnimationGroup: CAAnimationGroup = {
        
        let vodafoneLogoAnimationsDuration = self.backgroundFadeAnimationDuration +
            self.slowRotationAnimationDuration +
            self.xTranslationAnimationDuration
        
        let vodafoneLogoAnimations = [self.xTranslationAnimation,
                                      self.yTranslationAnimation,
                                      self.xScaleAnimation,
                                      self.yScaleAnimation,
                                      self.zScaleAnimation]
        
        let vodafoneLogoAnimationGroup = CAAnimationGroup(forwardAnimationGroupWithDuration: vodafoneLogoAnimationsDuration, animations: vodafoneLogoAnimations)
        
        return vodafoneLogoAnimationGroup
    }()
    
    /** Animation group for the triangle view, which scales, rotates and translates. */
    fileprivate lazy var triangleViewAnimationGroup: CAAnimationGroup = {
        
        let triangleViewAnimationsDuration = self.backgroundFadeAnimationDuration +
            self.slowRotationAnimationDuration +
            self.xTranslationAnimationDuration
        
        let triangleViewAnimations = [self.slowRotationAnimation,
                                      self.fastRotationAnimation,
                                      self.xTranslationAnimation,
                                      self.yTranslationAnimation,
                                      self.xScaleAnimation,
                                      self.yScaleAnimation,
                                      self.zScaleAnimation]
        
        return CAAnimationGroup(forwardAnimationGroupWithDuration: triangleViewAnimationsDuration, animations: triangleViewAnimations)
    }()

    /** Animation group for the triangle layer, which blurs. */
    fileprivate lazy var triangleLayerAnimationGroup: CAAnimationGroup = {

        let triangleLayerAnimationsDuration = self.backgroundFadeAnimationDuration +
            self.slowRotationAnimationDuration +
            self.blurAnimationDuration

        let triangleLayerAnimations = [self.blurAnimation]

        let triangleLayerAnimationGroup = CAAnimationGroup(forwardAnimationGroupWithDuration: triangleLayerAnimationsDuration, animations: triangleLayerAnimations)
        triangleLayerAnimationGroup.fillMode = kCAFillModeRemoved
        
        return triangleLayerAnimationGroup
    }()
    
    /** Animation group for the text Label, which fade when the splash starts. */
    fileprivate lazy var textLabelAnimationGroup: CAAnimationGroup = {
        
        let textLabelAnimationsDuration = self.backgroundFadeAnimationDuration +
            self.titleFadeAnimationBeginTime +
            self.titleFadeAnimationDuration
        
        let textLabelAnimations = [self.titleFadeAnimation]
        
        return CAAnimationGroup(forwardAnimationGroupWithDuration: textLabelAnimationsDuration, animations: textLabelAnimations)
    }()
    
    /** Animation group for the background, which zoomout in splash final state. */
    fileprivate lazy var backgroundAnimationGroup: CAAnimationGroup = {
        
        let backgroundAnimationsDuration = self.backgroundFadeAnimationDuration +
            self.slowRotationAnimationDuration +
            self.zoomOutAnimationDuration
        
        let backgroundAnimations = [self.backgroundFadeAnimation,
                                    self.xZoomOutAnimation,
                                    self.yZoomOutAnimation,
                                    self.zZoomOutAnimation]
        
        let backgroundAnimationGroup = CAAnimationGroup(forwardAnimationGroupWithDuration: backgroundAnimationsDuration, animations: backgroundAnimations)
        backgroundAnimationGroup.delegate = self
        
        return backgroundAnimationGroup
    }()

    // MARK: CAAnimationDelegate

    /**
     CAAnimationDelegate method excutes when the animation stopped or finished
     */
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        VFGLogger.log("Finishing splash animation.")
        
        self.animationDone = true
        self.completionHandler(flag)
    }
}
