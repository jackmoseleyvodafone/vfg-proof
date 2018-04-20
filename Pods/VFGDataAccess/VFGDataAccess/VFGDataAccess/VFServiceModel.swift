//
//  VFServiceModel.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 11/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import UIKit
import ObjectMapper
import Gloss

struct ServicMappingKey {
    static let id : String = "id"
    static let msisdn : String = "msisdn"
    static let name : String = "name"
    static let statusString : String = "status"
    static let type : String = "type"
    static let parts : String = "parts"
    static let packageId : String = "packageId"
    static let packageName : String = "packageName"
    static let packageType : String = "profileType"
    static let dataSharingType : String = "dataSharingType"
}

public class VFServiceModel: BaseModel {
    public var id : String?
    public var msisdn : String?
    public var name: String?
    private var statusString : String?
    public var status: VFSiteModel.Status? {
        if let statusString = statusString {
            return VFSiteModel.Status(rawValue: statusString.lowercased())
        }
        return nil
    }
    public var type: ServiceType?
    public var parts : [VFParts]?
    public var packageId: String?
    public var packageName: String?
    public var packageType: String?
    public var subServices: [VFServiceModel] = []
    public var contracts: [VFCustomerAgreementItem] = []
    public var dataSharingType : DataSharingType?
    
    
    public init(packageId: String?, packageName: String?, packageType: String?, parts: [VFParts]?, subServices: [VFServiceModel]){
        super.init()
        self.packageId = packageId
        self.packageName = packageName
        self.packageType = packageType
        self.parts = parts
        self.subServices = subServices
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.id <- map[ServicMappingKey.id]
        self.msisdn <- map[ServicMappingKey.msisdn]
        self.name <- map[ServicMappingKey.name]
        self.statusString <- map[ServicMappingKey.statusString]
        self.type <- map[ServicMappingKey.type]
        self.parts <- map[ServicMappingKey.parts]
        self.packageId <- map[ServicMappingKey.packageId]
        self.packageName <- map[ServicMappingKey.packageName]
        self.packageType <- map[ServicMappingKey.packageType]
        self.dataSharingType <- map[ServicMappingKey.dataSharingType]
    }
    
    public func getSiteId() -> String {
        var siteId = ""
        if let id = parts?.first?.customeraccounts?.first?.id {
            siteId = id
        } else if let id = parts?.first?.customeraccounts?.first?.links?.id {
            siteId = id
        }
        return siteId
    }
    public enum DataSharingType: String {
        case leader = "owner"
        case member = "member"
    }
    public enum ServiceType: String {
        case mobilePostpaid = "Mobile postpaid"
        case mobilePrepaid = "Mobile prepaid"
        case mbbPrepaid = "MBB prepaid"
        case mbbPostpaid = "MBB postpaid"
        case adsl = "ADSL"
        case fibre = "Fibre"
        case landline = "landline"
        case tv = "TV"
        case undetermined = ""
        
        var imageContractValue: UIImage{
            
            switch self {
            case .mobilePostpaid:
                return #imageLiteral(resourceName: "mobilePostpaid")
            case .mobilePrepaid:
                return #imageLiteral(resourceName: "mobilePrepaid")
            case .mbbPrepaid:
                return #imageLiteral(resourceName: "mbbservice")
            case .mbbPostpaid:
                return #imageLiteral(resourceName: "mbbservice")
            case .adsl:
                return #imageLiteral(resourceName: "adsl")
            case .fibre:
                return #imageLiteral(resourceName: "wifiservice")
            case .landline:
                return #imageLiteral(resourceName: "landLine")
            case .tv:
                return #imageLiteral(resourceName: "tvservice")
            case .undetermined:
                return UIImage.init()
            }
        }
    }
    
    public var isPrepaidService: Bool {
        return type == .mobilePrepaid || type == .mbbPrepaid
    }
    
    //MARK: Gloss
    
    public required init?(json: JSON){
        id = "id" <~~ json
        if id == nil {
            let _id:Int? = "id" <~~ json
            if let _id = _id {
                id = "\(_id)"
            }
        }
        name = "name" <~~ json
        msisdn = "msisdn" <~~ json
        statusString = "status" <~~ json
        type = "type" <~~ json
        parts = "parts" <~~ json
        dataSharingType = "dataSharingType" <~~ json
        
        if  let parts = parts, parts.count > 0 {
            let firstPart = parts[0]
            if let productOffers = firstPart.productOffers, productOffers.count > 0 {
                let firstProductOffer = productOffers[0]
                packageName = firstProductOffer.name
                packageId = firstProductOffer.type
                packageType = firstProductOffer.type
            }
        }
        
        super.init(json: json)
    }

    public override func toJSON() -> JSON? {
        return jsonify([
            "id" ~~> id,
            "msisdn" ~~> msisdn,
            "status" ~~> statusString,
            "type" ~~> type,
            "parts" ~~> parts,
            "name" ~~> name,
            "dataSharingType" ~~>  dataSharingType,
            "packageId" ~~> packageId,
            "packageName" ~~> packageName,
            "packageType" ~~> packageType
            ])
    }

}
