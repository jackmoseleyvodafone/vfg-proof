//
//  AnalyticsHandler.swift
//  VFGSplash
//
//  Created by Ehab Alsharkawy on 11/14/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils

private struct SplashAnalyticsHandlerConstants {
    static let eventActionKey: String = "event_action"
    static let eventCatogeryKey: String = "event_category"
    static let eventLabelKey: String = "event_label"
    static let eventValueKey: String = "event_value"
    static let componentNameKey: String = "page_component_name"
    static let componentVersionKey: String = "page_component_version"
    static let eventPageNameKey: String = "page_name"
    static let eventNextPageNameKey: String = "page_name_next"
    static let appVersionKey:String  = VFGSplashBundle.bundle()?.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
}

internal struct VFGAnalyticsHandler {
    static func trackSplashAppLaunch() {
        let trackViewDec:[String: String] = [
            SplashAnalyticsHandlerConstants.eventActionKey:"splash screen start",
            SplashAnalyticsHandlerConstants.eventCatogeryKey:"In App",
            SplashAnalyticsHandlerConstants.eventLabelKey:"App Launch",
            SplashAnalyticsHandlerConstants.eventValueKey:"1",
            SplashAnalyticsHandlerConstants.componentNameKey:"Splash Screen",
            SplashAnalyticsHandlerConstants.componentVersionKey:SplashAnalyticsHandlerConstants.appVersionKey,
            SplashAnalyticsHandlerConstants.eventPageNameKey:"Splash Screen",
            SplashAnalyticsHandlerConstants.eventNextPageNameKey:"Dashboard"
        ]
        VFGAnalytics.trackView("app_launch", dataSources: trackViewDec)
    }
}
