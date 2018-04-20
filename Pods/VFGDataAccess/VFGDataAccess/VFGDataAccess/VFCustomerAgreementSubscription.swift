//
//  VFCustomerAgreementSubscription.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFCustomerAgreementSubscriptionMappingKey {
    static let id: String = "id"
    static let packageField: String = "package"
}

//MARK: - VFSubscription
public class VFCustomerAgreementSubscription: BaseModel {
    
    public var id : String?
    public var packageField : String?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.id <- map[VFCustomerAgreementSubscriptionMappingKey.id]
        self.packageField <- map[VFCustomerAgreementSubscriptionMappingKey.packageField]
    }
    
    //MARK: Glossy
    public required init?(json: JSON){
        id = VFCustomerAgreementSubscriptionMappingKey.id <~~ json
        packageField = VFCustomerAgreementSubscriptionMappingKey.packageField <~~ json
        super.init()
    }
    
    //MARK: Encodable
    public override func toJSON() -> JSON? {
        return jsonify([
            VFCustomerAgreementSubscriptionMappingKey.id ~~> id,
            VFCustomerAgreementSubscriptionMappingKey.packageField ~~> packageField,
            ])
    }

}
