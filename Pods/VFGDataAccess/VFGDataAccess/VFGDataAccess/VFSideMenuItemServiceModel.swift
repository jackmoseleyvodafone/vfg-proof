//
//  VFSideMenuItemServiceModel.swift
//  MyVodafone
//
//  Created by Mohamed Farouk on 10/9/17.
//  Copyright © 2017 TSSE. All rights reserved.
//

import Foundation

public struct VFSideMenuItemServiceModel: Comparable, CustomStringConvertible {
    public var description: String {
        var desc = "|\n|-\(self.id)\n|\n"
        guard let subItems = self.subItems else {
            return desc
        }
        for item in subItems {
            desc += "\t\t\t|\n\t\t\t|-\(item.id)\n\t\t\t|\n"
        }
        return desc
    }
    
    var id : String
    var parentId: String?
    //    var name : String?
    var title: String
    var enabled: Bool
    //    var itemDescription : String?
    var iconName: String?
    var category: Category
    var order: Int
    var apps: [VFAppServiceModel]
    var navigation: VFNavigationServiceModel?
    var account: VFAccountServiceModel?
    var segments: [Segment]
    
    var subItems: [VFSideMenuItemServiceModel]?
    
    enum Category: String, Comparable {
        case account = "Account"
        case service = "Service"
        case general = "General"
        
        static func <(lhs: VFSideMenuItemServiceModel.Category, rhs: VFSideMenuItemServiceModel.Category) -> Bool {
            if lhs == .account {
                return true
            } else if lhs == .general {
                return false
            } else if rhs == .general {
                return true
            }
            return false
        }
    }
    
    // must be small
    public enum Segment: String {
        case diamond = "diamond"
        case gold = "gold"
        case platinum = "platinum"
        case vodafone = "vodafone"
        case all = "all"
        case ono = "ono"
    }
    
    public static func <(lhs: VFSideMenuItemServiceModel, rhs: VFSideMenuItemServiceModel) -> Bool {
        if lhs.category == rhs.category {
            if lhs.order == rhs.order {
                return lhs.id < rhs.id
            }
            return lhs.order < rhs.order
        }
        return lhs.category < rhs.category
    }
    
    public static func ==(lhs: VFSideMenuItemServiceModel, rhs: VFSideMenuItemServiceModel) -> Bool {
        return lhs.category == rhs.category && lhs.order == rhs.order
    }
}
