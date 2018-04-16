//
//  VFDAFConfiguration.swift
//  VFGDataAccess
//
//  Created by Mateusz Zakrzewski on 07/03/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper

fileprivate struct MappingKey {
    static let baseURL : String = "baseURL"
    static let customerPartyPath : String = "customerPartyPath"
    static let customerBillsPath : String = "customerBillsPath"
    static let serviceUsagePath : String = "serviceUsagePath"
    static let customerPartyURL : String = "customerPartyURL"
    static let customerBillsURL : String = "customerBillsURL"
    static let serviceUsageURL : String = "serviceUsageURL"
    static let campaignURL : String = "campaignURL"
    static let stagingBaseURL : String = "stagingBaseURL"
    static let authTokenPath : String = "authTokenPath"
    static let onlineTvChangeUserNamePath : String = "onlineTvChangeUserNamePath"
    static let onlineTvChangeUserNameURL : String = "onlineTvChangeUserNameURL"
    static let renewBenefitPath : String = "renewBenefitPath"
    static let renewBenefitURL : String = "renewBenefitURL"
    static let getProductPath : String = "getProductPath"
    static let getProductURL : String = "getProductURL"
}

public enum VFDAFBaseUrl: String{
    case stub = "http://customerbill.getsandbox.com/"
    case test
    case dev = "http://billingdev.getsandbox.com/"
    case prod = "https://apistagingref.developer.vodafone.com"
}

/**
 Data Access Framework configuration class.
 This class is prepopulated with default values.
 */
public class VFDAFConfiguration : BaseModel {
    
    /**
     Optional authentication object.
    */
    public var authenticationObject: AuthenticationObject?
   
    /**
     baseURL which can be used to change backend mode
     */
    private(set) internal var baseURL : String = VFDAFBaseUrl.stub.rawValue
    
    /**
     define if DAF should load local files
     */
    public var isOfflineEnabled = false
    
    /**
     Customer party path part of the URL
     */
    public var customerPartyPath: String = "getCustomerPartyList?customerPartyID=%@&customerPartyIDType=%@"
    /**
     Customer bills path part of the URL
     */
    public var customerBillsPath: String = "getCustomerBillList?customerPartyID=%@&customerPartyIDType=%@"
    /**
     Service usage path part of URL
     */
    public var serviceUsagePath: String = "getCustomerServiceUsageList?customerPartyID=%@&customerPartyIDType=%@"
    /**
     Change user name path part of URL
     */
    public var onlineTvChangeUserNamePath: String = "es/v2/authenticationCredential/identity/%@/app/onlineTV"
    /**
     Change renew benefit path part of URL
     */
    public var renewBenefitPath: String = "/v2/product/tariffs/%@"
    /**
     Change renew benefit path part of URL
     */
    public var getProductPath: String = "/v2/product/products"
    
    /**
     Optional customer party URL which will be used instead of baseURL
     */
    public var customerPartyURL: String?
    /**
     Optional customer bills URL which will be used instead of baseURL
     */
    public var customerBillsURL: String?
    /**
     Optional service usage URL which will be used instead of baseURL
     */
    public var serviceUsageURL: String?
    /**
     Optional change user name URL which will be used instead of baseURL
     */
    public var onlineTvChangeUserNameURL: String? = "http://stubs-test.tsse.co/api"
    /**
     Optional renew benefit URL which will be used instead of baseURL
     */
    public var renewBenefitURL: String? = "http://stubs-test.tsse.co/api"
    /**
     Optional get product URL which will be used instead of baseURL
     */
    public var getProductURL: String? = "http://stubs-test.tsse.co/api"
    
    /**
     Campaign URL
     */
    public var campaignURL: String = "https://vodafonedemogroup.tt.omtrdc.net/rest/v1/mbox/1?client=vodafonedemogroup"
    /**
     Staging base URL
     */
    public var stagingBaseURL: String = "https://apistagingref.developer.vodafone.com/"
    /**
     Auth Token path part of URL
     */
    public var authTokenPath: String = "v1/apixoauth2password/oauth2/token"
    /**
     Enable/Disable stabs header
     */
    public var enableStabsHeader: Bool = false
    
  
    public override func mapping(map: Map) {
        baseURL <- map[MappingKey.baseURL]
        customerPartyPath <- map[MappingKey.customerPartyPath]
        customerBillsPath <- map[MappingKey.customerBillsPath]
        serviceUsagePath <- map[MappingKey.serviceUsagePath]
        customerPartyURL <- map[MappingKey.customerPartyURL]
        customerBillsURL <- map[MappingKey.customerBillsURL]
        serviceUsageURL <- map[MappingKey.serviceUsageURL]
        campaignURL <- map[MappingKey.campaignURL]
        stagingBaseURL <- map[MappingKey.stagingBaseURL]
        authTokenPath <- map[MappingKey.authTokenPath]
        onlineTvChangeUserNamePath <- map[MappingKey.onlineTvChangeUserNamePath]
        onlineTvChangeUserNameURL <- map[MappingKey.onlineTvChangeUserNameURL]
        renewBenefitPath <- map[MappingKey.renewBenefitPath]
        renewBenefitURL <- map[MappingKey.renewBenefitURL]
        getProductPath <- map[MappingKey.getProductPath]
        getProductURL <- map[MappingKey.getProductURL]
    }
   
    public func setBaseUrl(baseURL: VFDAFBaseUrl){
        self.baseURL = baseURL.rawValue
    }
}
