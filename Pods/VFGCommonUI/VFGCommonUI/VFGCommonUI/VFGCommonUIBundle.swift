//
//  VFGCommonUIBundle.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 17.11.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

public class VFGCommonUIBundle: NSObject {
    private static let bundleName = "VFGCommonUI"
    private static let bundleExtension = "bundle"
    
    private static let bundleIdentifier = "com.vodafone.VFGCommonUI"
    
    public static func bundle() -> Bundle? {
        let url = Bundle(for: self).url(forResource: bundleName, withExtension: bundleExtension)
        if let url = url {
            return Bundle(url: url)
        }
        return Bundle(identifier: bundleIdentifier)
    }
   public static func customBundle() -> Bundle? {
    guard let bundleString : URL = VFGCommonUIBundle.bundle()?.url(forResource: "Base", withExtension: "lproj") else {
            return nil
    }
        let bundle = Bundle.init(url: bundleString)
        return bundle
    }

}

