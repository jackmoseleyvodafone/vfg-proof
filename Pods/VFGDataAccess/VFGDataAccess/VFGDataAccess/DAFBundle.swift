//
//  DAFBundle.swift
//  VFGDataAccess
//
//  Created by Mohamed Matloub on 3/27/18.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation

class VFGDAFBundle: NSObject {
    private static let bundleName = "VFGDataAccess"
    private static let bundleExtension = "bundle"
    
    private static let bundleIdentifier = "com.vodafone.VFGDataAccess"
    
    static func bundle() -> Bundle? {
        let url = Bundle(for: self).url(forResource: bundleName, withExtension: bundleExtension)
        if let url = url {
            return Bundle(url: url)
        }
        return Bundle(identifier: bundleIdentifier)
    }
    static func customBundle() -> Bundle? {
        let bundleString = VFGDAFBundle.bundle()!.url(forResource: "Base", withExtension: "lproj")
        let bundle = Bundle.init(url: bundleString!)
        return bundle
    }
    
}
