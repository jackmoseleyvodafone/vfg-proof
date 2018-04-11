//
//  VFGTextFieldStyle.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/10/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

// Deafult font size in case font method returned nil
fileprivate let defaultSize: CGFloat = 16


public class VFGTextFieldStyle: VFGStyle{
    var textFont: UIFont
    var textColor: UIColor
    var backgroundColor: UIColor
    var borderRadius: Float
    var borderWidth: Float
    var borderColor: UIColor
    var isEnabled: Bool
    
    public init(textFont: UIFont, textColor: UIColor, backgroundColor: UIColor, borderRadius: Float, borderWidth: Float, borderColor: UIColor, isEnabled: Bool) {
        self.textFont = textFont
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.borderRadius = borderRadius
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.isEnabled = isEnabled
    }
    
    /// Use for Basic Vodafone TextField Style
    public static var basic: VFGTextFieldStyle {
        return VFGTextFieldStyle(textFont: UIFont.VFGM() ?? UIFont.systemFont(ofSize: defaultSize),
                                 textColor: UIColor.VFGBlack,
                                 backgroundColor: UIColor.VFGWhite,
                                 borderRadius: 2.6,
                                 borderWidth: 0,
                                 borderColor: UIColor.clear,
                                 isEnabled: true)
    }
    
    /// Use for Edit Fields Vodafone TextField Style
    public static var editField: VFGTextFieldStyle {
        return VFGTextFieldStyle(textFont: UIFont.VFGM() ?? UIFont.systemFont(ofSize: defaultSize),
                                 textColor: UIColor.VFGBlack,
                                 backgroundColor: UIColor.VFGWhite,
                                 borderRadius: 0,
                                 borderWidth: 1,
                                 borderColor: UIColor.VFGTurquoiseBlue,
                                 isEnabled: true)
    }
    
    /// Use for disabled Vodafone TextField Style
    public static var disabled: VFGTextFieldStyle {
        return VFGTextFieldStyle(textFont: UIFont.VFGM() ?? UIFont.systemFont(ofSize: defaultSize),
                                 textColor: UIColor.VFGWhite20,
                                 backgroundColor: UIColor.clear,
                                 borderRadius: 2.6,
                                 borderWidth: 3,
                                 borderColor: UIColor.VFGWhite20,
                                 isEnabled: false)
    }
}



