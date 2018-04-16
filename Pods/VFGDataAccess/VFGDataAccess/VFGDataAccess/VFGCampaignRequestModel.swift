//
//  VFGCampaignRequestModel.swift
//  VFGDataAccess
//
//  Created by Ehab Alsharkawy on 7/4/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

/**
 *  Model of VFGCampaignResponseModel for Voice of Vodafone Component
 *
 - billDueDate : For bill Due Date as String
 - creditBalance : For object of VovMessage as String
 - dataUsageBalance : For data of usage Balance as String
 - dataUsageLimit : For data Usage Limit as String
 - dataUsed : For data Used as String
 - dateOfBirth : For date Of Birth as String
 - firstName : For first Name as String
 - language : For language as String
 - lastBillAmount : For last Bill Amount as String
 - lastName : For last Name as String
 - remainingDuration : For remaining Duration as String
 - remainingUnit : For remaining Unit as String
 - subscriptionName : For subscription Name as String
 - subscriptionType : For subscription Type as String
 */

public class VFGCampaignRequestModel : NSObject {
    public var billDueDate : String?
    public var creditBalance : String?
    public var dataUsageBalance : String?
    public var dataUsageLimit : String?
    public var dataUsed : String?
    public var dateOfBirth : String?
    public var firstName : String?
    public var language : String?
    public var lastBillAmount : String?
    public var lastName : String?
    public var remainingDuration : String?
    public var remainingUnit : String?
    public var subscriptionName : String?
    public var subscriptionType : String?
    /**
     *  init method for  VFGCampaignRequestModel initialization
     *  @param newlist of type Array of VovMessage
     *  @return VFGCampaignManagerSuccessClosure : call back response with String success message
     *  @return VFGCampaignErrorClosure : call back NSError response
     */
    public override init() {
        super.init()
        billDueDate = ""
        creditBalance = ""
        dataUsageBalance = ""
        dataUsageLimit = ""
        dataUsed = ""
        dateOfBirth = ""
        firstName = ""
        language = ""
        lastBillAmount = ""
        lastName = ""
        remainingDuration = ""
        remainingUnit = ""
        subscriptionName = ""
        subscriptionType = ""
    }
    public init(billDueDate : String, creditBalance : String, dataUsageBalance : String, dataUsageLimit : String, dataUsed : String, dateofBirth : String, firstName : String, lastName : String, remainingDuration : String, remainingUnit : String, subscriptionName : String, subscriptionType : String) {
        
        self.billDueDate = billDueDate
        self.creditBalance = creditBalance
        self.dataUsageBalance = dataUsageBalance
        self.dataUsageLimit = dataUsageLimit
        self.dataUsed = dataUsed
        self.dateOfBirth = dateofBirth
        self.firstName = firstName
        self.lastName = lastName
        self.remainingDuration = remainingDuration
        self.remainingUnit = remainingUnit
        self.subscriptionName = subscriptionName
        self.subscriptionType = subscriptionType
    }
}
