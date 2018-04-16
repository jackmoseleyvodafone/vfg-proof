//
//	BillOverview.swift
//
//	Create by Mohamed Matloub on 29/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


public class BillOverview : BaseModel{

	public var amounts : [Amount]?
	public var billExtension : BillOverViewExtension?


    override public func mapping(map: Map)
	{
		amounts <- map["amounts"]
		billExtension <- map["extension"]
		
	}

}
