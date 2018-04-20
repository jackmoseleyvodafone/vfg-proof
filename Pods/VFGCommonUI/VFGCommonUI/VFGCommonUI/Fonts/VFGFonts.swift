//
//  VFGFonts.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 16.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

public extension UIFont {
    
    private static let regularFontFilename = "vodafone-regular"
    private static let regularFontName = "VodafoneRg-Regular"
    
    
    private static let regularLiteFontFilename = "Vodafone_Lt"
    private static let regularLiteFontName = "VodafoneLt-Regular"
    
    
    private static let boldFontFilename = "vodafone-bold"
    private static let boldFontName = "VodafoneRg-Bold"
    
    private static let fontExtension = "ttf"
    
    private static let XXXXL: CGFloat = 30
    private static let XXXL:  CGFloat = 28
    private static let XXL:   CGFloat = 24
    private static let XL:    CGFloat = 20
    private static let L:     CGFloat = 18
    private static let M:     CGFloat = 16
    private static let S:     CGFloat = 14
    
    private static func registerFont(_ fontName: String) {
        guard let bundle = VFGCommonUIBundle.bundle() else {
            return
        }
        
        guard let pathForResourceString = bundle.path(forResource: fontName, ofType: fontExtension) else {
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            return
        }
        #if swift(>=4.1)
        guard let fontRef = CGFont.init(dataProvider) else {
            return
        }
        #else
        let fontRef = CGFont.init(dataProvider)
        #endif
        var error: UnsafeMutablePointer<Unmanaged<CFError>?>?
        if(CTFontManagerRegisterGraphicsFont(fontRef,error) == false) {
            return
        }
        error = nil
    }
    
    /**
     This method provides regular Vodafone font with size XXXX-Large.
     */
    public static func VFGXXXXL() -> UIFont? {
        
        return UIFont.vodafoneRegularFont(XXXXL)
    }
    
    /**
     This method provides bold Vodafone font with size XXXX-Large.
     */
    public static func VFGXXXXLBold() -> UIFont? {
        
        return UIFont.vodafoneBoldFont(XXXXL)
    }
    
    /**
     This method provides light Vodafone font with size XXXX-Large.
     */
    public static func VFGXXXXLLight() -> UIFont? {
        
        return UIFont.vodafoneLiteRegularFont(XXXXL)
    }

    /**
     This method provides regular Vodafone font with size XXX-Large.
     */
    public static func VFGXXXL() -> UIFont? {
        
        return UIFont.vodafoneRegularFont(XXXL)
    }
    
    /**
     This method provides bold Vodafone font with size XXX-Large.
     */
    public static func VFGXXXLBold() -> UIFont? {
        
        return UIFont.vodafoneBoldFont(XXXL)
    }
    
    /**
     This method provides light Vodafone font with size XXX-Large.
     */
    public static func VFGXXXLLight() -> UIFont? {
        
        return UIFont.vodafoneLiteRegularFont(XXXL)
    }

    /**
     This method provides light Vodafone font with size XX-Large.
     */
    public static func VFGXXL() -> UIFont? {
        
        return UIFont.vodafoneRegularFont(XXL)
    }
    
    /**
     This method provides bold Vodafone font with size XX-Large.
     */
    public static func VFGXXLBold() -> UIFont? {
        
        return UIFont.vodafoneBoldFont(XXL)
    }
    
    /**
     This method provides light Vodafone font with size XX-Large.
     */
    public static func VFGXXLLight() -> UIFont? {
        
        return UIFont.vodafoneLiteRegularFont(XXL)
    }

    /**
     This method provides light Vodafone font with size X-Large.
     */
    public static func VFGXL() -> UIFont? {
        
        return UIFont.vodafoneRegularFont(XL)
    }
    
    /**
     This method provides bold Vodafone font with size X-Large.
     */
    public static func VFGXLBold() -> UIFont? {
        
        return UIFont.vodafoneBoldFont(XL)
    }
    
    /**
     This method provides light Vodafone font with size X-Large.
     */
    public static func VFGXLLight() -> UIFont? {
        
        return UIFont.vodafoneLiteRegularFont(XL)
    }

    /**
     This method provides regular Vodafone font with size Large.
     */
    public static func VFGL() -> UIFont? {
        
        return UIFont.vodafoneRegularFont(L)
    }
    
    /**
     This method provides bold Vodafone font with size Large.
     */
    public static func VFGLBold() -> UIFont? {
        
        return UIFont.vodafoneBoldFont(L)
    }
    
    /**
     This method provides light Vodafone font with size Large.
     */
    public static func VFGLLight() -> UIFont? {
        
        return UIFont.vodafoneLiteRegularFont(L)
    }
    
    /**
     This method provides regular Vodafone font with size medium.
     */
    public static func VFGM() -> UIFont? {
        
        return UIFont.vodafoneRegularFont(M)
    }
    
    /**
     This method provides bold Vodafone font with size medium.
     */
    public static func VFGMBold() -> UIFont? {
        
        return UIFont.vodafoneBoldFont(M)
    }
    
    /**
     This method provides light Vodafone font with size medium.
     */
    public static func VFGMLight() -> UIFont? {
        
        return UIFont.vodafoneLiteRegularFont(M)
    }
    
    /**
     This method provides regular Vodafone font with size small.
     */
    public static func VFGS() -> UIFont? {
        
        if UIScreen.main.bounds.size.height <= 667.0 {
            return UIFont.vodafoneRegularFont(S - 2)
        } else {
            return UIFont.vodafoneRegularFont(S)
        }
        
    }

    /**
     This method provides bold Vodafone font with size small
     */
    public static func VFGSBold() -> UIFont? {
        
        return UIFont.vodafoneBoldFont(S)
    }
    
    /**
     This method provides light Vodafone font with size small
    */
    public static func VFGSLight() -> UIFont? {
        
        return UIFont.vodafoneLiteRegularFont(S)
    }
    
    /**
     This method provides regular Vodafone font.
     
     - parameter fontSize: requested font size
     
     - returns: Customized Vodafone regular UIFont object
     
     */
    public static func vodafoneRegularFont(_ fontSize: CGFloat) -> UIFont? {
        
        var result = UIFont.init(name: regularFontName, size: fontSize)
        
        if result == nil {
            registerFont(regularFontFilename);
            result = UIFont.init(name: regularFontName, size: fontSize)
        }
        
        return result
    }
    
    /**
     This method provides regular lite Vodafone font.
     
     - parameter fontSize: requested font size
     
     - returns: Customized Vodafone lite regular UIFont object
     
     */
    public static func vodafoneLiteRegularFont(_ fontSize: CGFloat) -> UIFont? {
        
        var result = UIFont.init(name: regularLiteFontName, size: fontSize)
        
        if result == nil {
            registerFont(regularLiteFontFilename);
            result = UIFont.init(name: regularLiteFontName, size: fontSize)
        }
        
        return result
    }
    
    /**
     This method provides bold Vodafone font.
     
     - parameter fontSize: requested font size
     
     - returns: Customized Vodafone bold UIFont object
     
     */
    public static func vodafoneBoldFont(_ fontSize: CGFloat) -> UIFont? {
        
        var result = UIFont.init(name: boldFontName, size: fontSize)
        
        if result == nil {
            registerFont(boldFontFilename);
            result = UIFont.init(name: boldFontName, size: fontSize)
        }
        
        return result
    }
}
