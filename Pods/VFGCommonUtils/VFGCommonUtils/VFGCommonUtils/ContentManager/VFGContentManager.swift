//
//  VFGContentManager.swift
//  VFGCommonUtils
//
//  Created by Mohamed Sayed on 13.09.17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

// Enumeration for content sources
@objc public enum ContentSource: Int {
    case local
    case dynamic
}
/**
 This is the content manager that should be used to get localized strings
 * Integration with VFGContentManager:
 * Call the init method at the component intilaization.
 * Replace calling 'NSLocalizedString' with calling this new method 'getString' from This Class
 * Please note that if remote dictionary is empty or nil, the source will be set to local automatically 💡
 */

public class VFGContentManager: NSObject {
    
    // Content Manager: Instance that will be intialized later according to type.
    private var contentSource: Content
    
    // The bundle which provide the datasource.
    public var sourceBundle: Bundle = Bundle.main {
        didSet {
            contentSource.sourceBundle = sourceBundle
        }
    }
    
    /**
     Content manager intializer
     * Please note that if remote dictionary is empty or nil, the source will be set to local automatically💡
     - Parameters:
     - remoteDictionary: dictionary loaded from the remote JSON file.
     - content: source that should be used to return the localized string
     */
    public init (withDictionary remoteDictionary: [String : String]?, andSource type: ContentSource) {
        
        let isEmptyRemoteDictionary: Bool = remoteDictionary?.isEmpty ?? true
        
        if type == .dynamic && !isEmptyRemoteDictionary {
            contentSource = DynamicContent(withDictionary: remoteDictionary)
        }
        else {
            contentSource = LocalContent()
        }
        
    }
    
    /**
     - parameter key: the key used to get the localized string
     - returns: the localized string
     */
    public func string(withKey key: String) -> String {
        return contentSource.string(withKey: key)
    }
}

// Parent Class for content management
private class Content {
    
    // The bundle which provide the datasource.
    var sourceBundle: Bundle = Bundle.main
    
    func string(withKey key: String) -> String {
        VFGLogger.log("Fallback called")
        return ""
    }
}


// Class for getting content from local localizable string
private class LocalContent: Content {
    
    override func string(withKey key: String) -> String {
        return key.localizedWithBundle(sourceBundle)
    }
}

// Class for getting content from the remote dynamic JSON file
private class DynamicContent: Content {
    
    // This Dictionary includes loaded localizations from the server
    var remoteLocalizationDictionary: Dictionary? = [String : String]()
    
    init(withDictionary remoteDictionary: [String : String]?) {
        remoteLocalizationDictionary = remoteDictionary
    }
    
    override func string(withKey key: String) -> String {
        
        if let keyString = remoteLocalizationDictionary?[key] {
            return keyString
        }
        
        return key.localizedWithBundle(sourceBundle)
    }
}
