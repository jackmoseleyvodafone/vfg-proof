//
//  CustomerBillList.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 6/7/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import ObjectMapper

fileprivate struct MappingKey {
    static let serviceName : String = "serviceName"
    static let customerBillsList : String = "customerBillsList"
    static let customerBillId : String = "customerBillId"
    static let customerBillTotalAmount : String = "customerBillTotalAmount"
    static let ban : String = "ban"
    static let customerBillDate : String = "customerBillDate"
    static let customerBillCurrency : String = "customerBillCurrency"
    static let customerBillAmountInPlan : String = "customerBillAmountInPlan"
    static let customerAccountId : String = "customerAccountId"
    static let customerBillDueDate : String = "customerBillDueDate"
    static let customerBillURL : String = "customerBillURL"
    static let customerBillingAccountType : String = "customerBillingAccountType"
    static let customerBillAmountOutOfPlan : String = "customerBillAmountOutOfPlan"
    static let customerBillFromDate : String = "customerBillFromDate"
    static let customerBillToDate : String = "customerBillToDate"
    static let customerBillPaidStatus : String = "customerBillPaidStatus"
    static let customerBillPaidDate : String = "customerBillPaidDate"
}

public class CustomerBillList: BaseModel {
    public var serviceName: String?
    public var customerBillsList: [BillingData]?
    public override func mapping(map: Map) {
        serviceName <- map[MappingKey.serviceName]
        customerBillsList <- map[MappingKey.customerBillsList]
    }
}

public class BillingData: BaseModel {
    public var customerBillId : Int?
    public var customerBillTotalAmount : Double?
    public var ban : String?
    public var customerBillDueDate : Double?
    public var customerBillDate : Double?
    public var customerBillURL : String?
    public var customerBillCurrency : String?
    public var customerBillingAccountType : String?
    public var customerAccountId : Int?
    public var customerBillAmountInPlan : Double?
    public var customerBillAmountOutOfPlan : Double?
    public var customerBillFromDate : Double?
    public var customerBillToDate : Double?
    public var customerBillPaidStatus : Bool?
    public var customerBillPaidDate : Double?
  
    
    public override func mapping(map: Map) {
        customerBillId <- map[MappingKey.customerBillId]
        customerBillTotalAmount <- map[MappingKey.customerBillTotalAmount]
        ban <- map[MappingKey.ban]
        customerBillDueDate <- map[MappingKey.customerBillDueDate]
        customerBillDate <- map[MappingKey.customerBillDate]
        customerBillURL <- map[MappingKey.customerBillURL]
        customerBillCurrency <- map[MappingKey.customerBillCurrency]
        customerBillingAccountType <- map[MappingKey.customerBillingAccountType]
        customerAccountId <- map[MappingKey.customerAccountId]
        customerBillAmountInPlan <- map[MappingKey.customerBillAmountInPlan]
        customerBillAmountOutOfPlan <- map[MappingKey.customerBillAmountOutOfPlan]
        customerBillFromDate <- map[MappingKey.customerBillFromDate]
        customerBillToDate <- map[MappingKey.customerBillToDate]
        customerBillPaidStatus <- map[MappingKey.customerBillPaidStatus]
        customerBillPaidDate <- map[MappingKey.customerBillPaidDate]
        
    }
}
