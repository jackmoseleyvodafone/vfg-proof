//
//	Subscription.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class Subscription : BaseModel{

	public var desc : String?
	public var id : String?
	public var name : String?
	public var type : String?


    override public func mapping(map: Map)
	{
		desc <- map["desc"]
		id <- map["id"]
		name <- map["name"]
		type <- map["type"]
		
	}

   
}
