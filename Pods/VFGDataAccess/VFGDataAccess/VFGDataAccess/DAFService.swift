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
    case getProductSiteId = "customerAccountId"
    case getProductSubscriptionId = "subscriptionId"
    case getProductType = "productType"
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

        execute(serviceUrl: serviceHost + urlPath, requestMethod: .patch, serviceName: DafServiceNames.onlineTvChangeUserName, parameters: bodyParameters, headers: nil, modelObject: BaseModel.self, needsAuthentication: false, success: success, failure: failure)
    }
    
    internal func renewBenefit(_ benefitStatus: String? = nil, tariffId: String? = nil, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        let urlPath: String = String(format:  VFDAF.configuration.renewBenefitPath, tariffId ?? " ")
        let serviceHost: String = VFDAF.configuration.renewBenefitURL ?? VFDAF.configuration.baseURL
        
        var bodyParameters: [String: Any] = [:]
        if let benefitStatus = benefitStatus {
            bodyParameters[DAFParameters.renewBenefitStatus.rawValue] = benefitStatus
        }
        
        execute(serviceUrl: serviceHost + urlPath, requestMethod: .patch, serviceName: DafServiceNames.renewBenefit, parameters: bodyParameters, headers: nil, modelObject: BaseModel.self, needsAuthentication: false, success: success, failure: failure)
    }
    
    internal func getProduct(_ serivceId: String, siteId: String, productType: String, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        let urlPath: String = VFDAF.configuration.getProductPath
        let serviceHost: String = VFDAF.configuration.getProductURL ?? VFDAF.configuration.baseURL
        
        let bodyParameters: [String: Any] = [DAFParameters.getProductSiteId.rawValue: siteId,
                                             DAFParameters.getProductSubscriptionId.rawValue: serivceId,
                                             DAFParameters.getProductType.rawValue: productType]
        
        execute(serviceUrl: serviceHost + urlPath, requestMethod: .get, serviceName: DafServiceNames.getProduct, parameters: bodyParameters, headers: nil, modelObject: BaseModel.self, needsAuthentication: false, success: success, failure: failure)
    }
    
    // MARK: - Utils
    internal func setNetworkTimeout(timeoutValue: TimeoutValues) {
        NetworkManager.setNetworkTimeout(timeoutValue: timeoutValue)
    }
    
}
