//
//  VFGTopBarCommonView.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 24/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Top bar visible at top of the screen. Contains two buttons, left and right, and title.
 */
public class VFGTopBar: UIView {
    
    /**
     Height of top bar.
     */
    static public let topBarHeight : CGFloat = 54
    static private let horizontalMargin : CGFloat = 6
    static  let backIconImageName : String = "arrowLeft01"
    static  let menuIconImageName : String = "menu01"
    
    public internal(set) var leftButton : UIButton!
    public internal(set) var rightButton : VFGBadgeButton!
    
    @objc func onHamburgerBadgeReshresh(notification : NSNotification) {
        self.rightButton.badgeString = notification.userInfo?[VFGResponsiveUI.badgeStringKey] as? String ?? ""
        
    }
    
    /**
     Title displayed when top bar is not transparent
     */
    public var title : String? {
        get {
            return self.titleAndBackground.title
        }
        set {
            self.titleAndBackground.title = newValue
        }
    }
    
    /**
     Background color for not transparent top bar
     */
    public var opaqueBackgroundColor : UIColor? {
        get {
            return self.titleAndBackground.backgroundColor
        }
        set {
            self.titleAndBackground.backgroundColor = newValue
        }
    }
    
    /**
     Alpha value of top bar header and background
     */
    public var opaqueBackgroundAlpha : CGFloat {
        get {
            return self.titleAndBackground.alpha
        }
        set {
            if VFGRootViewController.shared.nudgeView.isHidden == false {
                self.titleAndBackground.alpha = 0
                VFGRootViewController.shared.nudgeView.layer.zPosition = 100.0
               
                
            }else{
                self.titleAndBackground.alpha = newValue
                 VFGRootViewController.shared.nudgeView.layer.zPosition = 0.0
            }
        }
    }
    
    
   
    
    private var titleAndBackground : VFGTopBarTitleAndBackgroundView!
    
    /**
     Standard initialiser as in UIView
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        NotificationCenter.default.addObserver(self, selector:#selector(VFGTopBar.onHamburgerBadgeReshresh), name: VFGResponsiveUI.onBadgeReshreshNotification, object: nil)
    }

    /**
     Standard initialiser as in UIView
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        NotificationCenter.default.addObserver(self, selector:#selector(VFGTopBar.onHamburgerBadgeReshresh), name: VFGResponsiveUI.onBadgeReshreshNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: VFGResponsiveUI.onBadgeReshreshNotification, object: nil)
    }
    
    private func setupView() {
        self.setupBarBackground()
        self.setupBarButtons()
    }
    
    private func setupBarBackground() {
        let barBackground : VFGTopBarTitleAndBackgroundView  = VFGTopBarTitleAndBackgroundView(frame: self.bounds)
        barBackground.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        barBackground.backgroundColor = UIColor.VFGTopBarBackgroundColor
        self.addSubview(barBackground)
        self.titleAndBackground = barBackground
        self.titleAndBackground.alpha = 0
    }
    
    private func setupBarButtons() {
        self.leftButton = self.buttonWithImage(named: VFGTopBar.backIconImageName)
        self.addSubview(self.leftButton)
        
        guard let badgeButton : VFGBadgeButton = self.buttonWithImage(named: VFGTopBar.menuIconImageName, customButtonClass: VFGBadgeButton.self) as? VFGBadgeButton else {
            VFGLogger.log("Cannot cast data to VFGBadgeButton")
            return
        }
        
        self.rightButton = badgeButton
        self.addSubview(self.rightButton)
    }
    
    private func buttonWithImage(named: String, customButtonClass: UIButton.Type = UIButton.self ) -> UIButton {
        let image : UIImage? = UIImage(named: named, in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
        let button : UIButton = customButtonClass.init(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.frame = CGRect(x: 0, y: 0, width: VFGTopBar.topBarHeight, height: VFGTopBar.topBarHeight)
        
        return button;
    }
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: VFGTopBar.topBarHeight)
    }
    
    /**
     Standard layoutSubviews
     */
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutLeftItem()
        self.layoutRightItem()
    }
    
    private func layoutLeftItem() {
        var frame : CGRect = self.leftButton.bounds
        frame.origin.x = VFGTopBar.horizontalMargin
        frame.origin.y = self.bounds.size.height/2 - frame.size.height/2 + 2
        self.leftButton.frame = frame;
    }
    
    private func layoutRightItem() {
        var frame : CGRect = self.rightButton.bounds
        frame.origin.x = self.bounds.size.width - VFGTopBar.horizontalMargin - frame.size.width
        frame.origin.y = self.bounds.size.height/2 - frame.size.height/2 + 2
        self.rightButton.frame = frame;
    }
    
}
    
