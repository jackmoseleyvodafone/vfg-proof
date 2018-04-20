//
//  VFProductOffer.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFProductOfferMappingKey {
    static let code: String = "code"
    static let type: String = "type"
    static let name: String = "name"
}

class VFProductOffer: BaseModel {
    
    var code: String?
    var type: String?
    var name: String?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init?(map: Map) {
        super.init()
    }
    
    override func mapping(map: Map) {
        self.code <- map[VFProductOfferMappingKey.code]
        self.type <- map[VFProductOfferMappingKey.type]
        self.name <- map[VFProductOfferMappingKey.name]
    }
    
    //MARK: Gloss
    required init?(json: JSON){
        code = "code" <~~ json
        type = "type" <~~ json
        name = "name" <~~ json
        super.init(json: json)
    }

    override func toJSON() -> JSON? {
        return jsonify([
            "code" ~~> code,
            "type" ~~> type,
            "name" ~~> name
            ])
    }

}
