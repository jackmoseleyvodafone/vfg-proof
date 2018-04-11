//
//  CIFilter+VFGCommonUI.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 30/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

struct GrayScaleColorWeights {
    //Values based on http://stackoverflow.com/questions/687261/converting-rgb-to-grayscale-intensity
    let red : CGFloat = 0.2989 * 0.85
    let green : CGFloat = 0.5870 * 0.85
    let blue : CGFloat = 0.1140 * 0.85

    var vector : CIVector {
        return CIVector(x: self.red, y: self.green, z: self.blue)
    }

}

extension CIFilter {
    static let colorMatrixFilterName : String = "CIColorMatrix"
    static let colorInvertFilterName : String = "CIColorInvert"
    static let inputRVectorKey : String = "inputRVector"
    static let inputGVectorKey : String = "inputGVector"
    static let inputBVectorKey : String = "inputBVector"

    convenience init?(grayScaleForImage image: CIImage?) {
        if let image : CIImage = image {
            let parameters : [String : Any] = [
                kCIInputImageKey : image,
                CIFilter.inputRVectorKey : GrayScaleColorWeights().vector,
                CIFilter.inputGVectorKey : GrayScaleColorWeights().vector,
                CIFilter.inputBVectorKey : GrayScaleColorWeights().vector,
                ]
            self.init(name: CIFilter.colorMatrixFilterName, withInputParameters:parameters)
        } else {
            return nil
        }
    }

    convenience init?(colorInvertedForImage image: CIImage?) {
        if let image : CIImage = image {
            let parameters : [String : Any] = [kCIInputImageKey : image]
            self.init(name: CIFilter.colorInvertFilterName, withInputParameters:parameters)
        } else {
            return nil
        }
    }

}
