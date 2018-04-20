//
//  VFServicesResponseModel.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 11/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFServicesResponseMappingKey {
    static let services: String = "items"
}

public class VFServicesResponseModel: BaseModel {
    
    public var services : [VFServiceModel]?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.services <- map[VFServicesResponseMappingKey.services]
    }
    
    //MARK: Gloss
    public required init?(json: JSON){
        services = "items" <~~ json
        super.init(json: json)
    }

    public override func toJSON() -> JSON? {
        return jsonify([
            "items" ~~> services,
            ])
    }

}
