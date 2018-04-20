//
//  VFSiteModel.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct SiteMappingKey {
    static let address: String = "address"
    static let billingpayer: String = "billingPayer"
    static let email: String = "email"
    static let familyname: String = "familyName"
    static let middleName: String = "middleName"
    static let firstname: String = "firstname"
    static let id: String = "id"
    static let msisdn: String = "msisdn"
    static let statusString: String = "status"
}

public class VFSiteModel: BaseModel, NSCopying {
    
    public var address : VFAddressModel?
    public var billingpayer : String?
    public var email : String?
    public var familyname : String?
    public var middleName : String?
    public var firstname : String?
    public var id : String?
    public var msisdn : String?
    private var statusString : String?
    public lazy var type : VFSiteType? = { [unowned self] in
        var _type: VFSiteType? = nil
        if let services = self.services {
            for  model:VFServiceModel in services {
                if (model.type != .mobilePrepaid && model.type != .mbbPrepaid) {
                    _type = .postpaid
                    break
                } else {
                    _type = .prepaid
                }
            }
        }
        return _type
        }()
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.address <- map[SiteMappingKey.address]
        self.billingpayer <- map[SiteMappingKey.billingpayer]
        self.email <- map[SiteMappingKey.email]
        self.familyname <- map[SiteMappingKey.familyname]
        self.middleName <- map[SiteMappingKey.middleName]
        self.firstname <- map[SiteMappingKey.firstname]
        self.id <- map[SiteMappingKey.id]
        self.msisdn <- map[SiteMappingKey.msisdn]
        self.statusString <- map[SiteMappingKey.statusString]
        if let _segment = _segment {
            segment =  VFSideMenuItemServiceModel.Segment(rawValue: _segment.lowercased()) ?? .vodafone
        }
    }
    
    override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(json: JSON) {
        super.init()
    }

    
    static func ==(lhs: VFSiteModel, rhs: VFSiteModel) -> Bool {
        if let lid = lhs.id, let rid = rhs.id, lid == rid {
            return true
        }
        return false
    }
    
    public func copy(with zone: NSZone? = nil) -> Any {
        let copySiteModel = VFSiteModel()
        copySiteModel.email  = self.email
        copySiteModel.familyname = self.familyname
        copySiteModel.middleName = self.middleName
        copySiteModel.msisdn = self.msisdn
        copySiteModel.firstname = self.firstname
        copySiteModel.id = self.id
        //TODO: complets all values
        return copySiteModel
    }
    
    var isServicesPrepaidAndInternetOnly: Bool {
        if let services = self.services {
            for  model:VFServiceModel in services {
                if (model.type != .mobilePrepaid && model.type != .mbbPrepaid && model.type != .fibre && model.type != .adsl) {
                    return false
                }
            }
        }
        else {
            return false
        }
        return true
    }
    
    private var _segment: String?
    public var segment: VFSideMenuItemServiceModel.Segment = .vodafone
    public var services: [VFServiceModel]? = [VFServiceModel]()
    public var status: VFSiteModel.Status? {
        if let statusString = statusString {
            return VFSiteModel.Status(rawValue: statusString.lowercased())
        }
        return nil
    }
    
    var flatServices: [VFServiceModel] {
        guard let services = self.services else {return []}
        return services.flatMap { (service) -> [VFServiceModel] in
            if service.subServices.count > 0 {
                return service.subServices
            }else{
                return [service]
            }
        }
    }
    
    var priority: Priority {
        return VFSiteModel.calculatePriority(status: self.status)
    }
    
    
    
    var userName: String? {
        return firstname! + " " + (familyname ?? "")
    }
    
    var fullName:String {
        var firstName = ""
        if let fn = self.firstname {
            firstName = fn
        }
        var middleName = ""
        if let mn = self.middleName {
            middleName = mn
        }
        var familyName = ""
        if let fn = self.familyname {
            familyName = fn
        }
        return "\(firstName) \(middleName) \(familyName)"
    }
    
    public static func calculatePriority(status: VFSiteModel.Status?) -> VFSiteModel.Priority {
        if let status = status {
            switch status {
            // priority 1
            case .active, .pendingChange, .pendingDisconnect:
                return .one
            // priority 2 nudge 1
            case .suspended, .pendingReconnect,.disconnectedLess6:
                return .two(status: status)
            // priority 2 nudge 2
            case .disconnectedNoPayementLess6:
                return .two(status: status)
            // priority 3
            case .pendingInstall, .disconnectedNoPaymentMore6, .disconnectedMore6, .cancelled:
                return .three
            }
        }
        return .one
    }
    
    public enum VFSiteType: String {
        case postpaid = "Postpaid"
        case prepaid = "Prepaid"
        case empty = ""
    }
    
    public enum Status: String {
        
        case active = "activo"
        case pendingChange = "pend de cambio"
        case pendingDisconnect = "pend de desconectar"
        case suspended = "suspendido"
        case pendingReconnect = "pend de reconectar"
        case disconnectedNoPayementLess6 = "desconectado no pago"
        case disconnectedLess6 = "desconectado"
        case pendingInstall = "pending_install"
        case disconnectedNoPaymentMore6 = "discon_nopay_more6"
        case disconnectedMore6 = "discon_more6"
        case cancelled = "cancelled"
    }
    
    public enum Priority {
        case one
        case two(status: VFSiteModel.Status?)
        case three
    }
}

