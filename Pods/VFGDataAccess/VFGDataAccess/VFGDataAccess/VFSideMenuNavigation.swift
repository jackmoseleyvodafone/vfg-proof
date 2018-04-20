//
//  VFSideMenuNavigation.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFSideMenuNavigationMappingKey {
    static let type: String = "type"
    static let path: String = "path"
    static let profile: String = "profile"
}

public enum VFNavigationType: String {
    case internalNav = "Internal"
    case externalNav = "External"
}

public class VFSideMenuNavigation: BaseModel {
    public var type : VFNavigationType?
    public var path : String?
    public var profile : String?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.type <- map[VFSideMenuNavigationMappingKey.type]
        self.path <- map[VFSideMenuNavigationMappingKey.path]
        self.profile <- map[VFSideMenuNavigationMappingKey.profile]
    }
    
    //MARK: Gloss
    public required init?(json: JSON){
        path = "path" <~~ json
        type = "type" <~~ json
        profile = "profile" <~~ json
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        return jsonify([
            VFSideMenuNavigationMappingKey.path ~~> path,
            VFSideMenuNavigationMappingKey.type ~~> type,
            VFSideMenuNavigationMappingKey.profile ~~> profile
            ])
    }

}
