//
//  VFGResponsiveUI.swift
//  VFGCommonUI
//
//  Created by kasa on 14/12/2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 * Definitions for Notifications & userInfo keys for responsive UI elements
 */
public class VFGResponsiveUI  {
    /**
     * Show inbox notification
     */
    public static var onShowInboxNotification = NSNotification.Name("onShowInbox")
    /**
     * Badge refresh notification
     */
    public static var onBadgeReshreshNotification = NSNotification.Name("onBadgeReshresh")
    /**
     * Badge string key in userInfo of onBadgeReshreshNotification
     */
    public static var badgeStringKey = "badgeString"

}
