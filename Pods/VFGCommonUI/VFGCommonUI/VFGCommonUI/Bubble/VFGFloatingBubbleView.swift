//
//  VFGFloatingBubbleButton.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 3/16/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation
import VFGCommonUtils



public class VFGFloatingBubbleView: UIView , UIViewControllerTransitioningDelegate {
    
    //MARK:- Properties
    private var LottiAnimationView : LOTAnimationView!
    private var player: AVAudioPlayer?
    private let transition = BubbleTransition()
    public  var presentedViewController : UIViewController?
    private weak var superView: UIView?
    private var viewTitle: String = "needhelp_bubble_text".localized
    private let lineSpacing: CGFloat = 3.0
    private let viewTopFont: UIFont? = UIFont.vodafoneRegularFont(16.0)
    private let viewBottomFont: UIFont? = UIFont.vodafoneRegularFont(16.0)
    private var bubbleWithoutRoute:UIImage? = UIImage.init(named: "whitBubbleWithoutRoute", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    private var redbubbleWithoutRoute:UIImage? = UIImage.init(named: "speechBubbleWithoutRoot", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    
    private var notificationEnvlopeRed:   UIImage? = UIImage.init(named: "notification_Envlope_red", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    private var notificationEnvlopeWhite: UIImage? = UIImage.init(named: "notification_Envlope_white", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    
    private var bubbleNotificationWithoutRoute:UIImage? = UIImage.init(named: "whiteBubbleWithNotification", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    private var redbubbleNotificationWithoutRoute:UIImage? = UIImage.init(named: "redBubbleWithNotification", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    
    
    private var viewImage: UIImage? = UIImage.init(named: "bubble", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    private let viewSecondaryImage: UIImage? = UIImage.init(named: "redBubble", in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    private var envelopeImageViewContainer: UIView = UIView.init(frame: CGRect.init(x: 3, y: 3, width: 23, height: 23))
    
    private let textColor: UIColor = UIColor(red: 230.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    private let textSecondaryColor: UIColor = UIColor.white
    private var textLabel: UILabel = UILabel()
    private var imageView: UIImageView = UIImageView()
    private var secondImageView: UIImageView = UIImageView()
    //private let destinationViewController : UIViewController = VFGSupportViewController.viewController()
    
    //MARK:- Animation Properties
    private let bubbleAnimationScaleFactor : Double = 1.2
    private let bubbleAnimationScaleDuration : Double = 0.13
    private let bubbleAnimationExplotionDuration : Double = 0.67
    private let bubbleExpandTime : Double  = 0.2
    private let bubbleExpandDuration : Double = 0.67
    private let bubbleChangePhotoAnimationDuration: Double = 1.2
    private let bubbleChangePhotoEndingAnimationDuration: Double = 0.5
    private let bubbleEnvelopeAnimationDuration: Double = 1.0
    private let bubbleChangeLabelPositionAnimationDuration: Double = 0.5
    private let bubbbeScaleOutAnimationDuration : Double = 1.0
    public var isSecondLevel: Bool = false {
        
        didSet {
            if isSecondLevel {
                setSecondLevelConfig()
            }
            else {
                setFirstLevelConfig()
            }
        }
    }
    
    // this boolean responsible for switching the imageView for bubble icon, if it is true, a function will be called to theme the imageview with the right notification bubble icon.
    
    private var hasNewNotification: Bool = false {
        didSet {
            animateEnvelopeImageViewContainerIfInNotificationMode()
        }
    }
    
    @objc private func scaleInAnimation() {
        envelopeImageViewContainer.alpha = 0
        transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        secondImageView = isSecondLevel ? UIImageView(image:redbubbleWithoutRoute) : UIImageView(image:bubbleWithoutRoute)
        addSubview(secondImageView)
        textLabel.alpha = 0
        imageView.alpha = 0
        secondImageView.alpha = 1
    }

    @objc private func scaleOutAnimation() {
        UIView.animate(withDuration: bubbbeScaleOutAnimationDuration) { [weak self] in
            guard let `self` = self else {
                return
            }
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.textLabel.alpha = 1
            self.textLabel.attributedText = self.getLabelFormattedStringForColor(self.textSecondaryColor)
            self.addLabel()
        }
    }

    @objc private func changePhotoAnimation(){
        UIView.animate(withDuration: bubbleChangePhotoAnimationDuration,
            animations: { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.imageView.alpha = 1
            },
            completion: { [weak self] completed in
                guard let `self` = self, completed else {
                    return
                }
                UIView.animate(withDuration: self.bubbleChangePhotoEndingAnimationDuration,
                    animations: { [weak self] in
                        guard let `self` = self else {
                            return
                        }
                        self.secondImageView.alpha = 0
                    },
                    completion: { (completed) in
                        if completed {
                            self.animateEnvelopeImageViewContainerIfInNotificationMode()
                        }
                    })
            })
    }
    
    @objc private func animateEnvelopeImageViewContainerIfInNotificationMode(){
        if hasNewNotification {
            
            UIView.animate(withDuration: bubbleEnvelopeAnimationDuration) {
                self.envelopeImageViewContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                self.envelopeImageViewContainer.alpha = 1
            }
        }
        else{
            UIView.animate(withDuration: bubbleEnvelopeAnimationDuration) {
                self.envelopeImageViewContainer.transform = CGAffineTransform(scaleX: 0, y: 0)
                
                self.envelopeImageViewContainer.alpha = 0
            }
        }
        
        
        print("bubbleChangeLabelPositionAnimationDuration started")
        
        UIView.animate(withDuration: bubbleChangeLabelPositionAnimationDuration, animations: {
            self.addLabel()
            print("bubbleChangeLabelPositionAnimationDuration ended")
            
            
        })
    }
    
    public func scaleWhiteBubble(){
        self.secondImageView.removeFromSuperview()
        self.perform(#selector(self.scaleInAnimation), with: self, afterDelay: 0)
        self.perform(#selector(self.scaleOutAnimation), with: self, afterDelay: bubbleExpandDuration)
        self.perform(#selector(self.changePhotoAnimation), with: self, afterDelay: bubbleChangePhotoAnimationDuration)
    }
    
    private func playSound() {
        let soundResourceName : String = "pop"
        let soundResourceExtension : String = "mp3"
        guard let url : URL = VFGCommonUIBundle.bundle()?.url(forResource: soundResourceName, withExtension: soundResourceExtension) else {
            VFGLogger.log("Cannot find sound file: " + soundResourceName + "." + soundResourceExtension)
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            VFGLogger.log(error.localizedDescription)
        }
    }
    
    public func playExplotionAnimation(){
        
        let animationResourceName : String = "bubblepop_isolated"
        let animationResourceExtension : String = "json"
        
        guard let url : URL = VFGCommonUIBundle.bundle()?.url(forResource: animationResourceName, withExtension: animationResourceExtension) else {
            VFGLogger.log("Cannot find animation file: " + animationResourceName + "." +  animationResourceExtension)
            return
        }
        
        self.LottiAnimationView = LOTAnimationView(contentsOf: url)
        self.LottiAnimationView.frame = self.frame
        playSound()
        self.superView?.addSubview(self.LottiAnimationView)
        self.LottiAnimationView.play { (finished) in
            
            
        }
        self.perform(#selector(self.playExpandAnimation), with: self, afterDelay:bubbleAnimationScaleDuration )
    }
    // MARK: UIViewControllerTransitioningDelegate
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: self.frame.midX-5, y: self.frame.midY-25) //self.center
        
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: self.frame.midX-5, y: self.frame.midY-25) //self.center
        return transition
    }
    
    public var clickAction: (() -> Void)?
    
    //MARK:- Init
    required public init(withView view: UIView) {
        
        imageView = UIImageView.init(image: viewImage)
        imageView.sizeToFit()
        
        let yPosition = view.bounds.size.height - (view.bounds.size.height * 0.28)
        
        super.init(frame: CGRect(x: view.bounds.size.width - imageView.bounds.size.width - 5.0, y:yPosition , width: imageView.bounds.size.width, height: imageView.bounds.size.height))
        
        
        self.addSubview(imageView)
        
        superView = view
        addLabel()
        addNotificationIcon()
        view.addSubview(self)
        createPanGesture()
        addTapGestureAction()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Public Utils
    public func setBubbleTitle(title: String){
        viewTitle = title
        addLabel()
    }

    public func setSecondLevel(_ isSecondLevel: Bool) {
        self.isSecondLevel = isSecondLevel
        
    }
    
    
    //setter and getter methods for HasNewNotification variable.
    public func setHasNewNotification(_ hasNotification: Bool) {
        self.hasNewNotification = hasNotification
        
    }
    public func isFloatingBubbleInNotificationState() -> Bool {
        return hasNewNotification
    }
    
    
    //MARK:- Actions
    func addTapGestureAction() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureAction)))
    }
    
    func tapGestureAction() {
        superView?.endEditing(true)
        VFGAnalyticsHandler.trackEventForFloatingBubbleClick()
        clickAction?()
        
        guard let presentedViewController : UIViewController = self.presentedViewController else {
            VFGLogger.log("Cannot unwrap presentedViewController")
            return
        }
        startBubbleAnimations(presentedViewController: presentedViewController)
    }
    
    /**
     Start Splash Animations
     */
    public func playExpandAnimation(){
        
        guard let controller : UIViewController = presentedViewController else {
            VFGLogger.log("Cannot unwrap presentedViewController")
            return
        }
        
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        self.isHidden = true
        VFGRootViewController.shared.sideMenu.hideMenu()
        getTopViewController()?.present(controller, animated: true, completion: {
            self.LottiAnimationView.removeFromSuperview()
            
        })
        getTopViewController()?.transitioningDelegate = self
        getTopViewController()?.modalPresentationStyle = .custom
        
        
    }
    public func startBubbleAnimations(presentedViewController : UIViewController) {
        UIView.animate(withDuration: bubbleAnimationScaleDuration, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { [weak self] in
            
            guard let bubbleAnimationScaleFactor : Double = self?.bubbleAnimationScaleFactor else {
                VFGLogger.log("Cannot unwrap bubbleAnimationScaleFactor")
                return
            }
            
            self?.transform = CGAffineTransform(scaleX: CGFloat(bubbleAnimationScaleFactor), y: CGFloat(bubbleAnimationScaleFactor))
            }, completion: { (_) in
                
                self.isHidden = true
        })
        self.perform(#selector(self.playExplotionAnimation), with: self, afterDelay:0 )
        
        
        
        
    }
    public func startBubbleAnimationsWithDelay(presentedViewController : UIViewController){
        UIView.animate(withDuration: bubbleAnimationScaleDuration, delay: 0.6, options: UIViewAnimationOptions.curveEaseInOut, animations: { [weak self] in
            
            guard let bubbleAnimationScaleFactor : Double = self?.bubbleAnimationScaleFactor else {
                VFGLogger.log("Cannot unwrap bubbleAnimationScaleFactor")
                return
            }
            
            self?.transform = CGAffineTransform(scaleX: CGFloat(bubbleAnimationScaleFactor), y: CGFloat(bubbleAnimationScaleFactor))
            }, completion: { (_) in
                
                
                self.isHidden = true
        })
        self.perform(#selector(self.playExplotionAnimation), with: self, afterDelay:0 )
        
        
        
        
    }
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
    }
    
    //MARK:- Subviews
    private func addLabel() {
        
        textLabel.numberOfLines = 0
        if isSecondLevel{
            textLabel.attributedText = getLabelFormattedStringForColor(textSecondaryColor)
        }
        else{
            textLabel.attributedText = getLabelFormattedStringForColor(textColor)
        }
        textLabel.frame = self.bounds
        textLabel.sizeToFit()
        textLabel.textAlignment = .center
        self.textLabel.center = CGPoint(x: self.bounds.center.x, y: self.bounds.center.y-5)
        
        
        self.addSubview(textLabel)
    }
    private func addNotificationIcon(){
        envelopeImageViewContainer.layer.cornerRadius = envelopeImageViewContainer.frame.size.width / 2
        envelopeImageViewContainer.clipsToBounds = true
        var envelopeImage = UIImage.init()
        isSecondLevel = true
        if isSecondLevel {
            envelopeImage = notificationEnvlopeRed!
            envelopeImageViewContainer.backgroundColor = textSecondaryColor
            
            envelopeImageViewContainer.layer.borderColor = textColor.cgColor
            
        }
        else{
            envelopeImage = notificationEnvlopeWhite!
            envelopeImageViewContainer.backgroundColor = textColor
            envelopeImageViewContainer.layer.borderColor = textSecondaryColor.cgColor
            
        }
        
        envelopeImageViewContainer.layer.borderWidth = 1
        
        let envelopeImageView = UIImageView.init(image: envelopeImage)
        envelopeImageView.frame = CGRect.init(x: 0, y: 0, width: envelopeImageViewContainer.frame.size.width - 5, height: envelopeImageViewContainer.frame.size.height - 5)
        envelopeImageViewContainer.addSubview(envelopeImageView)
        envelopeImageView.frame = CGRect.init(x: envelopeImageViewContainer.frame.size.width/2 - (envelopeImageView.frame.size.width/2), y: envelopeImageViewContainer.frame.size.height/2 - (envelopeImageView.frame.size.height/2), width: envelopeImageView.frame.size.width, height: envelopeImageView.frame.size.height)
        self.addSubview(envelopeImageViewContainer)
        
        if !hasNewNotification {
            envelopeImageViewContainer.alpha = 0
        }
        envelopeImageViewContainer.frame = CGRect.init(x: 0 , y: 0, width: envelopeImageViewContainer.frame.size.width, height: envelopeImageViewContainer.frame.size.height)
        
    }
    //MARK:- Private Utils
    /* Changing UI colors for first and second levels configuration */
    private func setFirstLevelConfig() {
        
        VFGLogger.log("Setting first level config for VFGFloatingBubbleView")
        
        self.secondImageView.removeFromSuperview()
        textLabel.attributedText = getLabelFormattedStringForColor(textColor)
        updateViewWithImage(viewImage)
    }
    private func setSecondLevelConfig() {
        
        VFGLogger.log("Setting second level config for VFGFloatingBubbleView")
        
        self.secondImageView.removeFromSuperview()
        textLabel.attributedText = getLabelFormattedStringForColor(textSecondaryColor)
        updateViewWithImage(viewSecondaryImage)
    }
    
    
    
    //switch the icon to notification icon for white theme
    private func setFirstLevelConfigWithNotification() {
        VFGLogger.log("Setting first level config with Notification for VFGFloatingBubbleView")
        self.secondImageView.removeFromSuperview()
        textLabel.attributedText = getLabelFormattedStringForColor(textColor)
        updateViewWithImage(bubbleNotificationWithoutRoute)
    }
    //switch the icon to notification icon for red theme
    private func setSecondLevelConfigWithNotification() {
        VFGLogger.log("Setting second level config with Notification for VFGFloatingBubbleView")
    }
    private func updateViewWithImage(_ image: UIImage?) {
        imageView.image = image
        
        imageView.sizeToFit()
    }
    private func getLabelFormattedStringForColor(_ color: UIColor) -> NSMutableAttributedString? {
        
        guard let viewTopFont : UIFont = viewTopFont else {
            VFGLogger.log("Cannot unwrap viewTopFont")
            return nil
        }
        
        let AttrString : NSAttributedString = NSAttributedString.init(string: viewTitle, attributes: [NSFontAttributeName: viewTopFont, NSForegroundColorAttributeName: color])
        
        let paragraphStyle : NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.maximumLineHeight = 15
        paragraphStyle.alignment = .center
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        
        attrString.append(AttrString)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        return attrString
        
    }
    
    //MARK:- Action Methods
    //Adding Pan Gesture Recoginzer to Button
    private func createPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePan(recognizer:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    public func getExpectedAnimationDuration() -> Double {
        if hasNewNotification {
            return bubbleExpandDuration + bubbleChangePhotoAnimationDuration + bubbbeScaleOutAnimationDuration +  bubbleEnvelopeAnimationDuration
        }
        return bubbleExpandDuration + bubbleChangePhotoAnimationDuration + bubbbeScaleOutAnimationDuration
    }
    //Handling button dragging over the screen
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        
        guard let superView : UIView = superView else {
            VFGLogger.log("Cannot unwrap superView. Terminating handlePan()")
            return
        }
        
        guard let recognizerView : UIView = recognizer.view else {
            VFGLogger.log("Cannot unwrap recognizer.view. Terminating handlePan()")
            return
        }
        
        superView.endEditing(true)
        
        VFGLogger.log("VFGFloatingBubbleView recognizer state is " + String(recognizer.state.rawValue))
        
        if recognizer.state == .began {
            superView.isUserInteractionEnabled = false
        }
        else if recognizer.state == .ended {
            superView.isUserInteractionEnabled = true
        }
        
        let statusBarHeight: CGFloat = 20.0
        let topBarHeight: CGFloat = 44.0
        
        let translation: CGPoint = recognizer.translation(in: superView)
        
        var yToBe : CGFloat = recognizerView.frame.origin.y + translation.y
        
        VFGLogger.log("VFGFloatingBubbleView yToBe value is %f",yToBe)
        
        if yToBe < 2*statusBarHeight + topBarHeight {
            yToBe = 2*statusBarHeight + topBarHeight
        }
        else if yToBe > superView.bounds.size.height - recognizerView.frame.size.height - topBarHeight {
            yToBe = superView.bounds.size.height - recognizerView.frame.size.height - topBarHeight
        }
        recognizer.view?.frame.origin = CGPoint(x: recognizerView.frame.origin.x, y: yToBe)
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
}
