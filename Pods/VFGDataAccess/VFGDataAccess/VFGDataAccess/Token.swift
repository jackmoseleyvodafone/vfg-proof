//
//  Token.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation
import ObjectMapper

fileprivate struct MappingKey {
    static let accessToken          : String = "access_token"
    static let expirationTime       : String = "exp"
    static let tokenType            : String = "token_type"
    static let jws                  : String = "jws"
}


class Token: BaseModel {
    var accessToken                 : String?
    var expirationTime              : String?
    var tokenType                   : String?
    var jws                         : String?
    
    
    override func mapping(map: Map) {
        accessToken         <- map[MappingKey.accessToken]
        expirationTime      <- map[MappingKey.expirationTime]
        tokenType           <- map[MappingKey.tokenType]
        jws                 <- map[MappingKey.jws]
    }
}
