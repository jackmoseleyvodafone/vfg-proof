//
//  VFGADBMobile.swift
//  VFGAnalytics
//
//  Created by Ehab Alsharkawy on 8/2/17.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

/**
 * 	@brief An enum type.
 *  ADBMobil eClass Selectors
 */
fileprivate enum ADBMobileClassSelector : String {
    case overrideConfigPath = "overrideConfigPath:"
    case setDebugLogging = "setDebugLogging:"
    case collectLifecycleData = "collectLifecycleData"
    case visitorMarketingCloudID = "visitorMarketingCloudID"
}

/**
 * 	@class VFGADBMobile
 *  This class is used for interaction with the Adobe Mobile SDK in runtime.
 */
internal struct VFGADBMobile {
    private static let ADBMobileClassName : String = "ADBMobile"
    
    /**
     *	@brief allows one-time override of the path for the json config file
     *	@note This *must* be called prior to AppDidFinishLaunching has completed and before any other interactions with the Adobe Mobile library have happened.
     *		Only the first call to this function will have any effect.
     */
    internal static func overrideConfigPath(path : String) {
        if let ADBMobileClass : AnyClass = NSClassFromString(VFGADBMobile.ADBMobileClassName) {
            let selector : Selector = NSSelectorFromString(ADBMobileClassSelector.overrideConfigPath.rawValue)
            let implementation : IMP! = method_getImplementation(class_getClassMethod(ADBMobileClass, selector))
            typealias newInstanceFunctionType = @convention(c)(AnyClass?,Selector,String)-> Void
            _ =  unsafeBitCast(implementation,to:newInstanceFunctionType.self)(ADBMobileClass,selector,path)
        }
    }
    
    /**
     * 	@brief Sets the preference of debug log output.
     *  @param debug a bool value indicating the preference for debug log output.
     */
    internal static func setDebugLogging(shouldDebug : Bool? = true) {
        if let ADBMobileClass : AnyClass = NSClassFromString(VFGADBMobile.ADBMobileClassName) {
            let selector : Selector = NSSelectorFromString(ADBMobileClassSelector.setDebugLogging.rawValue)
            let implementation : IMP! = method_getImplementation(class_getClassMethod(ADBMobileClass, selector))
            typealias newInstanceFunctionType = @convention(c)(AnyClass?,Selector, Bool)-> Void
            _ =  unsafeBitCast(implementation,to:newInstanceFunctionType.self)(ADBMobileClass,selector, shouldDebug!)
        }
    }
    
    /**
     * 	@brief Begins the collection of lifecycle data.
     *  @note This should be the first method called upon app launch.
     */
    internal static func collectLifecycleData() {
        if let ADBMobileClass : AnyClass = NSClassFromString(VFGADBMobile.ADBMobileClassName) {
            let selector : Selector = NSSelectorFromString(ADBMobileClassSelector.collectLifecycleData.rawValue)
            let implementation : IMP! = method_getImplementation(class_getClassMethod(ADBMobileClass, selector))
            typealias newInstanceFunctionType = @convention(c)(AnyClass?,Selector)-> Void
            _ =  unsafeBitCast(implementation,to:newInstanceFunctionType.self)(ADBMobileClass,selector)
        }
    }
    
    /**
     *	@brief Retrieves the Marketing Cloud Identifier from the Visitor ID Service
     *	@return an NSString value containing the Marketing Cloud ID
     *	@note This method can cause a blocking network call and should not be used from a UI thread.
     */
    internal static func visitorMarketingCloudID() -> String? {
        if let ADBMobileClass : AnyClass = NSClassFromString(VFGADBMobile.ADBMobileClassName) {
            let selector : Selector = NSSelectorFromString(ADBMobileClassSelector.visitorMarketingCloudID.rawValue)
            let implementation : IMP! = method_getImplementation(class_getClassMethod(ADBMobileClass, selector))
            typealias newInstanceFunctionType = @convention(c)(AnyClass?,Selector)-> NSString?
            if let cloudID = unsafeBitCast(implementation,to:newInstanceFunctionType.self)(ADBMobileClass,selector) as String? {
                return cloudID
            }
            return nil
        }
        return nil
    }
}
