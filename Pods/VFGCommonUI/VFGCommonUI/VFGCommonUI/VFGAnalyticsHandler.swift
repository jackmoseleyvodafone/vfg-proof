//
//  VFGAnalyticsHandler.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 10/18/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils

private struct CommonUIAnalyticsHandlerConstants {
    
    static let eventActionKey: String = "event_action"
    static let eventCatogeryKey: String = "event_category"
    static let eventLabelKey: String = "event_label"
    static let eventValueKey: String = "event_value"
    static let eventPageNameKey: String = "page_name"
    static let eventNextPageNameKey: String = "page_name_next"
    static let eventInstanceKey: String = "event_instance"
}


internal struct VFGAnalyticsHandler {
    
    static func trackEventForFloatingBubbleClick() {
        
        let trackEventDec :[String: String] = [
            
            CommonUIAnalyticsHandlerConstants.eventActionKey: "Button Click" ,
            CommonUIAnalyticsHandlerConstants.eventCatogeryKey:"UI Interactions" ,
            CommonUIAnalyticsHandlerConstants.eventLabelKey: "Need Help?",
            CommonUIAnalyticsHandlerConstants.eventValueKey: "1",
            CommonUIAnalyticsHandlerConstants.eventPageNameKey:"Dashboard",
            CommonUIAnalyticsHandlerConstants.eventNextPageNameKey:"FAQs"
        ]
        
       VFGAnalytics.trackEvent(CommonUIAnalyticsHandlerConstants.eventInstanceKey,
                               dataSources: trackEventDec)
    }
}
