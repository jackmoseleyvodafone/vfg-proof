//
//	BillingAccount.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class BillingAccount : BaseModel{

	public var alias : String?
	public var eBilling : EBilling?
	public var id : String?
	public var name : String?
	public var paymentMethod : PaymentMethod?


    override public func mapping(map: Map)
	{
		alias <- map["alias"]
		eBilling <- map["eBilling"]
		id <- map["id"]
		name <- map["name"]
		paymentMethod <- map["paymentMethod"]
		
	}

}
