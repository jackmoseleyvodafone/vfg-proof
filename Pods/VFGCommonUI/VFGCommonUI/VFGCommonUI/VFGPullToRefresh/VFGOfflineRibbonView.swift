//
//  VFGOfflineRibbonView.swift
//  VFGCommonUI
//
//  Created by MOBICAMX38 on 1/31/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/*
 *  Constants used for the RibbonView based on the RefreshableView from VFGPullToRefreshControl and Design specifications
 */
fileprivate enum Constants {

    enum View {
        static let heightZero:CGFloat = 0.0
        static let height:CGFloat = 51
        static let width:CGFloat = UIScreen.main.bounds.width
        static let visibleAlpha:CGFloat = 1.0
        static let hiddenAlpha: CGFloat = 0.0
        static let hideRibbonDelay: Double = 3.0
        static let showRibbonAnimationDuration: TimeInterval = 0.2
        
        enum Animation {
            enum SuccessTick {
                static let duration: Double = 0.69
            }
        }
        
        enum ErrorIcon {
            static let x = 16
            static let y = 11
            static let width = 29
            static let height = 29
            static let imageName = "errorCircle"
            static let leadingDistance = 16
            static let topDistance = 11
            
            enum Animation: String {
                case successTickOffline = "offline_success_tick_green.json"
                static let scaleX_transformation: CGFloat = 1.5
                static let scaleY_transformation: CGFloat = 1.5
                
                static func composition(for animation: Animation) -> LOTComposition? {
                    guard let bundle = VFGCommonUIBundle.bundle() else {
                        return .none
                    }
                    return LOTComposition(name: animation.rawValue, bundle: bundle)
                }
            }
        }
        enum RefreshArrow {
            static let x = 332
            static let y = 14
            static let width = 29
            static let height = 23
            static let imageName = "refresh"
            static let trailingDistance = 14
            static let topDistance = 14
        }
        enum NetworkStatus {
            static let x = 52
            static let y = 20
            static let width = 81
            static let height = 12
            static let trailingDistance = 7
            static let topDistance = 15
            static let offlineText = "You're offline"
            static let onlineText = "You're back online"
        }
        enum LastUpdate {
            static let x = 203
            static let y = 20
            static let width = 123
            static let height = 13
            static let trailingDistance = 16
            static let topDistance = 16
        }
        enum ShakeAnimation {
            static let offset: CGFloat = 4.0
            static let duration: Double = 0.05
            static let repeatCount: Float = 2
            static let keyPath = "position"
        }
    }
}

protocol VFGOfflineRibbonDelegate: class {
    func offlineRibbonWillDisappear()
    func offlineRibbonWillAppear()
}

class VFGOfflineRibbonView: UIView {
    
    fileprivate(set) lazy var animationView: LOTAnimationView = {
        return LOTAnimationView()
    }()
    
    var heightConstraint:NSLayoutConstraint
    var refreshIcon: UIImageView
    var offlineMessage: UILabel
    var lastUpdateMessage: UILabel
    var failureMessageText: String = "Amer Error Occurred" {
        didSet {
            offlineMessage.text = failureMessageText
        }
    }
    weak var delegate: VFGOfflineRibbonDelegate?
    var offlineCurrentlyShown: Bool = false
    
    required init() {
        
        self.heightConstraint = NSLayoutConstraint.init()
        refreshIcon = UIImageView.init(image: UIImage(named: Constants.View.RefreshArrow.imageName, in: Bundle(for: type(of: self)), compatibleWith: nil))
        offlineMessage = UILabel.init(frame: CGRect(x: Constants.View.NetworkStatus.x,
                                                    y: Constants.View.NetworkStatus.y,
                                                    width: Constants.View.NetworkStatus.width,
                                                    height: Constants.View.NetworkStatus.height))
        lastUpdateMessage = UILabel.init(frame: CGRect(x: Constants.View.LastUpdate.x,
                                                       y: Constants.View.LastUpdate.y,
                                                       width: Constants.View.LastUpdate.width,
                                                       height: Constants.View.LastUpdate.height))
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: Constants.View.width,
                                 height: Constants.View.height))
        self.clipsToBounds = true
        self.alpha = Constants.View.hiddenAlpha
        
        self.backgroundColor = UIColor.VFGBlack
        
        animationView = LOTAnimationView.init(frame: CGRect(x: Constants.View.ErrorIcon.x,
                                                            y: Constants.View.ErrorIcon.y,
                                                            width: Constants.View.ErrorIcon.width,
                                                            height: Constants.View.ErrorIcon.height))
        
        animationView.backgroundColor = UIColor.init(patternImage: UIImage(named: Constants.View.ErrorIcon.imageName,
                                                                           in: Bundle(for: type(of: self)),
                                                                           compatibleWith: nil)!)
        animationView.contentMode = UIViewContentMode.scaleAspectFill
        
        refreshIcon.contentMode = UIViewContentMode.scaleAspectFit
        refreshIcon.frame = CGRect(x: Constants.View.RefreshArrow.x,
                                   y: Constants.View.RefreshArrow.y,
                                   width: Constants.View.RefreshArrow.width,
                                   height: Constants.View.RefreshArrow.height)
        
        offlineMessage.text = Constants.View.NetworkStatus.offlineText
        offlineMessage.textAlignment = NSTextAlignment.left
        offlineMessage.font = UIFont.VFGM()
        offlineMessage.textColor = UIColor.VFGWhite
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let parent = superview, let grandparent = superview?.superview else { return }

        self.autoPinEdge(.bottom, to: .top, of: parent)
        self.heightConstraint = self.autoSetDimension(.height, toSize: Constants.View.heightZero)
        self.heightConstraint.priority = 1000

        self.autoPinEdge(.trailing, to: .trailing, of: grandparent, withOffset: Constants.View.ShakeAnimation.offset)
        self.autoPinEdge(.leading, to: .leading, of: grandparent, withOffset: -Constants.View.ShakeAnimation.offset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) is not implemented.")
    }
    
    // Added failureMessage to enable showing an error message for 3 seconds
    open func showOfflineRibbon(withMessage message: String, failureMessage: String? = nil) {
        
        animationView.transform = CGAffineTransform.identity
        lastUpdateMessage.alpha = Constants.View.visibleAlpha
        refreshIcon.alpha = Constants.View.visibleAlpha
        //If there's failure message, show the error
        if let failureMsg = failureMessage {
            offlineCurrentlyShown = false
            offlineMessage.text = failureMsg
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.manageRibbon(usingAlpha: Constants.View.hiddenAlpha)
            })
        } else {
            offlineCurrentlyShown = true
            offlineMessage.text = Constants.View.NetworkStatus.offlineText
        }
        
        lastUpdateMessage.attributedText = buildRefreshTimeStamp(usingTimeStamp: message)
        
        animationView.sceneModel = LOTComposition.init(name: "")
        animationView.backgroundColor = UIColor.init(patternImage: UIImage(named: Constants.View.ErrorIcon.imageName,
                                                                           in: Bundle(for: type(of: self)),
                                                                           compatibleWith: nil)!)
        self.heightConstraint.constant = Constants.View.height
        manageRibbon(usingAlpha: Constants.View.visibleAlpha)
    }
    
    open func showOnlineRibbon() {
        if offlineCurrentlyShown {
            offlineCurrentlyShown = false
            lastUpdateMessage.alpha = Constants.View.hiddenAlpha
            refreshIcon.alpha = Constants.View.hiddenAlpha
            animationView.backgroundColor = UIColor.clear
            offlineMessage.text = Constants.View.NetworkStatus.onlineText
            
            animationView.sceneModel = Constants.View.ErrorIcon.Animation.composition(for: .successTickOffline)
            animationView.transform = CGAffineTransform(scaleX: Constants.View.ErrorIcon.Animation.scaleX_transformation,
                                                        y: Constants.View.ErrorIcon.Animation.scaleY_transformation)
            
            animationView.loopAnimation = false
            animationView.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.View.hideRibbonDelay, execute: { [weak self] in
                guard let `self` = self else { return }
                self.manageRibbon(usingAlpha: Constants.View.hiddenAlpha)
            })
        }
    }
    
    private func manageRibbon(usingAlpha viewAlpha: CGFloat) {
        
        UIView.animate(withDuration: Constants.View.showRibbonAnimationDuration,
            animations: { [weak self] in
                guard let `self` = self else { return }

                self.alpha = viewAlpha
                self.layoutIfNeeded()
            },
            completion: { _ in
                
                if viewAlpha == Constants.View.visibleAlpha {
                    self.delegate?.offlineRibbonWillAppear()
                }
                else {
                    self.delegate?.offlineRibbonWillDisappear()
                }
            }
        )
    }
    
    private func buildRefreshTimeStamp(usingTimeStamp timeStamp: String) -> NSAttributedString {
        
        let message: String = "Last updated: " + timeStamp
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: message)

        let prefixColorAttributes = [NSForegroundColorAttributeName : UIColor.VFGGreyish]
        let suffixColorAttributes = [NSForegroundColorAttributeName : UIColor.VFGWhite]
        
        let fontRange: NSRange = (message as NSString).range(of: message)
        let prefixMessageRange: NSRange = (message as NSString).range(of: "Last updated:")
        let suffixMessageRange: NSRange = (message as NSString).range(of: timeStamp, options: .backwards)
        
        attributedString.addAttributes([NSFontAttributeName : UIFont.VFGS() as Any], range: fontRange)
        attributedString.addAttributes(prefixColorAttributes, range: prefixMessageRange)
        attributedString.addAttributes(suffixColorAttributes, range: suffixMessageRange)
        
        return attributedString
    }
    
    func setErrorIcon() {
        self.addSubview(animationView)

        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: animationView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.ErrorIcon.leadingDistance)))
        
        self.addConstraint(NSLayoutConstraint(item: animationView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.ErrorIcon.topDistance)))
        
        self.addConstraint(NSLayoutConstraint(item: animationView,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .width,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.ErrorIcon.width)))
        
        self.addConstraint(NSLayoutConstraint(item: animationView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.ErrorIcon.height)))
    }
    func setRefreshIcon() {
        
        self.addSubview(refreshIcon)
        
        refreshIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .trailingMargin,
                                              relatedBy: .equal,
                                              toItem: refreshIcon,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.RefreshArrow.trailingDistance)))
        
        self.addConstraint(NSLayoutConstraint(item: refreshIcon,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.RefreshArrow.topDistance)))
        
        self.addConstraint(NSLayoutConstraint(item: refreshIcon,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .width,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.RefreshArrow.width)))
        
        self.addConstraint(NSLayoutConstraint(item: refreshIcon,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.RefreshArrow.height)))
    }
    func setOfflineMessage() {
        
        self.addSubview(offlineMessage)
        
        offlineMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: offlineMessage,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: animationView,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.NetworkStatus.trailingDistance)))
        
        self.addConstraint(NSLayoutConstraint(item: offlineMessage,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.NetworkStatus.topDistance)))
    }
    func setLastUpdateMessage() {
        
        self.addSubview(lastUpdateMessage)
        
        lastUpdateMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: refreshIcon,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: lastUpdateMessage,
                                              attribute: .trailing,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.LastUpdate.trailingDistance)))
        
        self.addConstraint(NSLayoutConstraint(item: lastUpdateMessage,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: CGFloat(Constants.View.LastUpdate.topDistance)))
    }
    
    internal func shake() {
        let animation = CABasicAnimation(keyPath: Constants.View.ShakeAnimation.keyPath)
        animation.duration = Constants.View.ShakeAnimation.duration
        animation.repeatCount = Constants.View.ShakeAnimation.repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - Constants.View.ShakeAnimation.offset, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + Constants.View.ShakeAnimation.offset, y:self.center.y))
        layer.add(animation, forKey: Constants.View.ShakeAnimation.keyPath)
    }
}


// MARK: - Helpers

extension VFGOfflineRibbonView {
    var isVisible: Bool {        
        return self.heightConstraint.constant != 0.0
    }
}







