//
//  VFGAnalytics.swift
//  VFGAnalytics
//
//  Created by kasa on 08/06/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

public class VFGAnalytics : NSObject {
    
    public static var trackEventClosure : ( String, [String : Any]) -> Void = { (title : String, dataSources : [String : Any]) in
        VFGTealiumHelper.sharedInstance.trackEvent(title,dataSources: dataSources)
    }
    
    public static var trackViewClosure : ( String, [String : Any]) -> Void = { (title : String, dataSources : [String : Any]) in
        VFGTealiumHelper.sharedInstance.trackView(title, dataSources: dataSources)
        
    }
    
    public static func trackEvent(_ title: String, dataSources: [String:Any]) {
        VFGLogger.log("Calling track event clousure with title:%@ and data: %@",title, dataSources);
        VFGAnalytics.trackEventClosure(title, dataSources)
    }
    
    public static func trackView(_ title: String, dataSources: [String:Any]) {
        VFGLogger.log("Calling track view clousure with title:%@ and data: %@",title, dataSources);
        VFGAnalytics.trackViewClosure(title, dataSources)
    }
}
