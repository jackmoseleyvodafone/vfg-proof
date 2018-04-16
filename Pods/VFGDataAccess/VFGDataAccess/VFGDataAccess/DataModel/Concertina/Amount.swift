//
//	Amount.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class Amount :BaseModel{

	public var currency : String?
	public var grossAmountDue : Double?
	public var type : [String]?

    /* current balance - Single,Child */
    public var amountCredited : String?
    public var chargedFor : String?
    public var netAmountDue : Double?
    public var taxesCode : String?
    public var taxesDue : Double?

    
    override public func mapping(map: Map)
	{
		currency <- map["currency"]
		grossAmountDue <- map["grossAmountDue"]
		type <- map["type"]
        
        /*current balance - Single, Child*/
        amountCredited <- map["amountCredited"]
        chargedFor <- map["chargedFor"]
        netAmountDue <- map["netAmountDue"]
		taxesCode <- map["taxesCode"]
        taxesDue <- map["taxesDue"]
	}

}
