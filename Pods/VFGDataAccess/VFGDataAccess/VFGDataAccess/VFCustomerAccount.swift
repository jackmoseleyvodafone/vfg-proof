//
//  VFCustomerAccount.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFCustomerAccountMappingKey {
    static let id: String = "id"
    static let links: String = "links"
}

struct VFCustomerAccountLinksMappingKey {
    static let id: String = "id"
}

class VFCustomerAccount: BaseModel {
    
    var id : String?
    var links: VFLinks?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        self.id <- map[VFCustomerAccountMappingKey.id]
        self.links <- map[VFCustomerAccountMappingKey.links]
    }
    
    //MARK: Gloss
    required init?(json: JSON){
        id = VFCustomerAccountMappingKey.id <~~ json
        links = VFCustomerAccountMappingKey.links <~~ json
        super.init(json: json)
    }
    
    override func toJSON() -> JSON? {
        return jsonify([
            VFCustomerAccountMappingKey.id ~~> id,
            VFCustomerAccountMappingKey.links ~~> links
            ])
    }

    
    class VFLinks: BaseModel {
        var id : String?
        
        required init?(map: Map) {
            super.init()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func mapping(map: Map) {
            self.id <- map[VFCustomerAccountLinksMappingKey.id]
        }
        
        //MARK: Gloss
        required init?(json: JSON) {
            id = VFCustomerAccountLinksMappingKey.id <~~ json
            super.init()
        }
        
        override func toJSON() -> JSON? {
            return jsonify([
                VFCustomerAccountLinksMappingKey.id ~~> id
                ])
        }

    }
}

