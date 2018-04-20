//
//  BillingDocument.swift
//  VFGDataAccess
//
//  Created by Mohamed ELMeseery on 4/18/18.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper

public class BillingDocument : BaseModel{
    public var name, desc, type: String?
    
    override public func mapping(map: Map)
    {
        name <- map["name"]
        desc <- map["description"]
        type <- map["type"]        
    }
}
