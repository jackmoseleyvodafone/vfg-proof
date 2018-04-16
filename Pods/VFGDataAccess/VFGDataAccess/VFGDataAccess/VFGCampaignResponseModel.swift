//
//  VFGCampaignRequestModel.swift
//  VFGDataAccess
//
//  Created by kasa on 22/06/2017.
//  Copyright © 2017 VFG. All rights reserved.
//

import ObjectMapper

fileprivate struct MappingKey {
    static let tntId : String = "tntId"
    static let edgeHost : String = "edgeHost"
    static let content : String = "messages"
    static let sessionId : String = "sessionId"
    static let primary : String = "primary"
    static let secondary : String = "secondary"
    static let errors : String = "errors"
    static let messages : String = "data"
    static let commandId : String = "command_id"
    static let event : String = "event"
    static let debug : String = "debug"
    static let type : String = "type"
}

/**
 *  Model of VFGCampaignResponseModel for Voice of Vodafone Component
 *
 - sessionId : For seesion Id
 - content : For object of VovMessage
 */

public class VFGCampaignResponseModel : BaseModel {
    
    public var commandId : String?
    public var vovRequestPayload : [VovRequestPayload]?
    public var errors : Int?
    public var debug : String?
    public var type : String?
    
    public override func mapping(map: Map) {
        self.commandId <- map[MappingKey.commandId]
        self.vovRequestPayload  <- map[MappingKey.content]
        self.debug  <- map[MappingKey.debug]
    }
}

public class VovRequestPayload : BaseModel {
    public var primary : VovMessage?
    public var secondary : VovMessage?
    public var errors : Int?
    
    public override func mapping(map: Map) {
        self.errors   <- map[MappingKey.errors]
        self.primary <- map[MappingKey.primary]
        self.secondary <- (map[MappingKey.secondary])
    }
}
