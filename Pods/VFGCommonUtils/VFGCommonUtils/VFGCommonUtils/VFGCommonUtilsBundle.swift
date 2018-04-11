//
//  VFGCommonBundle.swift
//  VFGCommonUtils
//
//  Created by Michał Kłoczko on 16/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

class VFGCommonUtilsBundle: NSObject {
    internal static let bundleName = "VFGCommonUtils"
    internal static var bundleVersion = "1.0.0"
    
    private static let bundleExtension = "bundle"
    static func bundle() -> Bundle? {
        let url = Bundle(for: self).url(forResource: bundleName, withExtension: bundleExtension)
        if let url = url {
            return Bundle(url: url)
        }
        return nil
    }
}
