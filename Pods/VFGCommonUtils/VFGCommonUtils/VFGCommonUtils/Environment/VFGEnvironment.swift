//
//  VFGEnvironment.swift
//  VFGCommonUtils
//
//  Created by kasa on 18/01/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

@objc public class VFGEnvironment: NSObject {
    
    /**
     Dictionary of registered group components. Use component name as a key and version as value. (eg. "VFGCommon" : "1.0.0")
    */
    static public var registeredComponents : [String : String] = [VFGCommonUtilsBundle.bundleName : VFGCommonUtilsBundle.bundleVersion]

    /**
     Determines whether application is running on Simulator.

     @return Bool value
     */
    static public func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR == 1
    }
    
}
