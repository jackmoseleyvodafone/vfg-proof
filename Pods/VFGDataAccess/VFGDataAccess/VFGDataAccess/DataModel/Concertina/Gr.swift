//
//	Gr.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class Gr : BaseModel{


    public var lastOverdueAmount : Double?
    public var averageMonthlyCharge: Double?
    public var billExcludingPastAmount: Double?

    public var otherCharges : Double?
    
    public var lastPaymentAmount : Double?

    override public func mapping(map: Map)
	{
		lastOverdueAmount <- map["lastOverdueAmount"]
		averageMonthlyCharge <- map["averageMonthlyCharge"]
        billExcludingPastAmount <- map["billExcludingPastAmount"]
        otherCharges <- map["otherCharges"]
        lastPaymentAmount <- map["lastPaymentAmount"]

	}

}
