//
//    VFCompany.swift
//
//    Create by Mohamed Farouk on 17/8/2017
//    Copyright © 2017 Vodafone International Services VIS. All rights reserved.


import Foundation
import ObjectMapper
import Gloss

struct CompanyServiceMappingKey {
    static let companySize : String = "companySize"
    static let id : String = "id"
    static let sites : String = "sites"
}

//MARK: - VFCompany
public class VFCompanyServiceModel: BaseModel {
    
    public var isEligableForApp: Bool {
        return true
    }
    
    var companySize : String?
    public var id : String?
    public var sites : [VFSiteModel]?
    
    public required init?(map: Map) {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func mapping(map: Map) {
        self.companySize <- map[CompanyServiceMappingKey.companySize]
        self.id <- map[CompanyServiceMappingKey.id]
        self.sites <- map[CompanyServiceMappingKey.sites]
    }
    
    
    //MARK: Gloss
    public required init?(json: JSON){
        id = CompanyServiceMappingKey.id <~~ json
        sites = CompanyServiceMappingKey.sites <~~ json
        companySize = CompanyServiceMappingKey.companySize <~~ json
        super.init(json: json)
    }
    
    public override func toJSON() -> JSON? {
        return jsonify([
            CompanyServiceMappingKey.id ~~> id,
            CompanyServiceMappingKey.sites ~~> sites,
            CompanyServiceMappingKey.companySize ~~> companySize
            ])
    }


}
