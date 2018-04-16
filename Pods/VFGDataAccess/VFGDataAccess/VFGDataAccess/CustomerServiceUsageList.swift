//
//  CustomerServiceUsageList.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 6/7/17.
//  Copyright © 2017 VFG. All rights reserved.
//
import Foundation
import ObjectMapper

fileprivate struct MappingKey {
    static let serviceName : String = "serviceName"
    static let billStatus : String = "billStatus"
    static let currentBillingData : String = "currentBillingData"
    static let spentAmount : String = "spentAmount"
    static let spentCurrency : String = "spentCurrency"
    static let outOfPlanSpentAmount : String = "outOfPlanSpentAmount"
    static let outOfPlanSpentCurrency : String = "outOfPlanSpentCurrency"
    static let totalAmount : String = "totalAmount"
    static let currency : String = "currency"
    static let charges : String = "charges"
    static let lstCharges : String = "lstCharges"
    static let sequence : String = "sequence"
    static let iconId : String = "icon_id"
    static let description : String = "description"
    static let value : String = "value"
    static let amount : String = "amount"
    static let type : String = "type"
    static let chargeSummary : String = "chargeSummary"
    static let chargeable : String = "chargeable"
    static let inPlan : String = "inPlan"
    static let totalSummation : String = "totalSummation"
    static let outOfPlanSummation : String = "outOfPlanSummation"
    static let allChargeSummary : String = "allChargeSummary"
    
}

public class CustomerServiceUsageList: BaseModel {
    public var serviceName: String?
    public var billStatus: BillStatus?
    public var currentBillingData: CurrentBillingData?
    public override func mapping(map: Map) {
        serviceName <- map[MappingKey.serviceName]
        billStatus <- map[MappingKey.billStatus]
        currentBillingData <- map[MappingKey.currentBillingData]
    }
}

public class BillStatus: BaseModel {
    public var spentAmount: Double?
    public var spentCurrency: String?
    public var outOfPlanSpentAmount: Double?
    public var outOfPlanSpentCurrency: String?
    public var chargeable: Bool?
    public override func mapping(map: Map) {
        spentAmount <- map[MappingKey.spentAmount]
        spentCurrency <- map[MappingKey.spentCurrency]
        outOfPlanSpentAmount <- map[MappingKey.outOfPlanSpentAmount]
        outOfPlanSpentCurrency <- map[MappingKey.outOfPlanSpentCurrency]
        chargeable <- map[MappingKey.chargeable]
    }
}

public class ChargeSummary: BaseModel {
    public var totalAmount : Double?
    public var currency : String?
    public var lstCharges : [Charges]?
    public override func mapping(map: Map) {
        totalAmount <- map[MappingKey.totalAmount]
        currency <- map[MappingKey.currency]
        lstCharges <- map[MappingKey.lstCharges]
    }
}

public class Charges: BaseModel {
    public var sequence : Int?
    public var icon_id : Int?
    public var descriptionV : String?
    public var value : Int?
    public var amount : Double?
    public var currency : String?
    public var type : String?
    public var chargeable : Bool?
    public var inPlan : Bool?
    public override func mapping(map: Map) {
        sequence <- map[MappingKey.sequence]
        icon_id <- map[MappingKey.iconId]
        descriptionV <- map[MappingKey.description]
        value <- map[MappingKey.value]
        amount <- map[MappingKey.amount]
        currency <- map[MappingKey.currency]
        type <- map[MappingKey.type]
        chargeable <- map[MappingKey.chargeable]
        chargeable <- map[MappingKey.inPlan]
    }
}

public class CurrentBillingData: BillingData {
    public var chargeSummary : ChargeSummary?
    public var allChargeSummary : ChargeSummary?
    public var totalSummation : Double?
    public var outOfPlanSummation : Double?
    public override func mapping(map: Map) {
        super.mapping(map: map)
        chargeSummary <- map[MappingKey.chargeSummary]
        totalSummation <- map[MappingKey.totalSummation]
        outOfPlanSummation <- map[MappingKey.outOfPlanSummation]
        allChargeSummary <- map[MappingKey.allChargeSummary]
    }
}
