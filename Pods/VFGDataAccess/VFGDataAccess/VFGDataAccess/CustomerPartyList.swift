//
//  CustomerPartyList.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 6/7/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import ObjectMapper

fileprivate struct MappingKey {
    static let parts: String = "parts"
    static let individual: String = "individual"
    static let name: String = "name"
    static let firstName: String = "first_name"
    static let middleName: String = "middle_name"
    static let familyName: String = "family_name"
    static let middleInitial: String = "middle_initial"
    static let formattedName: String = "formatted_name"
    static let tariffName: String = "tariff_name"
    static let accountNumber: String = "account_number"
    static let subscriberId: String = "subscriber_id"
    static let accountType: String = "account_type"
    static let billCycle: String = "billCycle"
    static let msisdn: String = "msisdn"
    static let email: String = "email"
    static let username: String = "username"
    static let billStatus: String = "billStatus"
    static let childs: String = "childs"
    
}

public class CustomerPartyList: BaseModel {
    public var parts: Parts?
    public override func mapping(map: Map) {
        parts <- map[MappingKey.parts]
    }
}

public class Parts: BaseModel {
    public var individual: Individual?
    public override func mapping(map: Map) {
        individual <- map[MappingKey.individual]
    }
}

public class Individual: Person {
    public var childs: [Person]?
    public override func mapping(map: Map) {
        super.mapping(map: map)
        childs <- map[MappingKey.childs]
    }
}

public class Person: BaseModel {
    public var name: String?
    public var firstName: String?
    public var middleName: String?
    public var middleInitial: String?
    public var familyName: String?
    public var formattedName: String?
    public var tariffName: String?
    public var accountNumber: Int?
    public var subscriberId: String?
    public var accountType: String?
    public var billCycle: String?
    public var billStatus: BillStatus?
    public var msisdn: String?
    public var email: String?
    public var username: String?
    public override func mapping(map: Map) {
        name <- map[MappingKey.name]
        firstName <- map[MappingKey.firstName]
        middleName <- map[MappingKey.middleName]
        middleInitial <- map[MappingKey.middleInitial]
        familyName <- map[MappingKey.familyName]
        formattedName <- map[MappingKey.formattedName]
        tariffName <- map[MappingKey.tariffName]
        accountNumber <- map[MappingKey.accountNumber]
        subscriberId <- map[MappingKey.subscriberId]
        accountType <- map[MappingKey.accountType]
        billCycle <- map[MappingKey.billCycle]
        billStatus <- map[MappingKey.billStatus]
        msisdn <- map[MappingKey.msisdn]
        email <- map[MappingKey.email]
        username <- map[MappingKey.username]
    }
}
