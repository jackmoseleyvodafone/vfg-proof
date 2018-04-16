//
//  CacheManager.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 6/15/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import Cache
import VFGCommonUtils

public final class CacheManager: NSObject {
    internal static let cacheForEver:TimeInterval = 60
    internal static var cache = SpecializedCache<JSON>(name: "JSONCache")
    private static let shared = CacheManager()
    private var cacheEnabled : Bool = true {
        didSet {
            if !cacheEnabled{
                clearDisk()
                CacheManager.cache = SpecializedCache<JSON>(name: "JSONCache")
            }
        }
    }
    private var cachedApisKeys = [DafServiceNames.customerParty, DafServiceNames.billingHistory, DafServiceNames.billingData]
    internal static var expirationTimeDec = [DafServiceNames:TimeInterval]()
    
    private override init() {
    }
    
    func clearExpired() {
        do {
            try CacheManager.cache.clearExpired()
        }catch {
            VFGLogger.log("Couldn't clear expired object")

        }
    }
    
    func shouldEnableCaching(enabled:Bool) {
        self.cacheEnabled = enabled
        
    }
    
    public func clearDisk() {
        CacheManager.cache.async.clear() { error in
            if let error = error {
                VFGLogger.log("failed to clear cache \(error)")

            }
            else {
                VFGLogger.log("cache cleared successfully")

            }
        }
    }
    
    public func isCacheEnabled() -> Bool{
        return cacheEnabled
    }
    
    public static func getCacheManager() -> CacheManager{
        shared.clearExpired()
        return .shared
    }
    
    public func enableCacheForService(url: String){}
    public func getCacheForService(url: String){}
    public func clearCacheForService(url: String){}
    
    public func enableCacheForService(serviceName: DafServiceNames){
        cachedApisKeys.append(serviceName)
    }
    
    public func disableCacheForService(serviceName: DafServiceNames) {
        if let index : Int = cachedApisKeys.index(of: serviceName) {
            cachedApisKeys.remove(at: index)
            CacheManager.removeCacheForService(serviceName: serviceName)
        }
    }
    
    public func setCacheExpireTimeForService(serviceName: DafServiceNames, expireAfter:TimeInterval?){
        if expireAfter != nil {
            CacheManager.expirationTimeDec[serviceName] = expireAfter
        }else{
            if CacheManager.expirationTimeDec[serviceName] != nil {
                CacheManager.expirationTimeDec.removeValue(forKey: serviceName)
            }
        }
    }
    
    
    public func getCacheForService(serviceName: DafServiceNames){}
    public func clearCacheForService(serviceName: DafServiceNames){}
    public func getCacheSizeByMode(cacheMode: CacheMode){}
    
    func shouldSaveInCache(key: DafServiceNames) -> Bool {
        return cachedApisKeys.index(of: key) != nil
    }
    
    func cacheJsonObject (json: [String : AnyObject], serviceName:DafServiceNames){
        CacheManager.cacheJsonObject (json: json, serviceName:serviceName)
    }
    
    func getCachedObject (serviceName:DafServiceNames, success: @escaping (Any?) -> Void, faiulre: @escaping (Any?) -> Void) {
        CacheManager.getCachedObject (serviceName:serviceName, success: success, faiulre: faiulre  )
    }
    
    func cacheJsonArray (jsonArray: [[String : AnyObject]] ,serviceName:DafServiceNames){
        CacheManager.cacheJsonArray (jsonArray: jsonArray, serviceName:serviceName)
    }
    
    func getCachedArray (serviceName:DafServiceNames, success: @escaping (Any?) -> Void, faiulre: @escaping (Any?) -> Void) {
        CacheManager.getCachedArray (serviceName:serviceName, success: success, faiulre: faiulre  )
    }
    
}

internal extension CacheManager {
    
    internal static func cacheJsonObject (json: [String : Any], serviceName:DafServiceNames){
        
        if let expireForService =  expirationTimeDec[serviceName] {
            cache.async.addObject(
                JSON.dictionary(json),
                forKey: serviceName.rawValue,
                expiry: .seconds(expireForService)
            )
        }else{
            cache.async.addObject(
                JSON.dictionary(json),
                forKey: serviceName.rawValue,
                expiry: .seconds(cacheForEver)
            )
        }
    }
    
    internal static func getCachedObject (serviceName:DafServiceNames, success: @escaping (Any?) -> Void ,  faiulre: @escaping (Any?) -> Void) {
        cache.async.object(forKey:  serviceName.rawValue) { json in
            if json == nil {
                faiulre(json?.object)
            } else {
                success(json?.object)
            }
            print(json?.object ?? "test")
        }
    }
    
    
    internal static func cacheJsonArray (jsonArray: [[String : Any]] ,serviceName:DafServiceNames){
        if let expireForService =  expirationTimeDec[serviceName] {
            cache.async.addObject(
                JSON.array(jsonArray),
                forKey: serviceName.rawValue,
                expiry: .seconds(expireForService)
            )
        }else{
            cache.async.addObject(
                JSON.array(jsonArray),
                forKey: serviceName.rawValue,
                expiry: .seconds(cacheForEver)
            )
        }
        
    }
    
    internal static func getCachedArray (serviceName:DafServiceNames, success: @escaping (Any?) -> Void ,faiulre: @escaping (Any?) -> Void) {
        cache.async.object(forKey: serviceName.rawValue) { json in
            print(json?.object ?? "test")
        }
    }
    
    internal static func removeCacheForService (serviceName:DafServiceNames) {
        cache.async.removeObject(forKey: serviceName.rawValue)
    }
    
}
