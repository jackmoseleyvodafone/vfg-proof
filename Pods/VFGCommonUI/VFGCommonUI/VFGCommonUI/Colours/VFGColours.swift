//
//  VFGColours.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 17.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation


// Containers for colours customisation
fileprivate var downloadSpeed : UIColor?
fileprivate var uploadSpeed : UIColor?
fileprivate var pingSpeed : UIColor?

// UIColor extension with Vodafone colours
public extension UIColor {
    
    /**
     Primary red colour as described in R5 design.
     */
    public static var VFGPrimaryRed : UIColor {
        get {
            return UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0)
        }
    }
    
    //
    public static var VFGWhite30 : UIColor {
        get {
            return UIColor(white: 255.0 / 255.0, alpha: 0.3)
        }
    }
    
    /**
     Primary gray colour as described in R5 design.
     */
    public static var VFGPrimaryGray : UIColor {
        get {
            return UIColor(hex:0x4A4D4E)
        }
    }
    
    /**
     Second gray colour from infrastructure palette as described in R5 design.
     */
    public static var VFGInfrastructureGray2 : UIColor {
        get {
            return UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.0)
        }
    }
    
    /**
     Third gray colour.
     */
    public static var VFGInfrastructureGray3 : UIColor {
        get {
            return UIColor(red:0.80, green:0.80, blue:0.80, alpha:1.0)
        }
    }
    
    /**
     Four gray colour.
     */
    public static var VFGInfrastructureGray4 : UIColor {
        get {
            return UIColor(red:0.4, green:0.4, blue:0.4, alpha:1.0)
        }
    }
    
    
    /**
     Background colour for common chipped view.
     */
    public static var VFGChippViewBackground : UIColor {
        get {
            return UIColor(hex:0xebebeb)
        }
    }
    
    /**
     Vodafone Rhombus red colour.
     */
    public static var VFGVodafoneRedRhombus : UIColor {
        get {
            return UIColor(red: 233.0/255.0, green: 34.0/255.0, blue: 1.0/255.0, alpha: 1.0)
        }
    }
    
    /**
     Title colour for top bar title.
     */
    public static var VFGTopBarTitleColor : UIColor {
        get {
            return UIColor.white
        }
    }
    
    /**
     Refreshable View background color.
     */
    public static var VFGRefreshableViewColor : UIColor {
        get {
            return UIColor.init(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
        }
    }
    
    /**
     Refreshable View - expandable circle view background color.
     */
    public static var VFGExpandableCircleColor : UIColor {
        get {
            return UIColor.init(red: 74/255.0, green: 77/255.0, blue: 78/255.0, alpha: 1)
        }
    }
    
    /**
     Background colour for top bar when it is not transparent.
     */
    public static var VFGTopBarBackgroundColor : UIColor {
        get {
            return UIColor.black
        }
    }
    
    /**
     Application infrastructure colour 2
     */
    public static var VFGInfrastructureColor2 : UIColor {
        get {
            return UIColor(hex: 0x999999)
        }
    }
    
    /**
     Menu background colour.
     */
    public static var VFGMenuBackground : UIColor {
        get {
            return UIColor.black.withAlphaComponent(0.9)
        }
    }
    
    /**
     Menu separator colour.
     */
    public static var VFGMenuSeparator : UIColor {
        get {
            return UIColor(hex: 0xcccccc)
        }
    }
    
    /**
     Speed checker download colour.
     */
    public static var VFGSpeedCheckerDownload: UIColor {
        get {
            if let downloadSpeed : UIColor = downloadSpeed {
                return downloadSpeed
            }
            return UIColor(red:155.0/255, green:40.0/255.0, blue:159.0/255.0, alpha:1.0)
        }
        set (newColor) {
            downloadSpeed = newColor
        }
    }
    
    /**
     Speed checker upload colour.
     */
    public static var VFGSpeedCheckerUpload: UIColor {
        get {
            if let uploadSpeed : UIColor = uploadSpeed {
                return uploadSpeed
            }
            return UIColor(red:16.0/255.0, green:175.0/255.0, blue:202.0/255.0, alpha:1.0)
        }
        set (newColor) {
            uploadSpeed = newColor
        }
    }
    
    /**
     Speed checker ping colour.
     */
    public static var VFGSpeedCheckerPing: UIColor {
        get {
            if let pingSpeed : UIColor = pingSpeed {
                return pingSpeed
            }
            return UIColor.white
        }
        set (newColor) {
            pingSpeed = newColor
        }
    }
    
    
    /**
     Speed checker History view shadow colour.
     */
    public static var VFGHistoryViewShadowColor: UIColor {
        get {
            return UIColor(hex: 0xCCCCCC)
        }
    }
    
    /**
     Swipable cell delete button colour.
     */
    public static var VFGSwipableCellRedColor: UIColor {
        get {
            return UIColor(hex: 0xBD0000)
        }
    }
    
    /**
     Scrollable TabBar enabled item colour.
     */
    public static var VFGScrollableTabBarEnabledItemTintColor : UIColor {
        get {
            return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        }
    }
    
    /**
     Scrollable TabBar selected item colour.
     */
    public static var VFGScrollableTabBarSelectedItemTintColor : UIColor {
        get {
            return UIColor(red: 230.0/255.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    
    public static var VFGOverlayDefaultRed: UIColor {
        get {
            return UIColor(hex: 0xBD0000)
        }
    }
    
    public static var VFGOverlayOnTapRed: UIColor {
        get {
            return UIColor(hex: 0xBD0000)
        }
    }
    
    public static var VFGOverlayDisabledGrey: UIColor {
        get {
            return UIColor(hex: 0x666666)
        }
    }
    
    public static var VFGOverlayDefaultSecondaryGray: UIColor {
        get {
            return UIColor(hex: 0xAFAFAF)
        }
    }
    
    public static var VFGOverlayOnTapSecondaryGray: UIColor {
        get {
            return UIColor(hex: 0xCCCCCC)
        }
    }
    
    public static var VFGOverlayDefaultTertiaryGray: UIColor {
        get {
            return UIColor(hex: 0x333333)
        }
    }
    
    public static var VFGOverlayOnTapTertiaryGray: UIColor {
        get {
            return UIColor(hex: 0x515151)
        }
    }
    
    public static var VFGOverlayBackground: UIColor {
        get {
            return UIColor(hex: 0x333333)
        }
    }
    
    
    /**
     Previous bills bar chart - in plan gradient bottom color
     */
    public static var VFGBillingBarChartDarkCyan : UIColor {
        get {
            return UIColor(hex: 0x05525D)
        }
    }
    
    /**
     Previous bills bar chart - in plan gradient top color
     */
    public static var VFGBillingBarChartCyan : UIColor {
        get {
            return UIColor(hex: 0x00B0CA)
        }
    }
    
    /**
     Previous bills bar chart - out of plan color
     */
    public static var VFGBillingBarChartPurple : UIColor {
        get {
            return UIColor(hex: 0x9C2AA0)
        }
    }
    
    /**
     Previous bills bar chart - grid labels font color
     */
    public static var VFGBillingGridPinkishGrey : UIColor {
        get {
            return UIColor(hex: 0xCCCCCC)
        }
    }
    
    /**
     Chat Border - color
     */
    public static var VFGChatBorderColor : UIColor {
        get {
            return UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        }
    }
    /**
     Chat Border - color
     */
    public static var VFGChatStartChatButtonColor : UIColor {
        get {
            return   UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        }
    }
    
    
    /**
     Initializes UIColor for given hex value.
     */
    public convenience init(hex: UInt32) {
        let value = hex & 0xffffff
        let red = (CGFloat)((value >> 16) & 0xff)/255.0
        let green = (CGFloat)((value >> 8) & 0xff)/255.0
        let blue = (CGFloat)(value & 0xff)/255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
}


// MARK: -  Colors names generated from Zeplin

extension UIColor{
    
    /**
     Color - e60000
     */
    public static var VFGRed: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    /**
     Color - ffffff
     */
    public static var VFGWhite: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - 000000
     */
    public static var VFGBlack: UIColor {
        return UIColor(white: 0.0, alpha: 1.0)
    }
    
    
    /**
     Color - 999999
     */
    public static var VFGWarmGrey: UIColor {
        return UIColor(white: 153.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - 666666
     */
    public static var VFGBrownishGrey: UIColor {
        return UIColor(white: 102.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - 102 102 102
     */
    public static var VFGBrownishDarkGrey: UIColor {
        return UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - 333333
     */
    public static var VFGBlackTwo: UIColor {
        return UIColor(white: 51.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - afafaf
     */
    public static var VFGGreyish: UIColor {
        return UIColor(white: 175.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - dbdbdb
     */
    public static var VFGWhiteTwo: UIColor {
        return UIColor(white: 219.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - cccccc
     */
    public static var VFGPinkishGrey: UIColor {
        return UIColor(white: 204.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - fafcfb
     */
    public static var VFGPaleGrey: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 252.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - bd0000
     */
    public static var VFGDeepRed: UIColor {
        return UIColor(red: 189.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    /**
     Color - 007e92
     */
    public static var VFGOcean: UIColor {
        return UIColor(red: 0.0, green: 126.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - c40c0c
     */
    public static var VFGRustyRed: UIColor {
        return UIColor(red: 196.0 / 255.0, green: 12.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
    }
    
    /**
     Color - ffffff 0.2
     */
    public static var VFGWhite20: UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 0.2)
    }
    
    /**
     Color - 5e2750
     */
    public static var VFGTurquoiseBlue : UIColor {
        get {
            return UIColor(red: 0.0 / 255.0, green: 176.0 / 255.0, blue: 202.0 / 255.0, alpha: 1.0)
        }
    }
    
    /**
     Color - 5e2750
     */
    public static var VFGGrape : UIColor {
        get {
            return UIColor(red: 94.0 / 255.0, green: 39.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
        }
    }
}

