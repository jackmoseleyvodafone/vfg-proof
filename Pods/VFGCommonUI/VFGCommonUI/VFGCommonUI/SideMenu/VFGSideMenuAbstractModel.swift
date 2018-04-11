//
//  VFGSideMenuAbstractModel.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 14/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

public protocol VFGSideMenuAbstractModel {
    
    func numberOfItems() -> Int
    func item(atRow row: Int) -> VFGSideMenuItem?
    func row(forItem item: VFGSideMenuItem?) -> Int
    func isExpanded(atRow row: Int) -> Bool
    func isExpandable(atRow row: Int) -> Bool
    func expandItem(atRow row: Int, hasSeparator separator: Bool?) -> Int
    func collapseItem(atRow row: Int, hasSeparator separator: Bool?) -> Int
    func is1stLevelItem(atRow row: Int) -> Bool
    func collapseAll()
    func badgeTextForItem(_ item: VFGSideMenuItem) -> String?
    func setBadgeText(_ text: String?, forItem item: VFGSideMenuItem)
    
}
