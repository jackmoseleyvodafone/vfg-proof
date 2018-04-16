//
//  DAFManager.swift
//  VFDAF
//
//  Created by Shimaa Magdi on 5/30/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

public typealias DAFManagerSuccessClosure = (Any?) -> Void
public typealias DAFManagerErrorClosure = (NSError) -> Void

public class VFDAF: NSObject {

    /**
     This property stores currect DAF configuration.
    */
    public static var configuration: VFDAFConfiguration = VFDAFConfiguration()
    
    // MARK: - Properties
    private var dafService: DAFService?
    
    // MARK: - Properties
    fileprivate var dafAbstractService: DAFAbstractService?
    
    // MARK: - Shared Instance
    private static var shared = VFDAF()
    
    public static func getDAFManager() -> VFDAF{
        return .shared
    }
    
    // MARK: - Init
    private override init() {
    }
    
    /**
     Set Authentication Object.
     
     - Parameter authenticationObject: Authentication Object.
     - Parameter baseURL: override the current base URL..
     - Parameter shouldLog: decide whether to add logs or not.
     */
    public static func initWithAuthentication(authenticationObject: AuthenticationObject?, baseURL: VFDAFBaseUrl = .stub) {
        let sharedDAF = VFDAF.getDAFManager()
        sharedDAF.dafService = DAFService(authenticationObject: authenticationObject)
        sharedDAF.dafAbstractService = DAFAbstractService(authenticationObject: authenticationObject)
        VFDAF.configuration.setBaseUrl(baseURL: baseURL)
    }
    
    public static func initWithConfiguration(configurationObject: VFDAFConfiguration?) {
        let sharedDAF = VFDAF.getDAFManager()
        sharedDAF.dafService = DAFService(authenticationObject: configurationObject?.authenticationObject)
        sharedDAF.dafAbstractService = DAFAbstractService(authenticationObject: configurationObject?.authenticationObject)

        if let config = configurationObject {
            VFDAF.configuration = config
        }else{
            VFDAF.configuration = configuration
        }
    }
    
    /**
     Get Customer Party Data.
     
     - Parameter customerPartyID: Customer Party ID.
     - Parameter customerPartyIDType: msisdn, email,etc..
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func getCustomerPartyList(customerPartyID: String, customerPartyIDType: CustomerPartyIDType, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        
            dafService?.getCustomerPartyData(customerPartyID, partyIDType: customerPartyIDType, success: success, failure: failure)
        
    }
    
    /**
     Get Customer Bill List.
     
     - Parameter customerPartyID: Customer Party ID.
     - Parameter customerPartyIDType: msisdn, email,etc..
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func getCustomerBillsList(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping DAFManagerSuccessClosure, failure: @escaping DAFManagerErrorClosure) {
    
            dafService?.getBillingHistory(customerPartyID, partyIDType: customerPartyIDType, success: success, failure: failure)
        
    }
    
    /**
     Get Customer Service Usage.
     
     - Parameter customerPartyID: Customer Party ID.
     - Parameter customerPartyIDType: msisdn, email,etc..
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func getServiceUsage(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping DAFManagerSuccessClosure, failure: @escaping DAFManagerErrorClosure) {
  
            dafService?.getCustomerUsage(customerPartyID, partyIDType: customerPartyIDType, success: success, failure: failure)
        
    }
    
    /**
     
     Changes user's name in online tv service
     - Parameter mail: Username.
     - Parameter siteId: Site ID.
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func onlineTvChangeUserName(_ mail: String?, siteId: String, success:@escaping DAFManagerSuccessClosure, failure: @escaping DAFManagerErrorClosure){
        
        dafService?.onlineTvChangeUserName(mail, siteId: siteId, success: success, failure: failure)
        
    }
    
    /**
     
     Changes user's name in online tv service
     - Parameter benefitStatust: benefit status.
     - Parameter tariffId: product id.
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func renewBenefit(_ benefitStatus: String? = nil, tariffId: String? = nil, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        
        dafService?.renewBenefit(benefitStatus, tariffId: tariffId, success: success, failure: failure)
        
    }    
    
    /**
     
     Retrieves product
     - Parameter serivceId: service id.
     - Parameter siteId: site id.
     - Parameter productType: product type name.
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func getProduct(_ serivceId: String, siteId: String, productType: String, success:@escaping DAFManagerSuccessClosure, failure:  @escaping DAFManagerErrorClosure) {
        
        dafService?.getProduct(serivceId, siteId: siteId, productType: productType, success: success, failure: failure)
        
    }

    /**
     Cancel all ongoing requests.
     */
    public func cancelAllDAFRequests() {
        NetworkManager.cancelRequests()
    }
    
    internal func request(url: String, requestMethod: HTTPMethod, parameters: [String : AnyObject]?, headers: [String : String]?, success:@escaping DAFManagerSuccessClosure, failure: @escaping DAFManagerErrorClosure) {
        NetworkManager.request(url: url, requestMethod: requestMethod, parameters: parameters, headers: headers, success: success, failure: failure)
    }
    
    /**
     Get Cache Manager.
     
     - Returns : CacheManager singelton.
     
     */
    public func getCacheManager() -> CacheManager {
        return CacheManager.getCacheManager()
    }
    
    /**
     Set Cache enabled.
     
     - Parameter enabled: Boolean to enable or not.

     */
    public func shouldEnableCache(enabled: Bool){
        CacheManager.getCacheManager().shouldEnableCaching(enabled: enabled)
    }
    
    /**
     Set Network timeout.
     
     - Parameter timeoutValue: shortTimeout, generalTimeout or extendedTimeout.
     
     */
    public func setNetworkTimeout(timeoutValue: TimeoutValues) {
        dafService?.setNetworkTimeout(timeoutValue: timeoutValue)
        dafAbstractService?.setNetworkTimeout(timeoutValue: timeoutValue)
    }
    
    /**
     Set Expire time per service.
     
     - Parameter serviceName: Service Name.
     - Parameter expireAfter: Expiration time..
     
     */
    public func setCacheExpireTimeForService(serviceName: DafServiceNames, expireAfter:TimeInterval?){
        CacheManager.getCacheManager().setCacheExpireTimeForService(serviceName: serviceName, expireAfter: expireAfter)
    }
    
    
    /**
     Get Customer Party Data.
     
     - Parameter customerPartyID: Customer Party ID.
     - Parameter customerPartyIDType: msisdn, email,etc..
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func getNewCustomerPartyList(customerPartyID: String, customerPartyIDType: CustomerPartyIDType, success: @escaping (_ partyList:CustomerPartyList)->(), failure:  @escaping DAFManagerAbstractErrorClosure ) {
      
        dafAbstractService?.getCustomerPartyData(customerPartyID, partyIDType: customerPartyIDType, success: success, failure: failure)
        
    }
    
    /**
     Get Customer Bill List.
     
     - Parameter customerPartyID: Customer Party ID.
     - Parameter customerPartyIDType: msisdn, email,etc..
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func getNewCustomerBillsList(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType,  success:@escaping (_ model:CustomerBillList)->(), failure:  @escaping DAFManagerAbstractErrorClosure ) {
      
        dafAbstractService?.getBillingHistory(customerPartyID, partyIDType: customerPartyIDType, success: success, failure: failure)
        
    }
    
    /**
     Get Customer Service Usage.
     
     - Parameter customerPartyID: Customer Party ID.
     - Parameter customerPartyIDType: msisdn, email,etc..
     - Parameter success: success block with model.
     - Parameter failure: failure block with error.
     
     */
    public func getNewServiceUsage(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping  (_ model:CustomerServiceUsageList)->(), failure:  @escaping DAFManagerAbstractErrorClosure ) {

            self.dafAbstractService?.getCustomerUsage(customerPartyID, partyIDType: customerPartyIDType, success: success, failure: failure)
        
    }
    
    public func getSingleOrMultipleConcertina(billingAccountId:String,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure){
        
        self.dafAbstractService?.getSingleOrMultipleConcertina(billingAccountId:billingAccountId,billRequestType:BillRequestType.balance,success:success, failure: failure)
    }
    public func getChildConcertina(billingAccountId:String,MSISDN: String,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure){
        
        self.dafAbstractService?.getChildConcertina(billingAccountId:billingAccountId,MSISDN: MSISDN,billRequestType:BillRequestType.current,success:success, failure: failure)
    }
    
    public func getSingleOrMultipleBillsHistory(billingAccountId:String,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure){
        
        self.dafAbstractService?.getSingleOrMultipleBillsHistory(billingAccountId:billingAccountId,billRequestType:BillRequestType.history,success:success, failure: failure)
    }
    
    public func getChildBillsHistory(billingAccountId:String,MSISDN: String,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure){
        
        self.dafAbstractService?.getChildBillsHistory(billingAccountId:billingAccountId,MSISDN: MSISDN,billRequestType:BillRequestType.history,success:success, failure: failure)
    }
    
}

// MARK: Section Child Current Balance
extension VFDAF {
    public func getChildCurrentBalance(billingAccountId:String,MSISDN: String,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure){
        self.dafAbstractService?.getChildCurrentBalance(billingAccountId:billingAccountId,MSISDN: MSISDN,billRequestType:BillRequestType.current,success:success, failure: failure)
    }
}

// MARK: Section Single Current Balance
extension VFDAF {
    public func getSingleCurrentBalance(billingAccountID:String,
                                        success:@escaping  (_ model:BillingModel)->(),
                                        failure:  @escaping DAFManagerAbstractErrorClosure){
    self.dafAbstractService?.getSingleCurrentBalance(billingAccountId: billingAccountID, billRequestType: BillRequestType.current, success: success, failure: failure)
    }
    public func getSingleCurrentBalanceOverview(billingAccountID:String,
                                        success:@escaping  (_ model:BillingModel)->(),
                                        failure:  @escaping DAFManagerAbstractErrorClosure){
        self.dafAbstractService?.getSingleCurrentBalance(billingAccountId: billingAccountID, billRequestType: BillRequestType.balance, success: success, failure: failure)
    }
}

// MARK: Section Multiple Current Balance
extension VFDAF {
    public func getMultipleCurrentBalance(billingAccountID:String,
                                        success:@escaping  (_ model:BillingModel)->(),
                                        failure:  @escaping DAFManagerAbstractErrorClosure){
        self.dafAbstractService?.getMultipleCurrentBalance(billingAccountId: billingAccountID, billRequestType: BillRequestType.current, success: success, failure: failure)
    }
    public func getMultipleCurrentBalanceOverview(billingAccountID:String,
                                                success:@escaping  (_ model:BillingModel)->(),
                                                failure:  @escaping DAFManagerAbstractErrorClosure){
        self.dafAbstractService?.getMultipleCurrentBalance(billingAccountId: billingAccountID, billRequestType: BillRequestType.balance, success: success, failure: failure)
    }
}
