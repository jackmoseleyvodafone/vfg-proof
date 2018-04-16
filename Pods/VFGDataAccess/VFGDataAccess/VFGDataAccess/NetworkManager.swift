//
//  NetworkManager.swift
//  VFDAF
//
//  Created by Shimaa Magdi on 5/28/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import Alamofire
import VFGCommonUtils
import ObjectMapper

public typealias NetworkSuccessClosure = (Any?) -> Void
public typealias NetworkErrorClosure = (NSError) -> Void
public var maxTimeoutInterval: TimeoutValues = .shortTimeout

@objc public enum TimeoutValues: Int {
    case shortTimeout      = 30
    case generalTimeout    = 90
    case extendedTimeout   = 180
}

public struct NetworkManager {
    // network manager
    public static let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(maxTimeoutInterval.rawValue)
        let man = Alamofire.SessionManager( configuration: configuration )
        return man
    }()
    public static func request(url: String, requestMethod: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?, parameterEncoding: ParameterEncoding = JSONEncoding.default, success:@escaping NetworkSuccessClosure, failure:  @escaping NetworkErrorClosure) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        VFGLogger.log("\nURL: \(url) \nRequest: \n \(String(describing: headers))" )
        
        guard let alamoFireRequestMethod : Alamofire.HTTPMethod = Alamofire.HTTPMethod(rawValue:requestMethod.rawValue) else {
            VFGLogger.log("FATAL ERROR: Cannot construct request method! Calling failure method with default error.")
            failure(NSError())
            return
        }
//        String.init(data: Data, encoding: String.Encoding.)
        manager.request(url, method: alamoFireRequestMethod, parameters: parameters, encoding: parameterEncoding, headers: headers)
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                case .success:
                    if let error : NSError = response.result.error as NSError? {
                        failure(NetworkManager.log(error, url))
                    }
                    if response.result.value != nil {
                        success(response.result.value)
                    } else {
                        failure(NetworkManager.log(NSError(domain: url, code: -1014, userInfo: nil), url))
                    }
                    
                    break
                case .failure(let error ):
                    failure(NetworkManager.log(error as NSError, url))
                    break
                }
        }
    }
    public static func cancelRequests() {
        manager.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    public static func log(_ error: NSError, _ url: String) -> NSError {
        let networkError: NSError = NSError.generateNetworkError(error)
        let logString: String = "\(networkError.localizedFailureReason ?? "Error Key")  \(networkError.code) \(error.localizedDescription) \nURL: \(url) \nParameters: \(Parameters.self) "
        VFGLogger.log(logString)
        return networkError
    }
    
    public static func setNetworkTimeout(timeoutValue: TimeoutValues) {
        maxTimeoutInterval = timeoutValue
    }
    
    public static func  callApi(_ target : AbstractTarget,extraHeaders: [String:String]?,  completion: @escaping (_ result:[String:Any])->(), onError: @escaping (_ error: Error)->()){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var url = target.baseUrl
        url.appendPathComponent(target.path)
        
        VFGLogger.log("\nURL: \(url) \nRequest: \n \(String(describing: target.headers))" )
        
        var headers = target.headers ?? [String:String]()
        if let extra = extraHeaders{
            extra.forEach({ (key,value) in
                headers[key] = value
            })
        }
        
        manager.request(url, method: target.method, parameters: target.param, encoding: target.encoding, headers: headers)
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                switch response.result {
                case .success:
                    if let error  = response.result.error {
                        onError(NetworkManager.log(error as NSError, url.absoluteString))
                        onError(error)
                    }
                    if let json = response.result.value as? [String:Any] {
                        completion(json)
                    } else {
                        onError(NetworkManager.log(NSError(domain: url.absoluteString, code: -1014, userInfo: nil), url.absoluteString))
                    }
                    
                    break
                case .failure(let error ):
                    onError(NetworkManager.log(error as NSError, url.absoluteString))
                    break
                }
        }
    }
    
}


