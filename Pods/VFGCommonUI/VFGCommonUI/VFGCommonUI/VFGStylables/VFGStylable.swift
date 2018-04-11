//
//  VFGStylable.swift
//  ExtenstionsApp
//
//  Created by Michael Attia on 8/8/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import Foundation
import UIKit

/**
 *
 * Conform to VFGStylable protocol to make a UI Component Stylable
 */

public protocol VFGStylable: class {
    
    associatedtype Style: VFGStyle
    func applyStyle(_ style:  Style)
}

/**
 *
 * A constraint Protocl for Different Styles
 */

public protocol VFGStyle {
    
}

//MARK: - UILabel Extension conforming to VFGStylable
extension UILabel: VFGStylable{
    public func applyStyle(_ style: VFGTextStyle) {
        self.font = style.font
        self.textColor = style.textColor
    }
}

//MARK: - UILabel Extension conforming to VFGStylable
extension UIButton: VFGStylable{
    public func applyStyle(_ style: VFGButtonStyle) {
        self.titleLabel?.font = style.textFont
        self.setTitleColor(style.textColor, for: .normal)
        self.setTitleColor(style.textColor, for: .selected)
        self.setTitleColor(style.textColor, for: .highlighted)
        self.setBackgroundImage(UIImage.from(color: style.backgroundColor), for: .normal)
    }
}

//MARK: - UITextField Extension conforming to VFGStylable
extension UITextField: VFGStylable{
    public func applyStyle(_ style: VFGTextFieldStyle) {
        self.font = style.textFont
        self.textColor = style.textColor
        self.backgroundColor = style.backgroundColor
        self.borderStyle = .none
        self.layer.borderColor = style.borderColor.cgColor
        self.layer.borderWidth = CGFloat(style.borderWidth)
        self.layer.cornerRadius = CGFloat(style.borderRadius)
        self.layer.masksToBounds = true
    }
}


