//
//    BillDetail.swift
//
//    Create by Mohamed ELMeseery on 10/4/2018
//    Copyright © 2018. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

public class BillDetail : BaseModel{
    
    public var amounts : [Amount]?
    public var ext : BillOverViewExtension?
    public var type : String?
    
    override public func mapping(map: Map) {
        amounts <- map["amounts"]
        ext <- map["extension"]
        type <- map["type"]
    }
}
