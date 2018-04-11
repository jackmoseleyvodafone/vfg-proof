//
//  VFGAdobeTargetHandler.swift
//  VFGAnalytics
//
//  Created by Ehab Alsharkawy on 8/2/17.
//  Copyright © 2016 Vodafone. All rights reserved.
//
import Foundation

/**
 * 	@class VFGAdobeMobileSDKHandler
 *  This class is used for handling with the Adobe Mobile SDK.
 */

@objc public class VFGAdobeMobileSDKHandler : NSObject {
    
    public typealias adobeMobileSDKSuccessClosure = (String) -> Void
    public typealias adobeMobileSDKFailureClosure = () -> Void
    
    private static let adobeConfigFile : String = "ADBMobileConfig"
    private static let adobeConfigFileType : String = "json"
    private static let shoudlDebug : Bool = true
    /**
     *	@brief start Adobe Mobile SDK with some preferences and get visitor Marketing Cloud ID. This is a blocking call and should not be called from the main thread.
     *	@return an adobeMobileSDKSuccessClosure with Any value containing the Marketing Cloud ID
     *	@return an adobeMobileSDKFailureClosure with Any value containing  failure
     */
    public static func setup( success :  adobeMobileSDKSuccessClosure, failure: adobeMobileSDKFailureClosure) {
        
        if let filePath : String = Bundle.main.path(forResource: VFGAdobeMobileSDKHandler.adobeConfigFile, ofType: VFGAdobeMobileSDKHandler.adobeConfigFileType) {
          VFGADBMobile.overrideConfigPath(path: filePath)
        }
        
        VFGADBMobile.setDebugLogging(shouldDebug: VFGAdobeMobileSDKHandler.shoudlDebug)
        VFGADBMobile.collectLifecycleData()
        
        if let cloudID : String = VFGADBMobile.visitorMarketingCloudID() {
            VFGLogger.log("Adobe Target visitorMarketingCloudID:" + cloudID)
            success(cloudID)
        } else {
            VFGLogger.log("Adobe Target Failed")
            failure()
        }
    }
}
