//
//  UILabel+LineHeight.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/15/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     Change the lineheight of the text in UILabel
     
     - Parameter lineHeight: CGFloat expressing the desired lineheight.
     */
    public func setLineHeight(lineHeight: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            #if swift(>=4.1)
            attributeString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value: style, range: NSMakeRange(0, attributeString.length))
            #else
            attributeString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, attributeString.length))
            #endif
            self.attributedText = attributeString
        }
    }
}
