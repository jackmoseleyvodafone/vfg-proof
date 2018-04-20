//
//  VFGAlertViewController.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 15.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import RBBAnimation
import VFGCommonUtils

public class VFGAlertViewController: UIViewController {
    
    static public let connectionErrorAlertTitle: String = "commonui_connection_error_alert_title".localized
    static public let connectionErrorAlertMessage: String = "commonui_connection_error_alert_message".localized
    static public let connectionErrorAlertOkTitle: String = "commonui_connection_error_alert_ok_button".localized
    
    static private let closeImage : String = "close"
    
    @IBOutlet weak var templateAlertContainerView: UIView!
    @IBOutlet weak var configurableSubview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var tertiaryButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var fadingView: UIView!
    @IBOutlet weak var titleLabelHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var primaryButtonTopConstraint: NSLayoutConstraint!
    
    internal var primaryButtonAction : (() -> Void)? = nil
    internal var secondaryButtonAction : (() -> Void)? = nil
    internal var tertiaryButtonAction : (() -> Void)? = nil
    internal var closeButtonAction : (() -> Void)? = nil
    
    private let buttonsAnimationOffset : CGFloat = 500
    private let buttonsDismissAnimationOffset : CGFloat = (UIScreen.main.bounds.size.height / 568.0) * 550
    private let contentSlideAnimationTime : TimeInterval = 0.50
    private let fadeInOutAnimationTime : TimeInterval = 0.17
    
    private let titleFontSize : CGFloat = 28
    private let messageFontSize : CGFloat = 20
    private let submessageFontSize : CGFloat = 16
    
    static internal let alertViewStoryboardName : String = "VFGAlertViewController"
    static internal let alertViewControllerStoryboardId : String = "AlertViewController"
    
    static let upwardsAnimationKey : String = "moveUpwards"
    static let downwardsAnimationKey : String = "moveDownwards"
    static let fadeAnimationKey : String = "fade"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if !UIScreen.isIpad {
            self.closeButton.tintColor = UIColor.white
            self.closeButton.setImage(UIImage(fromCommonUINamed: VFGAlertViewController.closeImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.closeButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fadingView.backgroundColor = UIColor.VFGOverlayBackground
        self.slidingView.backgroundColor = UIColor.VFGOverlayBackground
        self.view.backgroundColor = UIColor.clear
        
        self.primaryButton.setPrimaryStyle()
        
        if !self.secondaryButton.isHidden {
            self.secondaryButton.setSecondaryStyle()
        }
        
        if !self.tertiaryButton.isHidden {
            self.tertiaryButton.setTertiaryStyle()
        }
        
        if animated {
            self.titleLabel.alpha = 0
            self.closeButton.alpha = 0
            self.view.layoutIfNeeded()
            
            self.iconImageView.layer.add(self.slideAnimation(upwards: true, for:self.iconImageView), forKey: VFGAlertViewController.upwardsAnimationKey)
            self.messageLabel.layer.add(self.slideAnimation(upwards: true, for:self.messageLabel), forKey: VFGAlertViewController.upwardsAnimationKey)
            self.primaryButton.layer.add(self.slideAnimation(upwards: true, for:self.primaryButton), forKey: VFGAlertViewController.upwardsAnimationKey)
            self.slidingView.layer.add(self.slideAnimation(upwards: true, for: self.slidingView), forKey: VFGAlertViewController.upwardsAnimationKey)
            self.fadingView.layer.add(self.alphaAnimaton(toVisible: true), forKey: VFGAlertViewController.fadeAnimationKey)
            
            if !self.secondaryButton.isHidden {
                self.secondaryButton.layer.add(self.slideAnimation(upwards: true, for:self.secondaryButton), forKey: VFGAlertViewController.upwardsAnimationKey)
            }
            
            if !self.tertiaryButton.isHidden {
                self.tertiaryButton.layer.add(self.slideAnimation(upwards: true, for:self.tertiaryButton), forKey: VFGAlertViewController.upwardsAnimationKey)
            }
            
            UIView.animate(withDuration: fadeInOutAnimationTime, delay: 0, options: .curveLinear, animations: {
                self.titleLabel.alpha = 1
                self.closeButton.alpha = 1
            })
        }
        
    }
    
    /**
     This method displays full screen alert view controller with three buttons.
     This screen will be automatically dismissed after closure execution
     
     - parameter alertTitle: alert view title, can be nil.
     - parameter alertMessage: main alert message
     - parameter alertSubmessage : optional ert sub message
     - parameter primaryButtonText: primary button text
     - parameter primaryButtonAction: closure with primary button action
     - parameter secondaryButtonText: optional secondary button text
     - parameter secondaryButtonAction: optional closure with secondary button action
     - parameter tertiaryButtonText: optional tertiary button text
     - parameter tertiaryButtonAction: optional clousure with tertiary button action
     - parameter icon: optional icon image to be displayed
     */
    //Should be deprecatted soon
    //TODO : Deprecate this method
    static public func showAlert(title alertTitle: String?,
                                 alertMessage: String,
                                 alertSubmessage : String = "",
                                 primaryButtonText: String,
                                 primaryButtonAction: (() -> Void)?,
                                 secondaryButtonText: String? = nil,
                                 secondaryButtonAction: (() -> Void)? = nil,
                                 tertiaryButtonText: String? = nil,
                                 tertiaryButtonAction: (() -> Void)? = nil,
                                 closeButtonAction: (() -> Void)? = nil,
                                 icon : UIImage?) -> Void {
        
        let storyboard = UIStoryboard(name:alertViewStoryboardName, bundle: VFGCommonUIBundle.bundle())
        guard let alertViewController : VFGAlertViewController = storyboard.instantiateViewController(withIdentifier:alertViewControllerStoryboardId) as? VFGAlertViewController else {
            VFGLogger.log("Cannot cast object to VFGAlertViewController")
            return
        }
        
        let _ = alertViewController.view
        alertViewController.closeButton.isHidden = false
        alertViewController.titleLabel.text =  alertTitle
        alertViewController.messageLabel.text = alertMessage + "\n" + alertSubmessage + "\n"
        
    alertViewController.primaryButton.setTitle(primaryButtonText, for: .normal)
        alertViewController.primaryButtonAction = primaryButtonAction
        
        if secondaryButtonText == nil || secondaryButtonText!.isEmpty {
            alertViewController.secondaryButton.isHidden = true
        } else {
            alertViewController.secondaryButton.setTitle(secondaryButtonText, for: .normal)
            alertViewController.secondaryButtonAction = secondaryButtonAction
        }
        
        if tertiaryButtonText == nil || tertiaryButtonText!.isEmpty {
            alertViewController.tertiaryButton.isHidden = true
        } else {
            alertViewController.tertiaryButton.setTitle(tertiaryButtonText, for: .normal)
            alertViewController.tertiaryButtonAction = tertiaryButtonAction
        }
        
        alertViewController.closeButtonAction = closeButtonAction
        
        alertViewController.iconImageView.image = icon
        
        if let topViewController = getTopViewController() {
            topViewController.present(alertViewController, animated: false, completion: nil)
        }
    }
    
    static public func showAlert(title alertTitle: String?,
                                 alertMessage: String,
                                 alertSubmessage : String = "",
                                 primaryButtonText: String,
                                 primaryButtonAction: (() -> Void)?,
                                 secondaryButtonText: String? = nil,
                                 secondaryButtonAction: (() -> Void)? = nil,
                                 tertiaryButtonText: String? = nil,
                                 tertiaryButtonAction: (() -> Void)? = nil,
                                 closeButtonAction: (() -> Void)? = nil,
                                 icon : UIImage?,
                                 showCloseButton closeButtonVisible:Bool) -> Void {
        //forgive me god for what i have done...
        let storyboard = UIStoryboard(name:alertViewStoryboardName, bundle: VFGCommonUIBundle.bundle())
        guard let alertViewController : VFGAlertViewController = storyboard.instantiateViewController(withIdentifier:alertViewControllerStoryboardId) as? VFGAlertViewController else {
            VFGLogger.log("Cannot cast object to VFGAlertViewController")
            return
        }
        
        let _ = alertViewController.view
        alertViewController.closeButton.isHidden = !closeButtonVisible
        alertViewController.titleLabel.text =  alertTitle
        alertViewController.messageLabel.attributedText = alertViewController.formatmessage(firstMessage: alertMessage, secondMessage: alertSubmessage)
        
        alertViewController.primaryButton.setTitle(primaryButtonText, for: .normal)
        alertViewController.primaryButtonAction = primaryButtonAction
        
        if secondaryButtonText == nil || secondaryButtonText!.isEmpty {
            alertViewController.secondaryButton.isHidden = true
        } else {
            alertViewController.secondaryButton.setTitle(secondaryButtonText, for: .normal)
            alertViewController.secondaryButtonAction = secondaryButtonAction
        }
        
        if tertiaryButtonText == nil || tertiaryButtonText!.isEmpty {
            alertViewController.tertiaryButton.isHidden = true
        } else {
            alertViewController.tertiaryButton.setTitle(tertiaryButtonText, for: .normal)
            alertViewController.tertiaryButtonAction = tertiaryButtonAction
        }
        
        alertViewController.closeButtonAction = closeButtonAction
        
        alertViewController.iconImageView.image = icon
        
        if let topViewController = getTopViewController() {
            topViewController.present(alertViewController, animated: false, completion: nil)
        }
    }
    static public func showAlertWithSubView(title titleString:String?, view subview:UIView?,showCloseButton closeButtonVisible:Bool) {
        UIApplication.shared.isStatusBarHidden = true
        let storyboard = UIStoryboard(name:alertViewStoryboardName, bundle: VFGCommonUIBundle.bundle())
        guard let alertViewController : VFGAlertViewController = storyboard.instantiateViewController(withIdentifier:alertViewControllerStoryboardId) as? VFGAlertViewController else {
            VFGLogger.log("Cannot cast object to VFGAlertViewController")
            return
        }
        let _ = alertViewController.view
        alertViewController.templateAlertContainerView.isHidden = true
        alertViewController.closeButton.isHidden = !closeButtonVisible
        
        if let titleString = titleString, !titleString.isEmpty {
            alertViewController.titleLabel.text =  titleString
        } else {
            alertViewController.titleLabelTopConstraint.constant = 0
            alertViewController.titleLabelHeightConstriant.constant = 0
        }
        
        if let configurableSubview = subview {
            alertViewController.configurableSubview.isHidden = false
            alertViewController.configurableSubview.clipsToBounds = true
            configurableSubview.frame = alertViewController.configurableSubview.bounds
            alertViewController.configurableSubview.addSubview(configurableSubview)
        }
        if let topViewController = getTopViewController() {
            topViewController.present(alertViewController, animated: false, completion: nil)
        }
    }
    
    func slideAnimation(upwards: Bool, for animatedView:UIView) -> RBBTweenAnimation {
        let animation : RBBTweenAnimation = RBBTweenAnimation(keyPath:  "position.y")
        
        if (upwards) {
            animation.fromValue = NSNumber(value:Float(animatedView.frame.center.y + self.buttonsAnimationOffset))
            animation.toValue = NSNumber(value:Float(animatedView.frame.center.y))
        } else {
            animation.fromValue = NSNumber(value:Float(animatedView.frame.center.y))
            animation.toValue = NSNumber(value:Float(animatedView.frame.center.y + self.buttonsDismissAnimationOffset))
        }
        
        animation.easing = VFGCommonUIAnimations.RBBEasingFunctionEaseOutExpo
        animation.duration = self.contentSlideAnimationTime
        
        return animation
    }
    
    func alphaAnimaton(toVisible: Bool) -> RBBTweenAnimation {
        
        let animation : RBBTweenAnimation = RBBTweenAnimation(keyPath:  "opacity")
        
        if (toVisible) {
            animation.fromValue = NSNumber(value:0)
            animation.toValue = NSNumber(value:1)
        } else {
            animation.fromValue = NSNumber(value:1)
            animation.toValue = NSNumber(value:0)
        }
        
        animation.easing = VFGCommonUIAnimations.RBBEasingFunctionEaseOutExpo
        animation.duration = self.contentSlideAnimationTime
        
        return animation
    }
    
    @IBAction func primaryButtonTapped(_ sender: AnyObject) {
        self.dismissWithAnimation {
            self.primaryButtonAction?()
        }
    }
    
    @IBAction func secondaryButtonTapped(_ sender: AnyObject) {
        self.dismissWithAnimation {
            self.secondaryButtonAction?()
        }
    }
    
    @IBAction func tertiaryButtonTapped(_ sender: AnyObject) {
        self.dismissWithAnimation {
            self.tertiaryButtonAction?()
        }
    }
    
    func dismissWithAnimation(_ completionBlock:(() -> Swift.Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completionBlock)
        
        self.view.isUserInteractionEnabled = false
        
        self.iconImageView.layer.add(self.slideAnimation(upwards: false, for:self.iconImageView), forKey: VFGAlertViewController.downwardsAnimationKey)
        self.messageLabel.layer.add(self.slideAnimation(upwards: false, for:self.messageLabel), forKey: VFGAlertViewController.downwardsAnimationKey)
        self.primaryButton.layer.add(self.slideAnimation(upwards: false, for:self.primaryButton), forKey: VFGAlertViewController.downwardsAnimationKey)
        self.slidingView.layer.add(self.slideAnimation(upwards: false, for: self.slidingView), forKey: VFGAlertViewController.downwardsAnimationKey)
        
        if let configView: UIView = self.configurableSubview {
            configView.layer.add(self.slideAnimation(upwards: false, for:configView), forKey: VFGAlertViewController.downwardsAnimationKey)
        }
        
        if !self.secondaryButton.isHidden {
            self.secondaryButton.layer.add(self.slideAnimation(upwards: false, for:self.secondaryButton), forKey: VFGAlertViewController.downwardsAnimationKey)
        }
        
        if !self.tertiaryButton.isHidden {
            self.tertiaryButton.layer.add(self.slideAnimation(upwards: false, for:self.tertiaryButton), forKey: VFGAlertViewController.downwardsAnimationKey)
        }
        
        UIView.animate(withDuration: fadeInOutAnimationTime, delay: 0, options: .curveLinear, animations: {
            self.titleLabel.alpha = 0
            self.closeButton.alpha = 0
        })
        self.fadingView.layer.add(self.alphaAnimaton(toVisible: false), forKey: VFGAlertViewController.fadeAnimationKey)
        //Make the UI responsive earlier to avoid "dismiss lag"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dismiss(animated: false, completion: nil)
        }
        
        CATransaction.commit()
    }
    
    
    func formatmessage(firstMessage: String, secondMessage: String) -> NSMutableAttributedString? {
        
        let ipadFirstMessageFontSize : CGFloat =  30
        let ipadSecondMessageFontSize : CGFloat = 24
        let iphoneFirstMessageFontSize : CGFloat = UIScreen.IS_4_INCHES() ? 5 : 20
        let iphoneSecondMessageFontSize : CGFloat = UIScreen.IS_4_INCHES() ? 5 : 16
        
        
        let firstMessageFontSize : CGFloat
        let seconddMessageFontSize : CGFloat
        
        let paragraphStyle = NSMutableParagraphStyle()
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        
        if UIScreen.isPhone {
            firstMessageFontSize = iphoneFirstMessageFontSize
            seconddMessageFontSize = iphoneSecondMessageFontSize
        } else {
            firstMessageFontSize = ipadFirstMessageFontSize
            seconddMessageFontSize = ipadSecondMessageFontSize
        }
        
        guard let vodafoneFirstRegularFont : UIFont = UIFont.vodafoneRegularFont(firstMessageFontSize) else {
            VFGLogger.log("Cannot unwrap first vodafoneRegularFont")
            return attrString
        }
        #if swift(>=4.1)
        let firstAttrString: NSAttributedString = NSAttributedString(string: firstMessage, attributes: [kCTFontAttributeName as NSAttributedStringKey: vodafoneFirstRegularFont, kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white])
        #else
        let firstAttrString: NSAttributedString = NSAttributedString(string: firstMessage, attributes: [NSFontAttributeName: vodafoneFirstRegularFont, NSForegroundColorAttributeName: UIColor.white])
        #endif
        attrString.append(firstAttrString)
        
        guard let vodafoneSecondRegularFont : UIFont = UIFont.vodafoneRegularFont(seconddMessageFontSize) else {
            VFGLogger.log("Cannot unwrap second vodafoneRegularFont")
            return attrString
        }
        
        if !secondMessage.isEmpty {
            #if swift(>=4.1)
            let secondAttrString: NSAttributedString = NSAttributedString(string: "\n"+secondMessage, attributes: [kCTFontAttributeName as NSAttributedStringKey: vodafoneSecondRegularFont, kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white])
            #else
            let secondAttrString: NSAttributedString = NSAttributedString(string: "\n"+secondMessage, attributes: [NSFontAttributeName: vodafoneSecondRegularFont, NSForegroundColorAttributeName: UIColor.white])
            #endif
            attrString.append(secondAttrString)
            
        }
    
        return attrString
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismissWithAnimation {
            UIApplication.shared.isStatusBarHidden = false
            if self.closeButtonAction != nil {
                self.closeButtonAction!()
            }
        }
    }
}

