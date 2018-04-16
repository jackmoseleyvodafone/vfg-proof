//
//  CacheService.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 6/20/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import Cache


class CacheService {
    static let cacheManager = CacheManager.getCacheManager()

    static var cache :[String: BaseModel] = [String: BaseModel]()
    
    static func setObjectInCache (serviceName:DafServiceNames, baseModel :BaseModel) {
        CacheService.cache[serviceName.rawValue] = baseModel
    }
    
    static func getObjectFromCache (serviceName:DafServiceNames) -> BaseModel? {
        return  CacheService.cache[serviceName.rawValue]
    }
    
    static func isCached(serviceName: DafServiceNames) -> Bool {
        return CacheService.cache[serviceName.rawValue] != nil
    }
    

    static func cacheJsonObject (json: [String : AnyObject], serviceName:DafServiceNames){
        cacheManager.cacheJsonObject(json: json, serviceName: serviceName)
        
    }
    
     static func getCachedObject (serviceName:DafServiceNames, success: @escaping (Any?) -> Void,  faiulre: @escaping (Any?) -> Void) {
       cacheManager.getCachedObject(serviceName: serviceName, success: success, faiulre: faiulre)
    }
    
    
     static func cacheJsonArray (jsonArray: [[String : AnyObject]] ,serviceName:DafServiceNames, expiredAfter :TimeInterval){
        cacheManager.cacheJsonArray(jsonArray: jsonArray, serviceName: serviceName)
    }
    
     static func getCachedArray (serviceName:DafServiceNames, success: @escaping (Any?) -> Void,  faiulre: @escaping (Any?) -> Void) {
        cacheManager.getCachedArray(serviceName: serviceName, success: success, faiulre: faiulre)
    }
    
}
