//
//  VFAddressModel.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFAddressModelMappingKey {
    static let buildingNumber: String = "buildingNumber"
    static let county: String = "county"
    static let level: String = "level"
    static let postcode: String = "postcode"
    static let street: String = "street"
    static let town: String = "town"
    static let doornumber: String = "doorNumber"
    static let formattedaddress: String = "formattedAddress"
    static let buildingname: String = "buildingName"
    static let status: String = "status"
}

enum AddressStatus: String {
    case active
    case pendingChange = "pending change"
}

public class VFAddressModel: BaseModel {
    
    var buildingNumber : String?
    var county : String?
    var level : String?
    var postcode : String?
    var street : String?
    var town : String?
    var doornumber : String?
    public var formattedaddress : String?
    var buildingname : String?
    var status: AddressStatus?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.buildingNumber <- map[VFAddressModelMappingKey.buildingNumber]
        self.county <- map[VFAddressModelMappingKey.county]
        self.level <- map[VFAddressModelMappingKey.level]
        self.postcode <- map[VFAddressModelMappingKey.postcode]
        self.street <- map[VFAddressModelMappingKey.street]
        self.doornumber <- map[VFAddressModelMappingKey.doornumber]
        self.formattedaddress <- map[VFAddressModelMappingKey.formattedaddress]
        self.buildingname <- map[VFAddressModelMappingKey.buildingname]
        self.status <- map[VFAddressModelMappingKey.status]
    }
    
    //MARK: Gloss
    public required init?(json: JSON){
        buildingNumber = "buildingNumber" <~~ json
        county = "county" <~~ json
        level = "level" <~~ json
        postcode = "postcode" <~~ json
        street = "street" <~~ json
        town = "town" <~~ json
        doornumber = "doorNumber" <~~ json
        formattedaddress = "formattedAddress" <~~ json
        buildingname = "buildingName" <~~ json
        status = "status" <~~ json
        
        super.init(json: json)
    }

    public override func toJSON() -> JSON? {
        return jsonify([
            "buildingNumber" ~~> buildingNumber,
            "county" ~~> county,
            "level" ~~> level,
            "postCode" ~~> postcode,
            "street" ~~> street,
            "town" ~~> town,
            "doorNumber" ~~> doornumber,
            "formattedAddress" ~~> formattedaddress,
            "buildingName" ~~> buildingname,
            "status" ~~> status,
            ])
    }

}
