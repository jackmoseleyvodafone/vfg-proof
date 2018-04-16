//
//  VFGVovAnalyticsHandler.swift
//  VFGVoV
//
//  Created by Ahmed Elshobary on 8/10/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils
private struct VoVAnalyticsHandlerConstants{
    static let eventKey: String = "event"
    static let eventCatogeryKey: String = "event_category"
    static let eventLabelKey: String = "event_label"
    static let eventActionKey: String = "event_action"
    static let eventValueKey: String = "event_value"
    
    static let eventValue:String = "event_instance"
    static let eventCatogeryValue:String = "Voice of Vodafone"
    static let eventValueValue: String = "1"
    
    static let campaignNameKey: String = "campaign_name"
    static let campaignIDKey: String = "campaign_id"
    static let campaignMediumKey: String = "campaign_medium"
    static let campaignSourceKey: String = "campaign_source"
    
    static let campaignMediumValue: String = "int:vov_details"
    static let campaignSourceValue: String = "vov"
}
public struct VoVAnalyticsHandler {
    public static func trackEventWithCampaign(eventLabel:String?, eventAction:String?, eventName:String? ,campainName:String? ,campainId:String?, eventType:String?) {
        let trackViewDec:[String: String] = [
            VoVAnalyticsHandlerConstants.eventCatogeryKey:VoVAnalyticsHandlerConstants.eventCatogeryValue,
            VoVAnalyticsHandlerConstants.eventLabelKey:eventLabel ?? "",
            VoVAnalyticsHandlerConstants.eventActionKey:eventAction ?? "",
            VoVAnalyticsHandlerConstants.eventValueKey:VoVAnalyticsHandlerConstants.eventValueValue,
            VoVAnalyticsHandlerConstants.campaignNameKey:campainName ?? "",
            VoVAnalyticsHandlerConstants.campaignIDKey:campainId ?? "",
            VoVAnalyticsHandlerConstants.eventKey:eventType ?? "",
            VoVAnalyticsHandlerConstants.campaignMediumKey:VoVAnalyticsHandlerConstants.campaignMediumValue,
            VoVAnalyticsHandlerConstants.campaignSourceKey:VoVAnalyticsHandlerConstants.campaignSourceValue
        ]
        VFGAnalytics.trackEvent(eventName ?? "", dataSources: trackViewDec)
        
    }
    
    public static func trackEventWithoutCampaign(eventLabel:String, eventAction:String, eventName:String) {
        let trackViewDec:[String: String] = [
            VoVAnalyticsHandlerConstants.eventKey:VoVAnalyticsHandlerConstants.eventValue,
            VoVAnalyticsHandlerConstants.eventCatogeryKey:VoVAnalyticsHandlerConstants.eventCatogeryValue,
            VoVAnalyticsHandlerConstants.eventLabelKey:eventLabel,
            VoVAnalyticsHandlerConstants.eventActionKey:eventAction,
            VoVAnalyticsHandlerConstants.eventValueKey:VoVAnalyticsHandlerConstants.eventValueValue]
        VFGAnalytics.trackEvent(eventName, dataSources: trackViewDec)
    }
    public static func trackviewforCampaignClickedOrSucceed(campainName:String? ,campainId:String? , campainEvent:String?, campainEventName:String?) {
        let trackViewDec:[String: String] = [
            VoVAnalyticsHandlerConstants.campaignNameKey:campainName ?? "",
            VoVAnalyticsHandlerConstants.campaignIDKey:campainId ?? "",
            VoVAnalyticsHandlerConstants.campaignMediumKey:VoVAnalyticsHandlerConstants.campaignMediumValue,
            VoVAnalyticsHandlerConstants.campaignSourceKey:VoVAnalyticsHandlerConstants.campaignSourceValue,
            VoVAnalyticsHandlerConstants.eventKey:campainEvent ?? ""
        ]
        VFGAnalytics.trackEvent(campainEventName ?? "" , dataSources: trackViewDec)
    }
    
}
