//
//  VFParts.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFPartsMappingKey {
    static let customerAccounts = "customerAccounts"
    static let productOffers = "productOffers"
}

public class VFParts: BaseModel {
    
    var customeraccounts : [VFCustomerAccount]?
    var productOffers: [VFProductOffer]?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.customeraccounts <- map[VFPartsMappingKey.customerAccounts]
        self.productOffers <- map[VFPartsMappingKey.productOffers]
    }
    
    //MARK: Gloss
    public required init?(json: JSON){
        customeraccounts = VFPartsMappingKey.customerAccounts <~~ json
        productOffers = VFPartsMappingKey.productOffers <~~ json
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        return jsonify([
            VFPartsMappingKey.customerAccounts ~~> customeraccounts,
            VFPartsMappingKey.productOffers ~~> productOffers
            ])
    }
}
