//
//	RootClass.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper
import Gloss

public class BillingModel : BaseModel{

	public var count : Int?
	public var items : [Item]?
	public var offset : Int?
	public var totalCount : Int?

	class func newInstance(map: Map) -> Mappable?{
		return BillingModel()
	}
    
    public required init?(map: Map){
        super.init()
    }
    
    public required init?(json: JSON) {
        super.init()
    }
	
    private override init(){
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func mapping(map: Map)
	{
		count <- map["count"]
		items <- map["items"]
		offset <- map["offset"]
		totalCount <- map["totalCount"]
		
	}
}
