//
//	Email.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class Email : BaseModel{

	public var emailAddress : String?
	public var status : String?


    override public func mapping(map: Map)
	{
		emailAddress <- map["emailAddress"]
		status <- map["status"]
		
	}

}
