//
//	Item.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class Item : BaseModel{
    public var billDetails : [BillDetail]?
    public var billDocuments : [BillingDocument]?
	public var billOverview : BillOverview?
	public var billingAccount : BillingAccount?
	public var billingCycle : BillingCycle?
	public var creationDate : String?
	public var dueDate : String?
	public var id : String?
	public var paymentDate : String?
	public var status : String?
	public var subscriptions : [Subscription]?
	public var type : String?

    override public func mapping(map: Map)
	{
        /*current balance - single*/
        billDetails <- map["billDetails"]
        billDocuments <- map["documents"]
		billOverview <- map["billOverview"]
		billingAccount <- map["billingAccount"]
		billingCycle <- map["billingCycle"]
		creationDate <- map["creationDate"]
		dueDate <- map["dueDate"]
		id <- map["id"]
		paymentDate <- map["paymentDate"]
		status <- map["status"]
		subscriptions <- map["subscriptions"]
		type <- map["type"]
		
	}


}
