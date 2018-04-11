//
//  Extensions.swift
//  VFGCommonUI
//
//  Created by Ehab Alsharkawy on 7/24/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.layer.add(animation, forKey: nil)
    }
    
    public func addChatBorder(color : UIColor) {
        self.clipsToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 2.0
    }
}
