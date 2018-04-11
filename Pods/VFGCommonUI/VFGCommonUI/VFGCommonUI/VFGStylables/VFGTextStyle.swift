//
//  VFGTextStyle.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/9/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

// Deafult font size in case font method returned nil

public class VFGTextStyle: VFGStyle {
    var textColor: UIColor
    var font: UIFont
    
    public init(textColor: UIColor, font: UIFont) {
        self.font = font
        self.textColor = textColor
    }
    
    /// Use this style for a greyish header text
    public static func headerColored(_ color: UIColor)-> VFGTextStyle{
        return VFGTextStyle(textColor: color,
                            font: UIFont.VFGXXXXL() ?? UIFont.systemFont(ofSize: 30))
    }
    
    public static func pageTitleColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGXXXXL() ?? UIFont.systemFont(ofSize: 30))
    }
    
    public static func paragraphTitleColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGXL() ?? UIFont.systemFont(ofSize: 20))
    }
    
    public static func paragraphColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGM() ?? UIFont.systemFont(ofSize: 16))
    }
    
    public static func footerColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGS() ?? UIFont.systemFont(ofSize: 14))
    }
    
    public static func cellTitleColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGXL() ?? UIFont.systemFont(ofSize: 14))
    }
    
    public static func sectionTitleColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGXXL() ?? UIFont.systemFont(ofSize: 14))
    }
    
    public static func largeSectionTitleColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGXXXL() ?? UIFont.systemFont(ofSize: 28))
    }
    
    public static func checkBoxTitleColored(_ color: UIColor) -> VFGTextStyle{
        return VFGTextStyle(textColor: color, font: UIFont.VFGL() ?? UIFont.systemFont(ofSize: 14))
    }
}
