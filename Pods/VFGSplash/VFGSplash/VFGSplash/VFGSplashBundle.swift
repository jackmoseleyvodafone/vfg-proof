//
//  VFGSplashBundle.swift
//  VFGSplash
//
//  Created by Ahmed Naguib on 12/7/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

class VFGSplashBundle: NSObject {

    private static let bundleName = "VFGSplash"
    private static let bundleExtension = "bundle"

    private static let bundleIdentifier = "com.vodafone.VFGSplash"

    static func bundle() -> Bundle? {
        let url = Bundle(for: self).url(forResource: bundleName, withExtension: bundleExtension)
        if let url = url {
            return Bundle(url: url)
        }
        return Bundle(identifier: bundleIdentifier)
    }
}
