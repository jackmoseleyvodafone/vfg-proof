//
//	BillingCycle.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class BillingCycle : BaseModel{

	public var billingDate : String?
	public var endDate : String?
	public var startDate : String?


    override public func mapping(map: Map)
	{
		billingDate <- map["billingDate"]
		endDate <- map["endDate"]
		startDate <- map["startDate"]
		
	}

   
}
