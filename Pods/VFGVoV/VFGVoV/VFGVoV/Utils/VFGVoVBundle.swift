//
//  VFGVoVBundle.swift
//  VFGVoV
//
//  Created by Mohamed Magdy on 5/23/17.
//  Copyright © 2017 Mohamed Magdy. All rights reserved.
//

import Foundation

public class VFGVoVBundle: NSObject {
    private static let bundleName = "VFGVoV"
    private static let bundleExtension = "bundle"
    
    private static let bundleIdentifier = "com.vodafone.VFGVoV"
    
    public static func bundle() -> Bundle? {
        let url = Bundle(for: self).url(forResource: bundleName, withExtension: bundleExtension)
        if let url = url {
            return Bundle(url: url)
        }
        return Bundle(identifier: bundleIdentifier)
    }
}
