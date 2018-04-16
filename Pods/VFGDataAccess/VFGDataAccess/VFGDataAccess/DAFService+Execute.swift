//
//  DAFService+Execute.swift
//  VFGDataAccess
//
//  Created by Mohamed Magdy on 7/27/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import Alamofire
import VFGCommonUtils

fileprivate let authenticationKey       : String = "Authentication"
fileprivate let stabsHeaderKey          : String = "Stabs"

internal extension DAFService {
    
    
    /**
     Execute network request.
     
     - Parameter serviceUrl: service URL.
     - Parameter requestMethod: GET, POST, etc..
     - Parameter serviceName: Service name.
     - Parameter parameters: request parameters.
     - Parameter headers: request headers.
     - Parameter modelObject: generic model object.
     - Parameter needsAuthentication: set needs authentication.
     - Parameter success: success block with reponse.
     - Parameter failure: failure block with error.

     */
    internal func execute<T: BaseModel>(serviceUrl :String, requestMethod: HTTPMethod,serviceName: DafServiceNames, parameters: [String : Any]?, headers: [String : String]?, modelObject: T.Type, needsAuthentication: Bool, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        if cacheManager.isCacheEnabled() {
            
            CacheService.getCachedObject(serviceName: serviceName , success: {  jsonObj in
                if let json : [String : Any] = jsonObj as? [String : Any] {
                    ParserManager.parse(modelObject: modelObject, json: json, success: success, failure: failure)
                    VFGLogger.log("Data retrived from cache \(json)")
                }
                else{
                    let error = NSError(domain: "", code: NetworkErrorCode.parser.rawValue, userInfo: nil)
                    failure(NSError.generateNetworkError(error))
                    
                }
            }, faiulre: {[weak self] error in
                guard let strongSelf = self else { return }
                if needsAuthentication {
                    strongSelf.authenticationManager?.getToken(success: { (token) in
                        let mutableHeader = strongSelf.addAuthenticationHeader(oldHeader: headers, authenticationToken: token)
                        strongSelf.requestAndCache(url: serviceUrl, requestMethod: requestMethod, serviceName: serviceName, parameters: parameters, headers: mutableHeader, modelObject: modelObject, success: success, failure: failure)
                    }, failure: failure)
                }
                else {
                    strongSelf.requestAndCache(url: serviceUrl, requestMethod: requestMethod, serviceName: serviceName, parameters: parameters, headers: headers, modelObject: modelObject, success: success, failure: failure)
                }
            })
        } else{
            
            if needsAuthentication {
                authenticationManager?.getToken(success: { [weak self](token) in
                    guard let strongSelf = self else { return }
                   let mutableHeader = strongSelf.addAuthenticationHeader(oldHeader: headers, authenticationToken: token)
                    strongSelf.request(url: serviceUrl, requestMethod: requestMethod, parameters: parameters, headers: mutableHeader, modelObject: modelObject, success: success, failure: failure)
                    }, failure: failure)
            }
            else {
                request(url: serviceUrl, requestMethod: requestMethod, parameters: parameters, headers: headers, modelObject: modelObject, success: success, failure: failure)
            }
            
            
        }
    }
    
    // MARK: - Private methods
    private func requestAndCache<T: BaseModel>(url: String, requestMethod: HTTPMethod, serviceName: DafServiceNames, parameters: [String : Any]?, headers: [String : String]?, modelObject: T.Type, success: @escaping DAFManagerSuccessClosure, failure: @escaping DAFManagerErrorClosure) {
        
        let headers : [String : String]? = addStabsHeaderWhenRequested(oldHeaders: headers)
        
        NetworkManager.request(url: url, requestMethod: requestMethod, parameters: parameters, headers: headers, success: {[weak self] jsonObj in
            guard let strongSelf = self else { return }
            if strongSelf.cacheManager.shouldSaveInCache(key: serviceName) {
                if let json : [String : AnyObject] = jsonObj as? [String : AnyObject] {
                    ParserManager.parse(modelObject: modelObject, json: json, success: { model in
                        CacheService.cacheJsonObject(json: json, serviceName: serviceName)
                        success(model)
                        VFGLogger.log("Data retrived from API and cached \(json)")
                    }, failure: failure)
                    
                }
                else {
                    let error = NSError(domain: "", code: NetworkErrorCode.parser.rawValue, userInfo: nil)
                    failure(NSError.generateNetworkError(error))
                }
            }
            }, failure: failure)
    }
    
    private func request<T: BaseModel>(url: String, requestMethod: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?, modelObject: T.Type, success: @escaping DAFManagerSuccessClosure, failure: @escaping DAFManagerErrorClosure) {
        
        let headers : [String : String]? = addStabsHeaderWhenRequested(oldHeaders: headers)
        
        NetworkManager.request(url: url, requestMethod: requestMethod, parameters: parameters, headers: headers, success: { jsonObject in
            if let json : [String : Any] = jsonObject as? [String : Any] {
                ParserManager.parse(modelObject: modelObject, json: json, success: success, failure: failure)
                VFGLogger.log("Data retrived from API \(json)")
            }
        }, failure: failure)
    }
    
    private func addStabsHeaderWhenRequested(oldHeaders: [String : String]?) -> [String : String]? {
        
        if VFDAF.configuration.enableStabsHeader == false {
            return oldHeaders
        }
        
        if var oldHeaders = oldHeaders {
            oldHeaders[stabsHeaderKey] = String(true)
            return oldHeaders
        }
        return [stabsHeaderKey : String(true)]
    }
    
    private func addAuthenticationHeader(oldHeader: [String : String]?, authenticationToken: Token?) -> [String : String] {
        var mutableHeaders = [String : String]()
        if let oldHeader : [String : String] = oldHeader {
            mutableHeaders = oldHeader
        }
        if let accessToken = authenticationToken?.accessToken {
            mutableHeaders[authenticationKey] = accessToken
        }
        return mutableHeaders
    }
    
}
