//
//  DAFAbstractService.swift
//  VFGDataAccess
//
//  Created by Mohamed Matloub on 3/25/18.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import VFGCommonUtils

public typealias DAFManagerAbstractErrorClosure = (Error) -> Void

fileprivate let authenticationKey       : String = "Authentication"

class DAFAbstractService{
    
    // MARK: - Properties
    let cacheManager = CacheManager.getCacheManager()
    private(set) var authenticationManager: AuthenticationManager?
    
    
    // MARK: - Init
    init(authenticationObject: AuthenticationObject?) {
        authenticationManager = OAuth2Authentication(authenticationObject: authenticationObject)
        
    }
    
    internal func setNetworkTimeout(timeoutValue: TimeoutValues) {
        NetworkManager.setNetworkTimeout(timeoutValue: timeoutValue)
    }
    
    internal func execute<T: BaseModel>(target : AbstractTarget, modelObject: T.Type, needsAuthentication: Bool, success:@escaping (_ : T) -> Void, failure:  @escaping DAFManagerAbstractErrorClosure) {
        if cacheManager.isCacheEnabled() == true {
            
            CacheService.getCachedObject(serviceName: target.serviceNameForCaching , success: {  jsonObj in
                if let json : [String : Any] = jsonObj as? [String : Any] {
                    ParserManager.parse(modelObject: modelObject, json: json, success:{ (res) in
                        success(res as! T)
                    }, failure: failure)
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
                        strongSelf.requestAndCache(target: target, extraHeaders:  [authenticationKey:token?.accessToken ?? ""], modelObject: modelObject, completion: success, failure: failure)
                        
                    }, failure: failure)
                }
                else {
                    strongSelf.requestAndCache(target: target, extraHeaders: nil, modelObject: modelObject, completion: success, failure: failure)
                    
                }
            })
        } else{
            
            if needsAuthentication {
                authenticationManager?.getToken(success: { [weak self](token) in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.request(target, extraHeaders: [authenticationKey:token?.accessToken ?? ""], modelObject: modelObject, completion: success, onError: failure)
                    
                    }, failure: failure)
            }
            else {
                request(target, extraHeaders: nil, modelObject: modelObject, completion: success, onError: failure)
            }
            
            
        }
    }
    
    func  executeOffline<T: BaseModel>(target : AbstractTarget, modelObject: T.Type, success:@escaping (_ : T) -> Void, failure:  @escaping DAFManagerAbstractErrorClosure) {
      request(target, extraHeaders: nil, modelObject: modelObject, completion: success, onError: failure)
    }
    
    /////// to be refactored
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
    
    func request<T:BaseModel>(_ target : AbstractTarget, extraHeaders: [String:String]?,modelObject: T.Type, completion: @escaping (_ : T) -> Void, onError: @escaping DAFManagerAbstractErrorClosure){
        NetworkManager.callApi(target, extraHeaders: extraHeaders, completion: { (json) in
            VFGLogger.log("Data retrived from API \(json)")
                ParserManager.parse(modelObject: modelObject, json: json, success: { (res) in
                    completion(res as! T)
                }, failure: { (error) in
                    onError(error)
                })
                
            
        }) { (error) in
            onError(error)
        }
    }
    
    private func requestAndCache<T: BaseModel>(target:AbstractTarget, extraHeaders: [String:String]?, modelObject: T.Type, completion: @escaping (_ : T) -> Void, failure: @escaping DAFManagerAbstractErrorClosure) {
     
        NetworkManager.callApi(target, extraHeaders: extraHeaders, completion: { (json) in
            
            VFGLogger.log("Data retrived from API \(json)")
            ParserManager.parse(modelObject: modelObject, json: json, success: { (res) in
                CacheService.cacheJsonObject(json: json as [String : AnyObject], serviceName: target.serviceNameForCaching)

                completion(res as! T)
            }, failure: { (error) in
                failure(error)
            })
            
            
        }) { (error) in
            failure(error)
        }
      
    }

    
    internal func getCustomerPartyData(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping (_ partyList:CustomerPartyList)->(), failure:  @escaping DAFManagerAbstractErrorClosure) {
        
        if VFDAF.configuration.isOfflineEnabled == true , let url = OfflineFilesName.customerParty.getFileUrl() , url.isFileURL == true , FileManager.default.fileExists(atPath: url.absoluteString) {
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: CustomerPartyList.self, success: success, failure: failure)
        }else {
            self.execute(target: BillingApi.customerParty(customerPartyID: customerPartyID, customerPartyIDType: customerPartyIDType.rawValue), modelObject:  CustomerPartyList.self, needsAuthentication: false, success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
    
    internal func getBillingHistory(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType,success:@escaping (_ model:CustomerBillList)->(), failure:  @escaping DAFManagerAbstractErrorClosure) {
       
        if VFDAF.configuration.isOfflineEnabled == true , let url = OfflineFilesName.customerBills.getFileUrl() , url.isFileURL == true , FileManager.default.fileExists(atPath: url.absoluteString) {
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: CustomerBillList.self, success: success, failure: failure)
            
        }else {
            self.execute(target: BillingApi.customerBills(customerPartyID: customerPartyID, customerPartyIDType: customerPartyIDType.rawValue), modelObject: CustomerBillList.self, needsAuthentication: false, success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
    
    
    internal func getCustomerUsage(_ customerPartyID: String, partyIDType customerPartyIDType: CustomerPartyIDType, success:@escaping  (_ model:CustomerServiceUsageList)->(), failure:  @escaping DAFManagerAbstractErrorClosure) {
       
        if VFDAF.configuration.isOfflineEnabled == true , let url = OfflineFilesName.serviceUsage.getFileUrl() , url.isFileURL == true , FileManager.default.fileExists(atPath: url.absoluteString) {
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: CustomerServiceUsageList.self, success: success, failure: failure)
            
        }else {
            self.execute(target: BillingApi.serviceUsage(customerPartyID: customerPartyID, customerPartyIDType: customerPartyIDType.rawValue), modelObject: CustomerServiceUsageList.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
    
    
    func getSingleOrMultipleConcertina(billingAccountId:String,billRequestType:BillRequestType,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure){
        if VFDAF.configuration.isOfflineEnabled == true , let url = OfflineFilesName.ConcertinaSingleOrMultiple.getFileUrl() , url.isFileURL == true , let data = try?Data.init(contentsOf: url) {
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: BillingModel.self, success: success, failure: failure)
            
        }else {
            self.execute(target: BillingApi.concertinaSingleOrMultiple(billingAccountId: billingAccountId, billRequestType: billRequestType), modelObject: BillingModel.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
    
    func getChildConcertina(billingAccountId:String,MSISDN: String,billRequestType:BillRequestType,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure){
        if VFDAF.configuration.isOfflineEnabled == true , let url = OfflineFilesName.ConcertinaChild.getFileUrl() , url.isFileURL == true , let data = try?Data.init(contentsOf: url){
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: BillingModel.self, success: success, failure: failure)
            
        }else {
            self.execute(target: BillingApi.concertinaChild(billingAccountId: billingAccountId, MSISDN: MSISDN, billRequestType: billRequestType), modelObject: BillingModel.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
    
    func getChildBillsHistory(billingAccountId:String,MSISDN: String,billRequestType:BillRequestType,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure) {
        if VFDAF.configuration.isOfflineEnabled == true , let url = OfflineFilesName.BillsHistory.getFileUrl() , url.isFileURL == true , let data = try?Data.init(contentsOf: url){
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: BillingModel.self, success: success, failure: failure)
            
        }else {
            self.execute(target: BillingApi.childBillsHistory(billingAccountId: billingAccountId, MSISDN: MSISDN, billRequestType: billRequestType), modelObject: BillingModel.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
    
    func getSingleOrMultipleBillsHistory(billingAccountId:String,billRequestType:BillRequestType,success:@escaping  (_ model:BillingModel)->(), failure:  @escaping DAFManagerAbstractErrorClosure) {
        if VFDAF.configuration.isOfflineEnabled == true , let url = OfflineFilesName.BillsHistory.getFileUrl() , url.isFileURL == true , let data = try?Data.init(contentsOf: url){
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: BillingModel.self, success: success, failure: failure)
            
        }else {
            self.execute(target: BillingApi.singleOrMultipleBillsHistory(billingAccountId: billingAccountId, billRequestType: billRequestType), modelObject: BillingModel.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
}

// MARK: Section Current Balance
extension DAFAbstractService {
    func getChildCurrentBalance(billingAccountId:String,
                                MSISDN: String,
                                billRequestType:BillRequestType,
                                success:@escaping  (_ model:BillingModel)->(),
                                failure:  @escaping DAFManagerAbstractErrorClosure) {
        if VFDAF.configuration.isOfflineEnabled == true ,
            let url = OfflineFilesName.childCurrentBalance.getFileUrl() , url.isFileURL == true , let _ = try? Data.init(contentsOf: url){
            self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: BillingModel.self, success: success, failure: failure)
            
        }else {
            self.execute(target: BillingApi.childCurrentBalance(billingAccountId: billingAccountId, MSISDN: MSISDN, billRequestType: billRequestType), modelObject: BillingModel.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }

    func getSingleCurrentBalance(billingAccountId:String,
                                billRequestType:BillRequestType,
                                success:@escaping  (_ model:BillingModel)->(),
                                failure:  @escaping DAFManagerAbstractErrorClosure) {
        if VFDAF.configuration.isOfflineEnabled {
            var offlineFileURL : URL?
            if billRequestType == .balance {
                offlineFileURL = OfflineFilesName.singleCurrentBalanceOverview.getFileUrl()
            }else if billRequestType == .current{
                offlineFileURL = OfflineFilesName.singleCurrentBalance.getFileUrl()
            }
            if let url = offlineFileURL,
                url.isFileURL,
                let _ = try? Data.init(contentsOf: url){
                    self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: BillingModel.self, success: success, failure: failure)
            }
        }else{
            self.execute(target: BillingApi.singleCurrentBalance(billingAccountId: billingAccountId, billRequestType: billRequestType), modelObject: BillingModel.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
    
    func getMultipleCurrentBalance(billingAccountId:String,
                                 billRequestType:BillRequestType,
                                 success:@escaping  (_ model:BillingModel)->(),
                                 failure:  @escaping DAFManagerAbstractErrorClosure) {
        if VFDAF.configuration.isOfflineEnabled {
            var offlineFileURL : URL?
            if billRequestType == .balance {
                offlineFileURL = OfflineFilesName.multipleCurrentBalanceOverview.getFileUrl()
            }else if billRequestType == .current{
                offlineFileURL = OfflineFilesName.multipleCurrentBalance.getFileUrl()
            }
            if let url = offlineFileURL,
                url.isFileURL,
                let _ = try? Data.init(contentsOf: url){
                self.executeOffline(target: BillingApi.offlineLocalFile(url: url), modelObject: BillingModel.self, success: success, failure: failure)
            }
        }else{
            self.execute(target: BillingApi.multipleCurrentBalance(billingAccountId: billingAccountId, billRequestType: billRequestType), modelObject: BillingModel.self, needsAuthentication: false,  success: { (model) in
                success(model)
            }, failure: failure)
        }
    }
}
