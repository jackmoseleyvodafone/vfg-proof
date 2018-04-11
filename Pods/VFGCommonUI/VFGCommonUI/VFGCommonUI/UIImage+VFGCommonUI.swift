//
//  UIImage+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 14/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 Addons to UIImage which help to use it in the application.
 */
public extension UIImage {
    
    private static let context: CIContext? = CIContext()
    
    convenience init?(fromCommonUINamed name: String) {
        self.init(named: name, in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    }
    
    var mirroredDown : UIImage? {
        get {
            return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .downMirrored).withRenderingMode(self.renderingMode)
        }
    }
    
    /**
     Image in grayscale, constructed from CIImage.
     */
    public var grayscaled : UIImage? {
        let filter = CIFilter(name: CIFilter.colorMatrixFilterName)
        let vector = GrayScaleColorWeights().vector
        
        filter?.setValue(self.ciImageRepresentation(), forKey: kCIInputImageKey)
        filter?.setValue(vector, forKey:CIFilter.inputRVectorKey)
        filter?.setValue(vector, forKey:CIFilter.inputGVectorKey)
        filter?.setValue(vector, forKey:CIFilter.inputBVectorKey)
        
        if let grayScaleImage : CIImage = filter?.outputImage,
            let cgImage = currentContext()?.createCGImage(grayScaleImage, from: grayScaleImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    /**
     Image with inverted colours, constructed from CIImage.
     */
    public var colorInverted : UIImage? {
        let filter = CIFilter(name: CIFilter.colorInvertFilterName)
        filter?.setValue(self.ciImageRepresentation(), forKey: kCIInputImageKey)
        
        if let colorInvertedImage : CIImage = filter?.outputImage,
            let cgImage = currentContext()?.createCGImage(colorInvertedImage, from: colorInvertedImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    private func ciImageRepresentation() -> CIImage? {
        if let ciImage : CIImage = self.ciImage {
            return ciImage
        }
        if let cgImage = self.cgImage {
            return CIImage(cgImage: cgImage)
        }
        
        return CIImage(image: self)
    }
    
    private func currentContext() -> CIContext? {
        
        var currentContext: CIContext?
        
        if UIImage.context != nil {
            currentContext = UIImage.context
        } else {
            currentContext = CIContext(options: nil)
        }
        
        return currentContext
    }
    
    
    /**
     Draw dotted image
     */
    static func drawDottedImage(width: CGFloat, height: CGFloat, color: UIColor) -> UIImage {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 1.0, y: 1.0))
        path.addLine(to: CGPoint(x: width, y: 1))
        path.lineWidth = 2.0
        let dashes: [CGFloat] = [path.lineWidth, path.lineWidth * 5]
        path.setLineDash(dashes, count: 1, phase: 0)
        path.lineCapStyle = .round
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 2)
        color.setStroke()
        path.stroke()
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
