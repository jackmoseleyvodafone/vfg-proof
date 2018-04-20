//
//  VFCustomerAgreementItem.swift
//  VFGDataAccess
//
//  Created by Paweł Grzmil on 12/04/2018.
//  Copyright © 2018 VFG. All rights reserved.
//

import Foundation
import ObjectMapper
import Gloss

struct VFCustomerAgreementItemMappingKey {
    static let endDate: String = "endDate"
    static let penalty: String = "penalty"
    static let startDate: String = "startDate"
    static let type: String = "type"
    static let subscription: String = "subscription"
}

//MARK: - Item
public class VFCustomerAgreementItem: BaseModel {
    
    var endDate : String?
    var penalty : String?
    var startDate : String?
    public var type : VFCustomerAgreementContractType?
    public var subscription : VFCustomerAgreementSubscription?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init?(map: Map) {
        super.init()
    }
    
    public override func mapping(map: Map) {
        self.endDate <- map[VFCustomerAgreementItemMappingKey.endDate]
        self.penalty <- map[VFCustomerAgreementItemMappingKey.penalty]
        self.startDate <- map[VFCustomerAgreementItemMappingKey.startDate]
        self.type <- map[VFCustomerAgreementItemMappingKey.type]
        self.subscription <- map[VFCustomerAgreementItemMappingKey.subscription]
    }
    
    //MARK: Gloss
    public required init?(json: JSON){
        endDate = "endDate" <~~ json
        penalty = "penalty" <~~ json
        startDate = "startDate" <~~ json
        type = "type" <~~ json
        subscription = "subscription" <~~ json
        super.init()
    }
    
    public override func toJSON() -> JSON? {
        return jsonify([
            "endDate" ~~> endDate,
            "penalty" ~~> penalty,
            "startDate" ~~> startDate,
            "type" ~~> type,
            "subscription" ~~> subscription,
            ])
    }

}

public enum VFCustomerAgreementContractType: String {
    case valorBundle = "VALOR_BUNDLE"
    case valorNc = "VALOR_NC"
    case promotionTv = "PROMOCION"
    case bundle = "BUNDLE"
    case descuentoCnc = "DESCUENTO CNC"
}
