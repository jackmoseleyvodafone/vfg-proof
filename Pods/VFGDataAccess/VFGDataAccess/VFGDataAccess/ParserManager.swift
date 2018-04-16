//
//  ParserManager.swift
//  VFDAF
//
//  Created by Ehab Alsharkawy on 5/30/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import VFGCommonUtils

public typealias ParserSuccessClosure = (Any) -> Void
public typealias ParserErrorClosure = (NSError) -> Void

public struct ParserManager {
    
    
    public static func parse<T: BaseModel> (modelObject:T.Type, json: Any, success: ParserSuccessClosure, failure: ParserErrorClosure) {
        if let item : [String : AnyHashable] = json as? [String: AnyHashable] {
            let result = Mapper<T>().map(JSON: item) as BaseModel? as? T
            if  validate(result) == true {
                success(result as Any)
            } else {
                let error = NSError(domain: "", code: NetworkErrorCode.parser.rawValue, userInfo: nil)
                failure(NSError.generateNetworkError(error))
            }
        }
        else if let itemsList : [[String : Any]] = json as? [[String : Any]] {
            let result : Array <T> = Mapper<T>().mapArray(JSONArray: itemsList)
            success(result)
        }
    }
    
    static func validate(_ baseModel :BaseModel?) -> Bool {
        
        guard let baseModel : BaseModel = baseModel else {
            VFGLogger.log("Cannot unwrap baseModel.")
            return false
        }
        
        if let result = baseModel as? CustomerPartyList {
            if result.parts == nil {
                return false
            }
        } else if let result = baseModel as? CustomerBillList {
            if result.serviceName == nil {
                return false
            }
        } else if let result = baseModel as? CustomerServiceUsageList {
            if result.serviceName == nil {
                return false
            }
        }
        return true
    }
    
}
