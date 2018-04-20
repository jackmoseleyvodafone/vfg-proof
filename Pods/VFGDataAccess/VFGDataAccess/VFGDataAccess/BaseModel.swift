//
//  BaseModel.swift
//  VFDAF
//
//  Created by Ehab Alsharkawy on 5/30/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Cache
import Gloss

open class BaseModel:NSObject, Glossy, Mappable, Cachable, NSCoding {
    public required init?(map: Map) {}
    public override init() {}
    open func mapping(map: Map) {}
    
    //MARK: Caching methods
    public typealias CacheType = BaseModel
    open func encode(with aCoder: NSCoder) { }
    public required init?(coder aDecoder: NSCoder) { }
    
    //MARK: Glossy parsing methods
    public required init?(json: Gloss.JSON) {}
    
    open func toJSON() -> Gloss.JSON? {
        return nil
    }
}
