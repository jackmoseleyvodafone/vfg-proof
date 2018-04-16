//
//	EBilling.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class EBilling : BaseModel{

	public var attachPDF : String?
	public var email : Email?
	public var sms : Sm?
	public var status : String?

    override public func mapping(map: Map)
	{
		attachPDF <- map["attachPDF"]
		email <- map["email"]
		sms <- map["sms"]
		status <- map["status"]
		
	}

}
