//
//  DAFService.swift
//  VFDAF
//
//  Created by Shimaa Magdi on 5/30/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

fileprivate enum DAFParameters: String{
    case onlineTVChangeNameUsername = "username"
    case renewBenefitStatus = "status"
}

internal class DAFService {
    
    // MARK: - Properties
    let cacheManager = CacheManager.getCacheManager()
    private(set) var authenticationManager: AuthenticationManager?
    
    
    // MARK: - Init
    init(authenticationObject: AuthenticationObject?) {
        authenticationManager = OAuth2Authentication(authenticationObject: authenticationObject)
        
    }
    
    // MARK: - APIs
    internal func getCustomerPartyData(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        let urlPath: String = String(format:  VFDAF.configuration.customerPartyPath, customerPartyID, customerPartyIDType.rawValue)
        let serviceHost: String = VFDAF.configuration.customerPartyURL ?? VFDAF.configuration.baseURL
        execute(serviceUrl: serviceHost + urlPath, requestMethod: .get, serviceName: DafServiceNames.customerParty, parameters: nil, headers: nil, modelObject: CustomerPartyList.self, needsAuthentication: false, success: success, failure: failure)
    }
    
       
    internal func getBillingHistory(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        let urlPath: String = String(format:  VFDAF.configuration.customerBillsPath, customerPartyID, customerPartyIDType.rawValue)
        let serviceHost: String = VFDAF.configuration.customerBillsURL ?? VFDAF.configuration.baseURL
        execute(serviceUrl: serviceHost + urlPath, requestMethod: .get, serviceName: DafServiceNames.billingHistory, parameters: nil, headers: nil, modelObject: CustomerBillList.self, needsAuthentication: false, success: success, failure: failure)
    }
 
   
    
    internal func getCustomerUsage(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        let urlPath: String = String(format:  VFDAF.configuration.serviceUsagePath, customerPartyID, customerPartyIDType.rawValue)
        let serviceHost: String = VFDAF.configuration.serviceUsageURL ?? VFDAF.configuration.baseURL
        execute(serviceUrl: serviceHost + urlPath, requestMethod: .get, serviceName: DafServiceNames.billingData, parameters: nil, headers: nil, modelObject: CustomerServiceUsageList.self, needsAuthentication: false, success: success, failure: failure)
    }
   
    
    internal func onlineTvChangeUserName(_ mail: String?, siteId: String, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        let urlPath: String = String(format:  VFDAF.configuration.onlineTvChangeUserNamePath, siteId)
        let serviceHost: String = VFDAF.configuration.onlineTvChangeUserNameURL ?? VFDAF.configuration.baseURL
        
        var bodyParameters: [String: Any] = [:]
        if let mail = mail {
            bodyParameters[DAFParameters.onlineTVChangeNameUsername.rawValue] = mail
        }

        execute(serviceUrl: serviceHost + urlPath, requestMethod: .patch, serviceName: DafServiceNames.onlineTvChangeUserName, parameters: bodyParameters, headers: psHeaders(), modelObject: BaseModel.self, needsAuthentication: false, success: success, failure: failure)
    }
    
    internal func renewBenefit(_ benefitStatus: String?, tariffId: String?, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        let urlPath: String = String(format:  VFDAF.configuration.renewBenefitPath, tariffId ?? " ")
        let serviceHost: String = VFDAF.configuration.renewBenefitURL ?? VFDAF.configuration.baseURL
        
        var bodyParameters: [String: Any] = [:]
        if let benefitStatus = benefitStatus {
            bodyParameters[DAFParameters.renewBenefitStatus.rawValue] = benefitStatus
        }
        
        execute(serviceUrl: serviceHost + urlPath, requestMethod: .patch, serviceName: DafServiceNames.renewBenefit, parameters: bodyParameters, headers: psHeaders(), modelObject: BaseModel.self, needsAuthentication: false, success: success, failure: failure)
    }
    
    internal func getProduct(_ queryParameters: [String: String], success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        guard let urlString = url(baseUrl: VFDAF.configuration.getProductURL, servicePath: VFDAF.configuration.getProductPath, queryParameters: queryParameters) else {
            let error = NSError(domain: "", code: NetworkErrorCode.serverNotFound.rawValue, userInfo: nil)
            failure(NSError.generateNetworkError(error))
            return
        }

        execute(serviceUrl: urlString, requestMethod: .get, serviceName: DafServiceNames.getProduct, parameters: nil, headers: psHeaders(), modelObject: BaseModel.self, needsAuthentication: false, success: success, failure: failure)
    }
    
    internal func getServices(_ queryParameters: [String: String], success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        guard let urlString = url(baseUrl: VFDAF.configuration.getServicesURL, servicePath: VFDAF.configuration.getServicesPath, queryParameters: queryParameters) else {
            let error = NSError(domain: "", code: NetworkErrorCode.serverNotFound.rawValue, userInfo: nil)
            failure(NSError.generateNetworkError(error))
            return
        }

        execute(serviceUrl: urlString, requestMethod: .get, serviceName: DafServiceNames.getServices, parameters: nil, headers: psHeaders(), modelObject: VFServicesResponseModel.self, needsAuthentication: false, success: success, failure: failure)
    }
    
    // MARK: - Utils
    internal func setNetworkTimeout(timeoutValue: TimeoutValues) {
        NetworkManager.setNetworkTimeout(timeoutValue: timeoutValue)
    }
    
    internal func psHeaders() -> [String: String]{
        let headers: [String: String] = [
            "Accept": "application/json",
            "vf-target-stub": "false",
            "vf-country-code": "ES",
            "Content-Type": "application/json",
            "vf-target-environment": "aws-uat-es",
            //VFGTODO: Hardcoded authorization token
            "Authorization": "Bearer postpaid complete."
        ]
        
        return headers
    }
    
    internal func url(baseUrl: String?, servicePath: String, queryParameters:  [String: String]) -> String? {
        let baseUrl = baseUrl ?? VFDAF.configuration.baseURL
        guard let urlString = "\(baseUrl)\(servicePath)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = []
        queryParameters.forEach { element in
            let queryItem = URLQueryItem(name: element.key, value: element.value)
            urlComponents?.queryItems?.append(queryItem)
        }

        return urlComponents?.url?.absoluteString
    }
    
}
