//
//  VFGSideMenuItem.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 13/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 Represents item in menu.
 */
public class VFGSideMenuItem : NSObject {
    
    private static let separatorHash : Int = 7
    private static let zeroHashValue : Int = 0

    /**
     Menu item id.
     */
    public let id : Int

    /**
     Menu item title.
     */
    public let title : String
    
    /**
     Menu item image.
     */
    public let image : UIImage?
    
    /**
     Menu right item image.
     */
    public var rightImage : UIImage?
    
    /**
     Sub menu items for this menu item.
     */
    public let subitems : [VFGSideMenuItem]
    /**
     Should item contain separator at the bottom.
     */
    public var separator : Bool
    
    /**
     Should the item be visible or not.
     */
    public var visible : Bool
    
    /**
        parentItem if this item is child and have parent item,may be nil.
     */
    public var parentItem : VFGSideMenuItem?
    
    
    /**
     is the item currently selected in the menu or not
     */
    public var isItemSelected : Bool
    
    /**
     Informs whether this item can be expanded, true if it contains sub items.
     */
    var isExpandable : Bool {
        get {
            return subitems.count != 0
        }
    }
    
    /**
     Hash of the item. Function computes hash based on object title, image and presence of separator. Hash is computed by doing xor of hashes of given values.
     */
    override public var hashValue: Int {
        get {
            return self.title.hash ^ (image?.hash ?? VFGSideMenuItem.zeroHashValue) ^ (separator ? VFGSideMenuItem.separatorHash : VFGSideMenuItem.zeroHashValue)
        }
    }
    
    /**
     Compare two menu items
     */
    public static func ==(lhs: VFGSideMenuItem, rhs: VFGSideMenuItem) -> Bool {
        return lhs.title == rhs.title && lhs.image == rhs.image && lhs.subitems == rhs.subitems && lhs.separator == rhs.separator
    }
    
    /**
     Create menu item object.

     - Parameter title: Menu item title
     - Parameter image: Menu item image
     - Parameter separator: True if element should contain separator view
     - Parameter subitems: Sub menu items for given menu (if given menu item can expand)

     */
    public init(id : Int, title: String, image: UIImage? = nil, separator: Bool = false, subitems: [VFGSideMenuItem] = []) {
        
        self.id = id
        self.title = title
        self.image = image
        self.subitems = subitems
        self.separator = separator
        self.visible = true
        self.isItemSelected = false
        super.init()
        subitems.forEach({$0.parentItem = self})
    }


    /**
     Create menu item object.

     - Parameter title: Menu item title
     - Parameter image: Menu item image
     - Parameter separator: True if element should contain separator view
     - Parameter subitems: Sub menu items for given menu (if given menu item can expand)
     - Parameter visible: True if element should be visible by default

     */
    public convenience init(id : Int, title: String, image: UIImage? = nil, separator: Bool = false, subitems: [VFGSideMenuItem] = [], visible: Bool = false) {
        
        self.init(id : id, title: title, image: image, separator: separator, subitems: subitems)
        self.visible = visible
    }

  
    /**
     Create menu item object.
     
     - Parameter title: Menu item title
     - Parameter image: Menu item image
     - Parameter separator: True if element should contain separator view
     - Parameter subitems: Sub menu items for given menu (if given menu item can expand)
     - Parameter rightImage: Menu item image
     
     */
    public convenience init(id : Int, title: String, image: UIImage? = nil, separator: Bool = false, subitems: [VFGSideMenuItem] = [], rightImage: UIImage? = nil) {
        
        self.init(id : id, title: title, image: image, separator: separator, subitems: subitems)
        self.rightImage = rightImage
    }
    
    
    /**
     Returns number of subitems in given menu item.
     */
    public func subitemsCount() -> Int {
        return self.subitems.count
    }
    
}
