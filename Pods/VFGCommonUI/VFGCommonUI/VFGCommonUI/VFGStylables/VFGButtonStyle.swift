//
//  VFGButtonStyle.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/9/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

// Default font size in case font method returned nil
fileprivate let defaultSize: CGFloat = 18

public class VFGButtonStyle: VFGStyle {
    var textFont: UIFont
    var textColor: UIColor
    var backgroundColor: UIColor
    
    public init(textFont: UIFont, textColor: UIColor, backgroundColor: UIColor) {
        self.textFont = textFont
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    
    /// Use this style for a Primary Red colored button
    public static var primaryButton: VFGButtonStyle{
        return VFGButtonStyle(textFont: UIFont.VFGL() ?? UIFont.systemFont(ofSize: defaultSize),
                              textColor: UIColor.VFGWhite,
                              backgroundColor: UIColor.VFGRustyRed)
    }
    
    /// Use this style for a secondary light grey colored button
    public static var secondryButton: VFGButtonStyle{
        return VFGButtonStyle(textFont: UIFont.VFGL() ?? UIFont.systemFont(ofSize: defaultSize),
                              textColor: UIColor.VFGBlack,
                              backgroundColor: UIColor.VFGGreyish)
        
    }
    
    ///Use this style for a tertiary dark grey colored button
    public static var tertiaryButton: VFGButtonStyle{
        return VFGButtonStyle(textFont: UIFont.VFGL() ?? UIFont.systemFont(ofSize: defaultSize),
                              textColor: UIColor.VFGBlackTwo,
                              backgroundColor: UIColor.VFGBrownishDarkGrey)
        
    }
    
    
}
