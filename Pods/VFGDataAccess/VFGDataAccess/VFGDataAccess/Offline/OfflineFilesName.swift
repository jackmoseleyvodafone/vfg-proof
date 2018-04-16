//
//  OfflineFilesName.swift
//  VFGDataAccess
//
//  Created by Mohamed Matloub on 3/27/18.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation

internal enum OfflineFilesName: String{
    case customerParty = "getCustomerPartyList"
    case customerBills = "getCustomerBillList"
    case serviceUsage = "getCustomerServiceUsageList"
    
    case ConcertinaSingleOrMultiple = "ConcertinaSingleOrMultiple"
    case ConcertinaChild = "ConcertinaChild"
    case BillsHistory = "billsHistory"
    case childCurrentBalance = "Child_Current_Balance"
    case singleCurrentBalance = "Single_Current_Balance"
    case multipleCurrentBalance = "Multi_Current_Balance"
    case singleCurrentBalanceOverview = "Single_Current_Balance_Overview"
    case multipleCurrentBalanceOverview = "Multi_Current_Balance_Overview"
    
    func getFileUrl()-> URL?{
        return VFGDAFBundle.bundle()?.url(forResource: self.rawValue, withExtension: "json")
    }
}
