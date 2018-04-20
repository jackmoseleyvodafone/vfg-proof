//
//  VFGTealiumHelper.swift
//  VFGAnalytics
//
//  Created by Ehab Alsharkawy on 8/2/17.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

open class VFGTealiumHelper : NSObject {
    
    static let TEALDataSourceKey_Autotracked : String = "autotracked"
    static let TEALDataSourceValue_False : String = "false"
    static let tealiumEnabledPlistKey : String = "TealiumEnabled"
    /**
     * Tealium command id a string value of voice of vodafone new messages
     */
    static let vovMessagesCommandIdString : String  = "vov-new-messages"
    static let vovMessagesCommandDescrptionString : String  = "vov-new-messages remote command"
    
    /**
     * Tealium command id a string value of voice of vodafone offers
     */
    static let vovOffersCommandIdString : String  = "vov-get-offers"
    static let vovOffersCommandDescrptionString : String  = "vov-get-offers remote command"
    
    static let adobeVisitorId : String = "visitor_vfmid_amcvid";
    public static let sharedInstance = VFGTealiumHelper()
    public  var tealiumInstanceID : String = ""
    private var tealiumEnabledInternal : Bool?
    
    private var trackEventCache : [(title : String, dataSources : [String:Any])] = [(String, [String:Any])]()
    private var trackViewCache : [(title : String, dataSources : [String:Any])] = [(String, [String:Any])]()
    
    let adbLockQueue = DispatchQueue(label: "VFGTealiumHelper", attributes: .concurrent)
    internal var waitingForADBMobile : Bool = true
    
    private var adobeTargetRequestQueue : OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Call Adobe Target API"
        queue.qualityOfService = .background
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private func clearCache() {
        self.trackViewCache.forEach { (cacheEntry : (title: String, dataSources: [String : Any])) in
            self.trackView(cacheEntry.title, dataSources: cacheEntry.dataSources)
        }
        self.trackViewCache.removeAll()
        
        self.trackEventCache.forEach { (cacheEntry : (title: String, dataSources: [String : Any])) in
            self.trackEvent(cacheEntry.title, dataSources: cacheEntry.dataSources)
        }
        self.trackEventCache.removeAll()
    }
    
    public var tealiumEnabled : Bool {
        get {
            if tealiumEnabledInternal == nil {
                if let fileUrl : URL = Bundle.main.url(forResource: "Info", withExtension: "plist"),
                    let data : Data = try? Data(contentsOf: fileUrl) {
                    
                    if let plistDictionary : [String: Any] = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String: Any] {
                        if let tealiumEnabled : Bool = plistDictionary[VFGTealiumHelper.tealiumEnabledPlistKey] as? Bool {
                            tealiumEnabledInternal = tealiumEnabled
                        }
                    }
                }
                
                tealiumEnabledInternal = false
            }
            return tealiumEnabledInternal!
        }
        set (newValue) {
            tealiumEnabledInternal = newValue
        }
    }
    
    public var onNewMessagesCommand : ((NSObject?) -> Void)?
    
    public var onGetOffersCommand : ((NSObject?) -> Void)?
    
    public class func startTracking(account : String, profile : String, environment : String, instanceID : String) {
        
        VFGTealiumHelper.sharedInstance.tealiumInstanceID = instanceID
        let selector : Selector = NSSelectorFromString("configurationWithAccount:profile:environment:")
    
        if let TEALConfigurationClass : AnyClass = NSClassFromString("TEALConfiguration"),
            let method : Method = class_getClassMethod(TEALConfigurationClass, selector) {
            let methodIMP : IMP! = method_getImplementation(method)
            typealias configurationWithAccountFunctionType = @convention(c)(AnyClass?,Selector,String,String,String)->NSObject?
            
            if let config : NSObject = unsafeBitCast(methodIMP,to:configurationWithAccountFunctionType.self)(TEALConfigurationClass,selector,account,profile,environment) {
                
                config.setValue(3, forKey: "logLevel")
                let selector2 : Selector = NSSelectorFromString("newInstanceForKey:configuration:")
                if let TealiumClass : AnyClass = NSClassFromString("Tealium"),
                    let method : Method = class_getClassMethod(TealiumClass, selector2) {
                    let methodIMP2 : IMP! = method_getImplementation(method)
                    
                    typealias newInstanceFunctionType = @convention(c)(AnyClass?,Selector,String,NSObject?)->NSObject?
                    if let tealiumInstance : NSObject = unsafeBitCast(methodIMP2,to:newInstanceFunctionType.self)(TealiumClass,selector,instanceID,config) {
                        tealiumInstance.setValue(VFGTealiumHelper.sharedInstance, forKey: "delegate")
                        
                        VFGTealiumHelper.sharedInstance.addAdobeCloudeQueue()
                        
                        VFGTealiumHelper.incrementLifetimeValue(tealiumInstance,key: "Launches", value: 1)
                        VFGTealiumHelper.sharedInstance.addRemoteCommandForVovMessages()
                        VFGTealiumHelper.sharedInstance.trackEvent("Launch", dataSources: [TEALDataSourceKey_Autotracked: TEALDataSourceValue_False])
                    }
                }
            }
        }
    }
    
    private func addAdobeCloudeQueue() {
        let adobeTargetOperation = BlockOperation(block: {
            VFGAdobeMobileSDKHandler.setup(success: { (cloudIdString) in
                self.adbLockQueue.sync() {
                    VFGTealiumHelper.sharedInstance.addVolatileDataSources([VFGTealiumHelper.adobeVisitorId : cloudIdString])
                    self.waitingForADBMobile = false
                }
                self.clearCache()
            }, failure:{
                self.adbLockQueue.sync() {
                    self.waitingForADBMobile = false
                }
                self.clearCache()
            })
        })
        
        VFGTealiumHelper.sharedInstance.adobeTargetRequestQueue.addOperation(adobeTargetOperation)
    }
    
    func tealiumInstanceFor(_ ID: String) -> NSObject? {
        let selector : Selector = NSSelectorFromString("instanceForKey:")
        if let TealiumClass : AnyClass = NSClassFromString("Tealium"),
            let method : Method = class_getClassMethod(TealiumClass, selector) {
            
            let methodIMP : IMP! = method_getImplementation(method)
            typealias instanceForKeyFunctionType = @convention(c)(AnyClass?,Selector,String)->NSObject
            
            return unsafeBitCast(methodIMP,to:instanceForKeyFunctionType.self)(TealiumClass,selector,ID)
        } else {
            return nil
        }
    }
    private func infoPlistDictionary() -> [String: Any]? {
        if let fileUrl : URL = Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let data : Data = try? Data(contentsOf: fileUrl) {
            
            if let plistDictionary : [String: Any] = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String: Any] {
                return plistDictionary
            }
        }
        return nil
    }
    
    func isTealiumEnabled() -> Bool {
        
        if let fileUrl : URL = Bundle.main.url(forResource: "Info", withExtension: "plist"),
            let data : Data = try? Data(contentsOf: fileUrl) {
            
            if let plistDictionary : [String: Any] = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String: Any] {
                if let tealiumEnabled : Bool = plistDictionary[VFGTealiumHelper.tealiumEnabledPlistKey] as? Bool {
                    return tealiumEnabled
                }
            }
        }
        
        return false
    }
    
    /**
     *  Copy of all non persistent, UI object and dispatch specific data sources
     *  captured by a Tealium library instance at time of call.
     *
     *  @return Dictionary of Tealium Data Source keys and values at time of call.
     */
    public func getVolatileDataSources() ->  [AnyHashable : Any]? {
        if let tealiumInstance : NSObject = self.tealiumInstanceFor(VFGTealiumHelper.sharedInstance.tealiumInstanceID) {
            let selector : Selector = NSSelectorFromString("volatileDataSourcesCopy")
            let methodIMP : IMP! = tealiumInstance.method(for: selector)
            
            typealias volatileDataSourcesCopyFunctionType = @convention(c)(Any?,Selector)->[AnyHashable : Any]
            
            return unsafeBitCast(methodIMP,to:volatileDataSourcesCopyFunctionType.self)(tealiumInstance, selector)
        }
        
        VFGLogger.log("TealiumHelper getVolatileDataSources() returns nil")
        return nil
    }
    
    /**
     *  Adds additional data to the temporary data sources dictionary. This command
     *  is added to the end of the current Tealium background queue for writing.
     *
     *  @param additionalDataSources New or overwrite data sources to add to the
     *  volatile data sources store.  These key values can only be superceded by the
     *  custom data sources added to track calls. If a value is an array, be sure to use
     *  an array of strings.
     *
     */
    public func addVolatileDataSources(_ dataSources: [String : Any]) {
        _ = self.tealiumInstanceFor(VFGTealiumHelper.sharedInstance.tealiumInstanceID)?.perform(NSSelectorFromString("addVolatileDataSources:"), with: dataSources)
    }
    
    /**
     *  Copy of all persistent, UI object and dispatch specific data sources
     *  captured by a Tealium library instance at time of call.
     *
     *  @return Dictionary of Tealium Data Source keys and values at time of call.
     */
    public func getPersistentDataSources() ->  [AnyHashable : Any]? {
        if let tealiumInstance : NSObject = self.tealiumInstanceFor(VFGTealiumHelper.sharedInstance.tealiumInstanceID) {
            let selector : Selector = NSSelectorFromString("persistentDataSourcesCopy")
            let methodIMP : IMP! = tealiumInstance.method(for: selector)
            
            typealias volatileDataSourcesCopyFunctionType = @convention(c)(Any?,Selector)->[AnyHashable : Any]
            
            return unsafeBitCast(methodIMP,to:volatileDataSourcesCopyFunctionType.self)(tealiumInstance, selector)
        }
        
        VFGLogger.log("TealiumHelper getPersistentDataSources() returns nil")
        return nil
    }
    
    /**
     *  Adds additional data to the persistent data sources dictionary.
     *
     *  @param additionalDataSources New or overwrite data sources to add to the
     *  persistent data sources store.
     *
     */
    public func addPersistentDataSources(_ dataSources: [String : Any]) {
        _ = self.tealiumInstanceFor(VFGTealiumHelper.sharedInstance.tealiumInstanceID)?.perform(NSSelectorFromString("addPersistentDataSources:"), with: dataSources)
    }
    
    // This is temporary solution. Should be removed when tealium will adjust content language based on language instead of country.
    private func tealiumLocale() -> String {
        var result : String = VFGConfiguration.locale.identifier
        
        if result.hasPrefix("el") {
            result = "el_GR"
        }
        
        return result
    }
    
    func trackEvent(_ title: String, dataSources: [String:Any]){
        self.adbLockQueue.sync {
            if self.waitingForADBMobile {
                self.trackEventCache.append((title,dataSources))
            }
            else if self.tealiumEnabled {
                VFGLogger.log("TealiumHelper did reach trackEvent")
                var dataSources = dataSources
                
                if dataSources["event_name"] == nil {
                    dataSources["event_name"] = title
                }
                
                
                _ = self.tealiumInstanceFor(VFGTealiumHelper.sharedInstance.tealiumInstanceID)?.perform(NSSelectorFromString("trackEventWithTitle:dataSources:"), with: title, with: dataSources)
            }
        }
    }
    
    func trackView(_ title: String, dataSources: [String:Any]){
        self.adbLockQueue.sync {
            if self.waitingForADBMobile {
                self.trackViewCache.append((title,dataSources))
            }
            else if self.tealiumEnabled {
                _ = self.tealiumInstanceFor(VFGTealiumHelper.sharedInstance.tealiumInstanceID)?.perform(NSSelectorFromString("trackViewWithTitle:dataSources:"), with: title, with: dataSources)
            }
        }
    }
    
    func stopTracking(){
        let selector : Selector = NSSelectorFromString("destroyInstanceForKey:")
        if let TealiumClass : AnyClass = NSClassFromString("Tealium"),
            let method : Method = class_getClassMethod(TealiumClass, selector) {
            
            let methodIMP : IMP! = method_getImplementation(method)
            
            typealias destroyInstanceForKeyFunctionType = @convention(c)(AnyClass?,Selector,String)->NSObject
            
            _ = unsafeBitCast(methodIMP,to:destroyInstanceForKeyFunctionType.self)(TealiumClass,selector,VFGTealiumHelper.sharedInstance.tealiumInstanceID)
        }
    }
}

extension VFGTealiumHelper {
    
    public func tealium(_ tealium: NSObject!, shouldDrop dispatch: NSObject!) -> Bool {
        return false
    }
    
    public func tealium(_ tealium: NSObject!, shouldQueueDispatch dispatch: NSObject!) -> Bool {
        
        if let volatileDataSources = VFGTealiumHelper.sharedInstance.getVolatileDataSources(), let _ = volatileDataSources [VFGTealiumHelper.adobeVisitorId] {
            return false
        }
        return true
    }
}

// MARK: Example Methods using other Tealium APIs
extension VFGTealiumHelper {
    class func incrementLifetimeValue(_ tealium: NSObject, key: String, value: Int) {
        var oldNumber : Int = 0
        
        let selector : Selector = NSSelectorFromString("persistentDataSourcesCopy")
        let methodIMP : IMP! = tealium.method(for: selector)
        
        typealias persistentDataSourcesCopyFunctionType = @convention(c)(Any?,Selector)->[AnyHashable : Any]
        
        let persistentData : [AnyHashable : Any] = unsafeBitCast(methodIMP,to:persistentDataSourcesCopyFunctionType.self)(tealium, selector)
        
        if let savedNumber = (persistentData[key] as AnyObject) as? NSNumber {
            
            oldNumber = Int(savedNumber)
        }
        
        let newNumber = oldNumber + value
        
        let newNumberString = NSString(format: "%i", newNumber)
        
        tealium.perform(NSSelectorFromString("addPersistentDataSources:"), with: [key:newNumberString])
        
        print("Current lifetime value for \(key) is \(newNumber)")
    }
    
    fileprivate func handleNewMessagesCommand(_ response: NSObject?) -> Void {
        VFGLogger.log("TealiumHelper did reach handleNewMessagesCommand")
        VFGTealiumHelper.sharedInstance.onNewMessagesCommand?(response)
    }
    
    fileprivate func handleGetOffersCommand(_ response: NSObject?) -> Void {
        VFGLogger.log("TealiumHelper did reach handleGetOffersCommand")
        VFGTealiumHelper.sharedInstance.onGetOffersCommand?(response)
    }
    
    func addRemoteCommand(_ commandId: String, _ commandDescription : String, _ commandHandler : (NSObject?) -> Void) {
        
        if let tealiumInstance : NSObject = self.tealiumInstanceFor(VFGTealiumHelper.sharedInstance.tealiumInstanceID) {
            let selector : Selector = NSSelectorFromString("addRemoteCommandID:description:targetQueue:responseBlock:")
            
            let methodIMP : IMP! = tealiumInstance.method(for: selector)
            
            typealias addRemoteCommandFunctionType = @convention(c)(Any?,Selector,String,String,DispatchQueue,(NSObject?)->Void )->Void
            _ = unsafeBitCast(methodIMP,to:addRemoteCommandFunctionType.self)(tealiumInstance,selector,commandId,commandDescription,DispatchQueue.main, { (response: NSObject?) -> Void in
                commandHandler(response)
            })
        }
    }
    
    public func addRemoteCommandForVovMessages() {
        self.addRemoteCommand(VFGTealiumHelper.vovMessagesCommandIdString, VFGTealiumHelper.vovMessagesCommandDescrptionString, handleNewMessagesCommand)
        self.addRemoteCommand(VFGTealiumHelper.vovOffersCommandIdString, VFGTealiumHelper.vovOffersCommandDescrptionString, handleGetOffersCommand)
    }
}
