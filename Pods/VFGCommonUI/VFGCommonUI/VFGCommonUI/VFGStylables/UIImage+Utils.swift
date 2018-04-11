//
//  UIIMageExtension.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/9/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 *
 * Extension to UIImage to generate an image from a solid color
 */
public extension UIImage {
    public class func from(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context : CGContext = UIGraphicsGetCurrentContext() else {
            VFGLogger.log("Cannot obtain graphics context from UIImage from()")
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        guard let img : UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            VFGLogger.log("Cannot getImage from UIImage from()")
            return nil
        }
        UIGraphicsEndImageContext()
        return img
    }
}
