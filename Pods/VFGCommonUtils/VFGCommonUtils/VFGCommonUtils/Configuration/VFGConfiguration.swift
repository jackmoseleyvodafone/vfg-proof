//
//  VFGConfiguration.swift
//  VFGCommonUtils
//
//  Created by kasa on 02/11/2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import CoreData

/**
 Configuration of the CommonUtils component stored in encrypted CoreData
 */
@objc public class VFGConfiguration: NSObject {
    static fileprivate let defaultLocale : String = "en_GB"
    static fileprivate let currentLocaleKey = "CurrentLocale"
    static var loggingEnabled : Bool = true
    static public var locale : Locale! {
        get {
            guard let localeString : String  = UserDefaults.standard.string(forKey: VFGConfiguration.currentLocaleKey) else {
                return Locale.current
            }
            return Locale(identifier: localeString)
        }
        set(newLocale) {
            if newLocale == nil {
                UserDefaults.standard.removeObject(forKey: VFGConfiguration.currentLocaleKey)
            }
            else {
                UserDefaults.standard.set(newLocale.identifier, forKey: VFGConfiguration.currentLocaleKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    static var disabledComponents : Set<Bundle> = Set<Bundle>()
    
    /**
     Retrieves component configuration logging enabled state
     - parameter : component being updated. Must conform to VFGLoggingComponent protocol
     */
    public class func isLoggingEnabled(for component:Bundle) -> Bool {
            return (disabledComponents.contains(component) == false)
    }

    /**
     Sets component configuration logging to either on/off
     - parameter : to - new value 
     - parameter : component being updated. Must conform to VFGLoggingComponent protocol
     */
    public class func setLoggingEnabled(to value:Bool,for component:Bundle) {
        if value {
            disabledComponents.insert(component)
        }
        else {
            disabledComponents.remove(component)
        }
        
    }
}
