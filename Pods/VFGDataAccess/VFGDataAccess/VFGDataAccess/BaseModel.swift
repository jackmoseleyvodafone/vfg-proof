//
//  BaseModel.swift
//  VFDAF
//
//  Created by Ehab Alsharkawy on 5/30/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import UIKit
import ObjectMapper

public class BaseModel:NSObject,  Mappable {
    public required init?(map: Map) {}
    public override init() {}
    public func mapping(map: Map) {}
}
