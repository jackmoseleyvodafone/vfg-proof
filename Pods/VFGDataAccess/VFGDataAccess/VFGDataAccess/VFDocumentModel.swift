//
//  VFDocumentModel.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct DocumentModelMappingKey {
    static let id : String = "id"
    static let type : String = "type"
}

//MARK: - VFDocument
public class VFDocumentModel: BaseModel {
    
    var id : String?
    var type : String?
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.id <- map[DocumentModelMappingKey.id]
        self.type <- map[DocumentModelMappingKey.type]
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Gloss
    public required init?(json: JSON){
        id = DocumentModelMappingKey.id <~~ json
        type = DocumentModelMappingKey.type <~~ json
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        return jsonify([
            DocumentModelMappingKey.id ~~> id,
            DocumentModelMappingKey.type ~~> type
            ])
    }

}

