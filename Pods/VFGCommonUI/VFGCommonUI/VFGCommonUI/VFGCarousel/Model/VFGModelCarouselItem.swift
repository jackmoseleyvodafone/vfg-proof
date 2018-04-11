//
//  VFGCarouselItem.swift
//  VFGCarousel
//
//  Created by Lukasz Lewinski on 20/03/2018.
//  Copyright © 2018 Lukasz Lewinski. All rights reserved.
//

import Foundation

public class VFGModelCarouselItem {
    public private(set) var index:              Int?
    public private(set) var id:                 String?
    public private(set) var name:               String?
    public private(set) var showSelectionIcon:  Bool = true
    
    public init(index: Int, id: String, name: String, showSelectionIcon: Bool = true) {
        self.index              = index
        self.id                 = id
        self.name               = name
        self.showSelectionIcon  = showSelectionIcon
    }
}
