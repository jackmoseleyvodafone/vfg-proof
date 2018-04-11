//
//  VFGYourMessagesBadgeRefresh.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 24/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 Responsible for updating badge text for "Your Messages" menu item based on Your Messages Badge Refresh Notification.
 */
public class VFGYourMessagesBadgeRefresh: NSObject {

    /**
     Text displayed on badge.
     */
    public var badgeText : String? {
        didSet {
            self.updateBadgeText()
        }
    }

    /**
     "Your messages" Menu item on which to display badge text.
     */
    public var sideMenuItem : VFGSideMenuItem? {
        didSet {
            self.updateBadgeText()
        }
    }

    /**
     Menu containing menu item.
     */
    public var sideMenu: VFGSideMenuViewController? {
        didSet {
            self.updateBadgeText()
        }
    }

    public override init() {
        super.init()
        self.registerForNotifications()
    }

    deinit {
        self.unregisterFromNotifications()
    }

    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(VFGYourMessagesBadgeRefresh.onBadgeCountRefresh), name: VFGResponsiveUI.onBadgeReshreshNotification, object: nil)
    }

    private func unregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self, name: VFGResponsiveUI.onBadgeReshreshNotification, object: nil)
    }

    @objc private func onBadgeCountRefresh(notification : NSNotification) {
        self.badgeText = notification.userInfo?[VFGResponsiveUI.badgeStringKey] as? String
    }

    private func updateBadgeText() {
        if let item : VFGSideMenuItem = self.sideMenuItem {
            self.sideMenu?.setBadgeText(self.badgeText ?? "", forMenuItem: item)
        }
    }
    
}
