//
//  VFGSideMenuModel.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 13/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

public enum ItemAction {
    case collapse
    case expand
}

class VFGSideMenuModel: NSObject, VFGSideMenuAbstractModel {
    
    let items : [VFGSideMenuItem]
    
    var expanded : [Bool]
    
    var badgeTextForItem : [ VFGSideMenuItem : String ] = [:]
    
    init(items : [VFGSideMenuItem]) {
        var nodes : [Bool] =  []
        for _ in 0..<items.count {
            nodes.append(false)
        }
        self.items = items
        self.expanded = nodes
    }
    
    func numberOfItems() -> Int {
        var numberOfItemsFromExpandedItems : Int = 0
        
        for index in 0..<items.count {
            if (self.expanded[index]) {
                numberOfItemsFromExpandedItems += self.items[index].subitemsCount()
            }
        }
        
        VFGLogger.log("Number of items " + String(numberOfItemsFromExpandedItems + items.count))
        
        return numberOfItemsFromExpandedItems + items.count
    }
    
    func item(atRow row: Int) -> VFGSideMenuItem? {
        var newRow : Int = row
        
        for index in 0..<items.count {
            if (newRow == 0){
                return items[index]
            } else if (expanded[index]) {
                if (newRow - 1 < items[index].subitems.count) {
                    return items[index].subitems[newRow - 1]
                } else {
                    newRow -= items[index].subitems.count
                }
            }
            newRow -= 1
        }
        
        VFGLogger.log("Item atRow is nil")
        
        return nil
    }
    
    func row(forItem item: VFGSideMenuItem?) -> Int {
        var row : Int = 0
        
        for index in 0..<items.count {
            if items[index] == item {
                return row
            }
            row += 1
            
            if (expanded[index]) {
                for j in 0..<items[index].subitems.count {
                    if items[index].subitems[j] == item {
                        return row
                    }
                    row += 1
                }
            }
        }
        
        VFGLogger.log("Row for item not found")
        
        return NSNotFound
    }
    
    func isExpanded(atRow row: Int) -> Bool {
        let index : Int = indexForMenuItem(atRow: row)
        if (index == NSNotFound) {
            return false
        }
        
        return self.expanded[index]
    }
    
    func isExpandable(atRow row: Int) -> Bool {
        if let item : VFGSideMenuItem = self.item(atRow: row) {
            return item.isExpandable
        }
        
        return false
    }
    
    func expandItem(atRow row: Int, hasSeparator separator: Bool?) -> Int {
        let index : Int = indexForMenuItem(atRow: row)
        if (index == NSNotFound || !self.items[index].isExpandable) {
            
            VFGLogger.log("ExpandItem is returning 0")
            
            return 0
        }
        
        let itemsCount : Int = self.items[index].subitemsCount()
        handleSeparatorForAction(action: .expand, atRow: row, hasSeparator: self.item(atRow: row)?.separator)
        self.expanded[index] = true
        
        return itemsCount
    }
    
    func collapseItem(atRow row: Int, hasSeparator separator: Bool?) -> Int {
        let index : Int = indexForMenuItem(atRow: row)
        if (index == NSNotFound || !self.items[index].isExpandable) {
            
            VFGLogger.log("CollapseItem is returning 0")
            
            return 0
        }
        
        let itemsCount : Int = self.items[index].subitemsCount()
        handleSeparatorForAction(action: .collapse, atRow: row, hasSeparator: self.item(atRow: row)?.subitems[itemsCount - 1].separator)
        
        self.expanded[index] = false
        
        return itemsCount
    }
    
    func is1stLevelItem(atRow row: Int) -> Bool {
        return indexForMenuItem(atRow: row) != NSNotFound
    }
    
    func collapseAll() {
        for index in 0..<expanded.count {
            expanded[index] = false
        }
    }
    
    func badgeTextForItem(_ item: VFGSideMenuItem) -> String? {
        return self.badgeTextForItem[item]
    }
    
    func setBadgeText(_ text: String?, forItem item: VFGSideMenuItem) {
        self.badgeTextForItem[item] = text
    }
    
    private func indexForMenuItem(atRow row: Int) -> Int {
        var newRow : Int = row
        
        for index in 0..<items.count {
            if (newRow == 0){
                return index
            } else if (expanded[index]) {
                if (newRow - 1 < items[index].subitems.count) {
                    return NSNotFound
                } else {
                    newRow -= items[index].subitems.count
                }
            }
            newRow -= 1
        }
        
        VFGLogger.log("Index for menuItem atRow (" + String(row) + ") not found")
        
        return NSNotFound
    }
    
    private func handleSeparatorForAction(action: ItemAction, atRow row: Int, hasSeparator separator: Bool?) {
        let index : Int = indexForMenuItem(atRow: row)
        let itemsCount : Int = self.items[index].subitemsCount()
        
        if let separator = separator {
            if separator {
                let itemToHasSeparator = self.items[index].subitems[itemsCount - 1]
                
                switch action {
                case .expand:
                    self.items[index].separator = false
                    itemToHasSeparator.separator = true
                    break
                case .collapse:
                    self.items[index].separator = true
                    itemToHasSeparator.separator = false
                    break
                    
                }
            }
        }
        
    }
    
}
