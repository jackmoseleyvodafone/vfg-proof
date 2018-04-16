//
//  AbstractTarget.swift
//  VFGBilling
//
//  Created by Mohamed Matloub on 3/21/18.
//

import Foundation
import Alamofire
import VFGCommonUtils

public protocol AbstractTarget {
    var baseUrl: URL {get}
    var path: String {get}
    var method: Alamofire.HTTPMethod {get}
    var param: [String:Any] {get}
    var headers: [String : String]? {get}
    var encoding: ParameterEncoding {get}
    var serviceNameForCaching: DafServiceNames{get}
}
public enum BillRequestType:String{
    case balance
    case current
    case history
}

enum BillingApi: AbstractTarget{
    case customerParty(customerPartyID: String,customerPartyIDType:String)
    case customerBills(customerPartyID: String,customerPartyIDType:String)
    case serviceUsage(customerPartyID: String,customerPartyIDType:String)
  
    case concertinaSingleOrMultiple(billingAccountId:String,billRequestType:BillRequestType)
    case concertinaChild(billingAccountId:String,MSISDN:String,billRequestType:BillRequestType)
    
    /*Bills History*/
    case childBillsHistory(billingAccountId:String,MSISDN:String,billRequestType:BillRequestType)
    case singleOrMultipleBillsHistory(billingAccountId:String,billRequestType:BillRequestType)
    
    case offlineLocalFile(url:URL)
    
    /*Current Balance*/
    case singleCurrentBalance(billingAccountId:String,
        billRequestType:BillRequestType)
    case multipleCurrentBalance(billingAccountId:String,
        billRequestType:BillRequestType)
    case childCurrentBalance(billingAccountId:String,
        MSISDN:String,
        billRequestType:BillRequestType)
    
    var baseUrl: URL{
        switch self {
        case .offlineLocalFile(let url):
            return url
        case .customerParty , .customerBills , .serviceUsage:
            return URL(string:"http://vfg-testapp.getsandbox.com/")!
        default:
            return URL(string:VFDAF.configuration.baseURL)!
        }

    }

    var path: String{
        switch self {
        case .customerParty:
        return "getCustomerPartyList"
        case .customerBills:
            return "getCustomerBillList"
        case .serviceUsage:
            return "getCustomerServiceUsageList"
        case .offlineLocalFile:
            return ""
        case .concertinaSingleOrMultiple , .concertinaChild:
            return "v2/payment/customerBills/"
        case .childBillsHistory, .singleOrMultipleBillsHistory:
            return "v2/payment/customerBills/"
        
        /*Current Balance*/
        case .childCurrentBalance,
             .singleCurrentBalance,
             .multipleCurrentBalance:
            return "v2/payment/customerBills/"
        }
    }

    var method: Alamofire.HTTPMethod{
        return .get
    }

    var param: [String : Any]{
        
        switch self {
            case .customerParty(let customerPartyID,let  customerPartyIDType):
                var dic = [String:Any]()
                dic["customerPartyID"] = customerPartyID
                dic["customerPartyIDType"] = customerPartyIDType
                return dic
        case .customerBills(let customerPartyID,let customerPartyIDType):
            var dic = [String:Any]()
            dic["customerPartyID"] = customerPartyID
            dic["customerPartyIDType"] = customerPartyIDType
            return dic
        case .serviceUsage(let customerPartyID,let customerPartyIDType):
            var dic = [String:Any]()
            dic["customerPartyID"] = customerPartyID
            dic["customerPartyIDType"] = customerPartyIDType
            return dic
        case .offlineLocalFile:
            return [:]
        case .concertinaSingleOrMultiple(let billingAccountId, let billRequestType):
            var dic = [String:Any]()
            dic["billingAccountId"] = billingAccountId
            dic["billRequestType"] = billRequestType.rawValue
            return dic
        case .concertinaChild(let billingAccountId, let MSISDN, let billRequestType):
            var dic = [String:Any]()
            dic["billingAccountId"] = billingAccountId
            dic["MSISDN"] = MSISDN
            dic["billRequestType"] = billRequestType.rawValue
            return dic
        case .childBillsHistory(let billingAccountId, let MSISDN, let billRequestType):
            var dic = [String:Any]()
            dic["billingAccountId"] = billingAccountId
            dic["MSISDN"] = MSISDN
            dic["billRequestType"] = billRequestType.rawValue
            return dic
        case .singleOrMultipleBillsHistory(let billingAccountId, let billRequestType):
            var dic = [String:Any]()
            dic["billingAccountId"] = billingAccountId
            dic["billRequestType"] = billRequestType.rawValue
            return dic
        
            /*Current Balance*/
        case .childCurrentBalance(let billingAccountId,
                                  let MSISDN,
                                  let billRequestType):
            var dic = [String:Any]()
            dic["billingAccountId"] = billingAccountId
            dic["MSISDN"] = MSISDN
            dic["billRequestType"] = billRequestType.rawValue
            return dic
        case .singleCurrentBalance(let billingAccountId,
                                   let billRequestType):
            var dic = [String:Any]()
            dic["billingAccountId"] = billingAccountId
            dic["billRequestType"] = billRequestType.rawValue
            return dic
        case .multipleCurrentBalance(let billingAccountId,
                                     let billRequestType):
            var dic = [String:Any]()
            dic["billingAccountId"] = billingAccountId
            dic["billRequestType"] = billRequestType.rawValue
            return dic
        }
        
    }

    var headers: [String : String]?{
        return nil
    }
    
    var encoding: ParameterEncoding{
        return URLEncoding.default
    }
    
    var serviceNameForCaching: DafServiceNames{
        switch self {
        case .customerParty:
            return DafServiceNames.customerParty
        case .customerBills:
            return DafServiceNames.billingHistory
        case .serviceUsage:
            return DafServiceNames.billingData
        case .offlineLocalFile:
            return DafServiceNames.offline
        case .concertinaSingleOrMultiple:
            return .ConcertinaSingleOrMultiple
        case .concertinaChild:
            return .concertinaChild
        case .childBillsHistory:
            return .childBillsHistory
        case .singleOrMultipleBillsHistory:
            return .singleOrMultipleBillsHistory
            
            /*Current Balance*/
        case .childCurrentBalance:
            return .childCurrentBalance
        case .singleCurrentBalance:
            return .singleCurrentBalance
        case .multipleCurrentBalance:
            return .multipleCurrentBalance
        }
    }

}

