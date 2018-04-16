//
//	RootClass.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class BillingModel : BaseModel{

	public var count : Int?
	public var items : [Item]?
	public var offset : Int?
	public var totalCount : Int?


	class func newInstance(map: Map) -> Mappable?{
		return BillingModel()
	}
    required public init?(map: Map){super.init()}
	private override init(){super.init()}

    override public func mapping(map: Map)
	{
		count <- map["count"]
		items <- map["items"]
		offset <- map["offset"]
		totalCount <- map["totalCount"]
		
	}
}
