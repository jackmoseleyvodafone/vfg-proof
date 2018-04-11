//
//  VFGAnimatedSplash.swift
//  VFGAnimatedSplash
//
//  Created by ahmed elshobary on 8/20/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import Lottie
import VFGCommonUI
import VFGCommonUtils
import CoreTelephony
// MARK: - Private Constants

fileprivate let storyboardName: String = "VFGAnimatedSplash"
fileprivate let circleLockupType: String = "circleLockup"
fileprivate let logoLoadinType: String = "LogoLoading"
fileprivate let logoCirclefadeBeginValue: Double = 1.0
fileprivate let logoCirclefadeEndValue: Double = 0.0

class VFGAnimatedSplashViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    // MARK: Public IBOutlets
    
    @IBOutlet  weak var contentView: UIView!
    @IBOutlet  weak var logoLoadingLottiView: LOTAnimationView!
    @IBOutlet weak var circleMask: UIView!
    
    // MARK:  Properties
    
    /** Check if the splash is currently animating */
    fileprivate var isAnimating: Bool = false
    
    /** Check if the animation start withTimeOut or not */
    fileprivate var startWithTimeOut: Bool = true
    
    /** Check if the animation start withTimeOut or not */
    fileprivate var animationFinsihed: Bool = false
    
    /** Check the type of lottie Animation which is animating now */
    fileprivate var typeOfLottie: String = logoLoadinType
    
    /* Completion handler for when the splash animation finishes */
    open var completionHandler: (_ finished: Bool) -> () = {finished in }
    
    /** time out for the Logo loading  */
    open var logoLoadingTimeOut: Double = LogoLoopLottieAnimationConstants.logoLoopDeafultTimeOut
    
    /** Bool for show or hide vodafone logo  */
    open var showVodafoneLogo: Bool = true
    
    /** x position for vodafone logo  in the dashboard */
    open var xPositionForLogo: CGFloat = 15
    
    /** y position for vodafone logo  in the dashboard  */
    open var yPositionForLogo: CGFloat = 30
    
    /** background image for the application  */
    public var backGroundImage: UIImageView?
    
    /** status bar style for splash  */
    open var statusBarStyle: UIStatusBarStyle = .default
    
    /** window for logo in splash  */
    open var customWindow: UIWindow?
    
    
    // MARK: Private Properties
    
    fileprivate var logoLoadingLottiAnimationView : LOTAnimationView?
    fileprivate var logoCircleLottiAnimationView : LOTAnimationView?
    fileprivate let circleExpandTransitionDelegate = ExpandTransitionDelegate()
    fileprivate var logoImageView:UIImageView?
    
    // MARK: Animation Templates
    
    fileprivate func zoomAnimation(keyPath: String) -> CABasicAnimation {
        
        let zoomAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        zoomAnimation.toValue = NSNumber(value: DashBoardAnimationConstants.dashboardZommAnimationEndValueFactor as Double)
        zoomAnimation.timingFunction = CAMediaTimingFunction.easeOutQuint
        zoomAnimation.duration = DashBoardAnimationConstants.dashboardZoomAnimationDuration
        
        return zoomAnimation
    }
    
    fileprivate func fadeAnimation(keyPath: String) -> CABasicAnimation {
        
        let fadeAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        fadeAnimation.fromValue = NSNumber(value: logoCirclefadeBeginValue as Double)
        fadeAnimation.toValue = NSNumber(value: logoCirclefadeEndValue as Double)
        fadeAnimation.timingFunction = CAMediaTimingFunction.easeOutSine
        return fadeAnimation
    }
    
    fileprivate func translateAnimation(keyPath: String) -> CABasicAnimation {
        
        let translateAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        translateAnimation.timingFunction = CAMediaTimingFunction.easeInOutQuart
        translateAnimation.beginTime =  LogoAnimationConstants.changePositionDelay
        translateAnimation.duration  =  LogoAnimationConstants.changePositionDuration
        return translateAnimation
    }
    
    fileprivate func scaleAnimation(keyPath: String) -> CABasicAnimation {
        
        let scaleAnimation = CABasicAnimation(forwardAnimationWithKeyPath: keyPath)
        scaleAnimation.toValue = NSNumber (value: LogoAnimationConstants.logoRatioSizeAfterScale as Double)
        scaleAnimation.timingFunction = CAMediaTimingFunction.easeInOutQuart
        scaleAnimation.duration = LogoAnimationConstants.logoScaleTime
        scaleAnimation.beginTime = LogoAnimationConstants.logoScaleDelay
        return scaleAnimation
    }
    
    // MARK: Lazy properties - Splash Animations
    
    fileprivate lazy var xScaleAnimation: CABasicAnimation = {
        return self.scaleAnimation(keyPath: BasicAnimationsKeys.xScaleKey)
    }()
    
    fileprivate lazy var yScaleAnimation: CABasicAnimation = {
        return self.scaleAnimation(keyPath: BasicAnimationsKeys.yScaleKey)
    }()
    
    fileprivate lazy var zScaleAnimation: CABasicAnimation = {
        return self.scaleAnimation(keyPath: BasicAnimationsKeys.zScaleKey)
    }()
    
    fileprivate lazy var xZoomOutAnimation: CABasicAnimation = {
        return self.zoomAnimation(keyPath: BasicAnimationsKeys.xScaleKey)
    }()
    
    fileprivate lazy var yZoomOutAnimation: CABasicAnimation = {
        return self.zoomAnimation(keyPath: BasicAnimationsKeys.yScaleKey)
    }()
    
    fileprivate lazy var zZoomOutAnimation: CABasicAnimation = {
        return self.zoomAnimation(keyPath: BasicAnimationsKeys.zScaleKey)
    }()
    
    
    fileprivate lazy var logoLoadingFadeAnimation: CABasicAnimation = {
        let logoLoadingAnimation = self.fadeAnimation(keyPath: BasicAnimationsKeys.opacityKey)
        logoLoadingAnimation.duration = LogoLoopLottieAnimationConstants.logoLoopFadeOutDuration
        logoLoadingAnimation.beginTime = 0
        
        return logoLoadingAnimation
    }()
    
    fileprivate lazy var xTranslationAnimation: CABasicAnimation = {
        let logoWidth : CGFloat = CGFloat(LogoAnimationConstants.logoWidthAfterScale / 2)
        let xTranslationAnimation = self.translateAnimation(keyPath: BasicAnimationsKeys.xTranslationKey)
        xTranslationAnimation.toValue =  -(((self.view.frame.size.width / 2) - logoWidth) - self.xPositionForLogo)
        
        return xTranslationAnimation
    }()
    
    fileprivate lazy var yTranslationAnimation: CABasicAnimation = {
        let logoheight : CGFloat = CGFloat(LogoAnimationConstants.logoHeightAfterScale / 2)
        
        let yTranslationAnimation = self.translateAnimation(keyPath: BasicAnimationsKeys.yTranslationKey)
        yTranslationAnimation.toValue = -(((self.view.frame.size.height / 2) - logoheight) - self.yPositionForLogo)
        
        return yTranslationAnimation
    }()
    
    
    // MARK: Animation Groups
    
    /** Animation group for the vodafone logo, which scales and translates. */
    fileprivate lazy var vodafoneLogoAnimationGroup: CAAnimationGroup = {
        
        let vodafoneLogoAnimationsDuration = LogoAnimationConstants.logoScaleTime + LogoAnimationConstants.changePositionDuration
        
        
        let vodafoneLogoAnimations = [
            self.xScaleAnimation,
            self.yScaleAnimation,
            self.zScaleAnimation,
            self.xTranslationAnimation,
            self.yTranslationAnimation
        ]
        
        let vodafoneLogoAnimationGroup = CAAnimationGroup(forwardAnimationGroupWithDuration: vodafoneLogoAnimationsDuration, animations: vodafoneLogoAnimations)
        vodafoneLogoAnimationGroup.delegate = self
        return vodafoneLogoAnimationGroup
    }()
    
    /** Animation group for the loading Logo, which fade when Finished. */
    fileprivate lazy var loadingLogoAnimationGroup: CAAnimationGroup = {
        
        let loadingLogoAnimationDuration = LogoLoopLottieAnimationConstants.logoLoopFadeOutDuration
        
        let loadingLogoAnimations = [self.logoLoadingFadeAnimation]
        
        return CAAnimationGroup(forwardAnimationGroupWithDuration: loadingLogoAnimationDuration, animations: loadingLogoAnimations)
    }()
    
    // MARK: Init
    
    /**
     Initialize an instance of Splash View Controller from storyboard
     - returns: returns VFGSplashViewController
     */
    open class func animatedSplashViewController() -> VFGAnimatedSplashViewController {
        
        return UIStoryboard(name:storyboardName, bundle:VFGSplashBundle.bundle()).instantiateViewController(withIdentifier: String(describing: self)) as! VFGAnimatedSplashViewController
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        //  setupNotifications()
    }
    
    
    /**
     Start Splash Animations
     */
    open func startAnimation() {
        _ = self.view
        setupNotifications()
        removeLogoViewFromWindow()
        animationFinsihed = false
        startWithTimeOut = false
        if (self.isAnimating) { return }
        self.isAnimating = true
        logoLoadingLoop()
    }
    
    /**
     Start Splash Animations With time out
     */
    open func startAnimationWithTimeOut() {
        _ = self.view
        startWithTimeOut = true
        removeLogoViewFromWindow()
        animationFinsihed = false
        setupNotifications()
        if (self.isAnimating) { return }
        self.isAnimating = true
        logoLoadingLoop()
        let timeOutConstant = logoLoadingTimeOut
        self.perform(#selector(self.completeAnimation), with: self, afterDelay:TimeInterval(timeOutConstant))
    }
    
    
    /**
     dismiss splash view controller and Dummy view controller
     */
    
    open func dismissAllPresentedView(completionHandler: ((_ finished: Bool) -> ())? ) {
        if (getTopViewController() is VFGDummyDashboardViewController){
            let DummyView : UIViewController =  (getTopViewController())!
            
            DummyView.dismiss(animated: false, completion: {
                self.dismiss(animated: false, completion: nil)
                completionHandler?(true)
                self.view.removeFromSuperview()
            })
            
        }
        else{
            self.dismiss(animated: false, completion: nil)
            completionHandler?(true)
            self.view.removeFromSuperview()
        }
    }
    
    
    /**
     Complete The Animation
     */
    
    open func completeAnimation() {
        
        self.logoLoadingLottiAnimationView?.layer.add(self.loadingLogoAnimationGroup, forKey: BasicAnimationsKeys.animationKey)
        logoCircleLockup()
        self.logoCircleLottiAnimationView?.layer.add(self.vodafoneLogoAnimationGroup, forKey: BasicAnimationsKeys.animationKey)
        
        self.perform(#selector(self.playExpandAnimation), with: self, afterDelay:TimeInterval(RedCircleAnimationConstants.redCircleExpandDelay) )
        
    }
    
    
    /**
     Show or hide Vodafone Logo
     */
    
    public func showOrHideVodafoneLogo(visibility:Bool){
        self.logoImageView?.isHidden = visibility
    }
    
    
    open func addLogoImageToTopViewController(){
        logoImageView?.frame = CGRect(x: xPositionForLogo, y: yPositionForLogo, width: LogoAnimationConstants.logoWidthAfterScale, height: LogoAnimationConstants.logoHeightAfterScale)
        getTopViewController()?.view.addSubview(logoImageView!)
        
    }
    // MARK: Private methods
    
    @objc fileprivate func playvodafoneLogoAnimationGroup(){
        self.self.logoCircleLottiAnimationView?.layer.add(self.vodafoneLogoAnimationGroup, forKey: BasicAnimationsKeys.animationKey)
    }
    
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterforground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterbackGround(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground , object: nil)
        
    }
    
    
    fileprivate func setupBackgroundImageView() {
        _ = self.view
        
        self.view.backgroundColor?.withAlphaComponent(1)
        if backGroundImage?.image == nil{
            backGroundImage = UIImageView(image: UIImage(named: "bg_splash" ,in: VFGSplashBundle.bundle(), compatibleWith: nil ))
        }
        logoImageView?.frame = CGRect(x: xPositionForLogo, y: yPositionForLogo, width: CGFloat(LogoAnimationConstants.logoWidthAfterScale), height: CGFloat(LogoAnimationConstants.logoHeightAfterScale))
        logoImageView = UIImageView(image: UIImage(named: "logoFlat", in: VFGSplashBundle.bundle(), compatibleWith: nil))
        self.backGroundImage?.layer.transform = CATransform3DMakeScale(CGFloat(DashBoardAnimationConstants.dashboardZommAnimationBeginValueFactor),
                                                                       CGFloat(DashBoardAnimationConstants.dashboardZommAnimationBeginValueFactor),
                                                                       CGFloat(DashBoardAnimationConstants.dashboardZommAnimationBeginValueFactor))
    }
    
    
    
    
    fileprivate func logoLoadingLoop(){
        typeOfLottie = "LogoLoading"
        let url = VFGSplashBundle.bundle()?.url(forResource: JsonNames.logoLoadingLoopJson, withExtension: JsonNames.jsonFormate)
        if let theURL : URL = url {
            self.logoLoadingLottiAnimationView = LOTAnimationView(contentsOf: theURL)
        }
        self.logoLoadingLottiAnimationView?.frame = self.logoLoadingLottiView.frame
        
        self.contentView.addSubview(self.logoLoadingLottiAnimationView!)
        self.logoLoadingLottiAnimationView?.loopAnimation = true
        self.logoLoadingLottiAnimationView?.play()
    }
    
    /** Animation group for the background, which zoomout in splash final state. */
    fileprivate lazy var backgroundAnimationGroup: CAAnimationGroup = {
        
        let backgroundAnimationDuration = DashBoardAnimationConstants.dashboardZoomAnimationDuration
        
        let backgroundAnimationAnimations = [self.xZoomOutAnimation,
                                             self.yZoomOutAnimation,
                                             self.zZoomOutAnimation]
        
        return CAAnimationGroup(forwardAnimationGroupWithDuration: backgroundAnimationDuration, animations: backgroundAnimationAnimations)
    }()
    
    
    @objc fileprivate func removeLogoLoadingLoop(){
        self.logoLoadingLottiAnimationView?.removeFromSuperview()
    }
    
    @objc fileprivate func removeLogoViewFromWindow(){
        self.logoCircleLottiAnimationView?.removeFromSuperview()
    }
    
    fileprivate func logoCircleLockup(){
        typeOfLottie = circleLockupType
        let url = VFGSplashBundle.bundle()?.url(forResource: JsonNames.logoCircleLockupJson, withExtension: JsonNames.jsonFormate)
        if let theURL : URL = url {
            self.logoCircleLottiAnimationView = LOTAnimationView(contentsOf: theURL)
        }
        self.logoCircleLottiAnimationView?.frame = self.contentView.frame
        self.contentView.addSubview(self.logoCircleLottiAnimationView!)
        self.logoCircleLottiAnimationView?.play()
        if customWindow != nil{
            customWindow?.addSubview(self.logoCircleLottiAnimationView!)
            
        } else{
            if let window : UIWindow = (UIApplication.shared.windows.last){
            window.addSubview(self.logoCircleLottiAnimationView!)
            }
        }
    }
    
    
    @objc fileprivate func playExpandAnimation(){
        
        let modelView = VFGDummyDashboardViewController.dummyDashBoardViewController()
        backGroundImage?.frame = modelView.view.frame
        modelView.view.addSubview(backGroundImage!)
        modelView.transitioningDelegate = self
        modelView.transitioningDelegate = circleExpandTransitionDelegate
        modelView.statusBarStyle = statusBarStyle
        modelView.modalPresentationStyle = .custom
        animateBackGround()
        self.view.window?.rootViewController?.present(modelView, animated: true, completion:{
            (isFinised) in
            if self.customWindow != nil{
                self.customWindow?.bringSubview(toFront: self.logoCircleLottiAnimationView!)
                
            } else{
                if let window : UIWindow = (UIApplication.shared.windows.last){
                    window.bringSubview(toFront: self.logoCircleLottiAnimationView!)
                }
            }
        })
    }
    
    @objc fileprivate func willEnterforground (_ notification: NSNotification){
        
        if startWithTimeOut && animationFinsihed == false && typeOfLottie == logoLoadinType{
            startAnimationWithTimeOut()
        }
        if  !startWithTimeOut && animationFinsihed == false && typeOfLottie == logoLoadinType{
            startAnimation()
        }
        
    }
    
    
    fileprivate func endSplashAnimation(){
        removeLogoViewFromWindow()
        self.backGroundImage?.removeFromSuperview()
        removeLogoLoadingLoop()
        self.view.backgroundColor?.withAlphaComponent(0)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    
    fileprivate func restartSplashAnimation(){
        endSplashAnimation()
        setupBackgroundImageView()
        
    }
    
    
    @objc fileprivate func willEnterbackGround (_ notification:NSNotification){
        isAnimating = false
        
        if startWithTimeOut && animationFinsihed == false && typeOfLottie == logoLoadinType{
            restartSplashAnimation()
            
        }
        if !startWithTimeOut && animationFinsihed == false && typeOfLottie == logoLoadinType
        {
            restartSplashAnimation()
            
        }
    }
    
    
    @objc fileprivate func animateBackGround(){
        self.self.backGroundImage?.layer.add(self.backgroundAnimationGroup, forKey: BasicAnimationsKeys.animationKey)
        
    }
}
extension VFGAnimatedSplashViewController : CAAnimationDelegate{
    
    // MARK: CAAnimationDelegate
    
    /**
     CAAnimationDelegate method excutes when the animation stopped or finished
     */
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animationDidStop")
        self.isAnimating = false
        animationFinsihed = true
        endSplashAnimation()
        if !showVodafoneLogo{
            removeLogoViewFromWindow()
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        self.completionHandler(flag)
    }
}

