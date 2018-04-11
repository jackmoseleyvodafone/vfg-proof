//
//  VFGHeader.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/10/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public class VFGHeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.applyStyle(VFGTextStyle.headerColored(UIColor.VFGBlack))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyStyle(VFGTextStyle.headerColored(UIColor.VFGBlack))
    }
}
