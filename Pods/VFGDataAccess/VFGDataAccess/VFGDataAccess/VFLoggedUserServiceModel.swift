//
//  VFLoggedUserServiceModel.swift
//  MyVodafone
//
//  Created by Mohamed Amer on 8/9/17.
//  Copyright © 2017 TSSE. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct UserServiceMappingKey {
    
    static var customerType : String = "customerType"
    static var profileType : String = "profileType"
    static var accessToken : String = "accessToken"
    static var refreshToken : String = "refreshToken"
    static var accessTokenExpiryDateID : String = "accessTokenExpiryDate"
    static var refreshTokenExpiryDateID : String = "refreshTokenExpiryDate"
    static var JWT : String = "JWT"
    static var status : String = "status"
    static var companies: String = "companies"
    static var msisdn : String = "msisdn"
    static var document : String = "document"
    static var email: String = "email"
    static var lastPassChangeStamp : String = "lastPassChangeDate"
    static var id: String = "id"
}

public class VFLoggedUserServiceModel: BaseModel {
    public var customerType: CustomerType?
    public var profileType: ProfileType? {
        didSet {
            // VFGTODO
            //CrossVariablesModel.shared.clientPrivileges = profileType?.rawValue ?? ""
        }
    }
    public var accessToken: String?
    public var refreshToken: String?
    public var accessTokenExpiryDate: Date?
    public var refreshTokenExpiryDate: Date?
    public var JWT: String?
    public var status: VFSiteModel.Status?
    var priority: VFSiteModel.Priority {
        return VFSiteModel.calculatePriority(status: self.status)
    }
    public var companies: [VFCompanyServiceModel]?
    public var msisdn: String?
    public var document : VFDocumentModel?
    public var email: String?
    var lastPassChangeStamp: Double?
    var lastPasswordChangeDate: Date?{
        guard let stamp = lastPassChangeStamp else{return nil}
        return Date(timeIntervalSince1970: stamp)
    }
    public var id: String?
    
    public enum CustomerType: String {
        case employee = "Employee"
        case authorized = "Authorized"
        case consumer = "Consumer"
    }
    
    public enum ProfileType: String {
        case light
        case network
        case complete
        case lite
    }
    
    public override init() {
        customerType = nil
        profileType = nil
        accessToken = nil
        refreshToken = nil
        accessTokenExpiryDate = nil
        refreshTokenExpiryDate = nil
        JWT = nil
        status = nil
        companies = nil
        msisdn = nil
        document = nil
        super.init()
    }
       
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.customerType <- map[UserServiceMappingKey.customerType]
        self.profileType <- map[UserServiceMappingKey.profileType]
        self.accessToken <- map[UserServiceMappingKey.accessToken]
        self.refreshToken <- map[UserServiceMappingKey.refreshToken]
        if let accessTokenTimeStamp: Double = (map.JSON[UserServiceMappingKey.accessTokenExpiryDateID] as? Double) {
            self.accessTokenExpiryDate = Date(timeIntervalSince1970: accessTokenTimeStamp)
        }
        if let refreshTokenTimeStamp: Double = (map.JSON[UserServiceMappingKey.refreshTokenExpiryDateID] as? Double) {
            self.refreshTokenExpiryDate = Date(timeIntervalSince1970: refreshTokenTimeStamp)
        }
        self.email <- map[UserServiceMappingKey.email]
        self.lastPassChangeStamp <- map[UserServiceMappingKey.lastPassChangeStamp]
        self.JWT <- map[UserServiceMappingKey.JWT]
        self.status <- map[UserServiceMappingKey.status]
        self.companies <- map[UserServiceMappingKey.companies]
        self.msisdn <- map[UserServiceMappingKey.msisdn]
        self.document <- map[UserServiceMappingKey.document]
        self.id <- map[UserServiceMappingKey.id]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Gloss
    public required init?(json: JSON) {
        super.init()
    }
}
