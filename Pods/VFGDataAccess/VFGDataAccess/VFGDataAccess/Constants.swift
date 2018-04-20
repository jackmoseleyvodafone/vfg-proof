//
//  Constants.swift
//  VFDAF
//
//  Created by Shimaa Magdi on 5/30/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

public enum CustomerPartyIDType: String {
    case ban = "BAN"
    case textCode = "TaxCode"
    case contactId = "ContactID"
    case msisdn = "MSISDN"
    case email = "Email"
    case other = "OTHER"
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public enum DafServiceNames: String {
    case customerParty = "customerParty"
    case billingData     = "billingData"
    case billingHistory    = "billingHistory"
    case offline
    case concertinaChild = "concertinaChild"
    case ConcertinaSingleOrMultiple = "ConcertinaSingleOrMultiple"
    case childBillsHistory = "childBillsHistory"
    case singleOrMultipleBillsHistory = "singleOrMultipleBillsHistory"
    case childCurrentBalance = "childCurrentBalance"
    case singleCurrentBalance = "singleCurrentBalance"
    case multipleCurrentBalance = "multipleCurrentBalance"
    case onlineTvChangeUserName = "onlineTvChangeUserName"
    case renewBenefit = "renewBenefit"
    case getProduct = "getProduct"
    case getServices = "getServices"
}

public enum CacheMode {
    case RAM
    case DISK
}
