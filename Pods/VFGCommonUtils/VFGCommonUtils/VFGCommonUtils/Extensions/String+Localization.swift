//
//  String+Localization.swift
//  VFGCommonUtils
//
//  Created by Ahmed Naguib on 9/18/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation


/**
 Extension which provides localized strings
 */
public extension String {
    
    /**
     This method returns localized strings from main or component bundle.
     
     - parameter bundle: component bundle which should contain base translation.
     - returns: translation from main application bundle or base version from component bundle.
     */
    public func localizedWithBundle(_ bundle : Bundle) -> String {
                
        let missingKeyValue : String = "//VFGMissingKey!!!"
        let tableName : String? = bundle.bundleIdentifier?.components(separatedBy: ".").last
        let result : String = NSLocalizedString(self, tableName: tableName, bundle: Bundle.main, value: missingKeyValue, comment: "")
        
        if result != missingKeyValue {
            return result
        }
        
        return NSLocalizedString(self,  tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
