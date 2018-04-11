//
//  VFGCellOption.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 14/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 Class providing parameters to create custom cell option button, VFGCellOptionsButton.
 */
public class VFGCellOption: NSObject {

    let image : UIImage?
    let text : String
    let textColor : UIColor?
    let backgroundColor : UIColor?

    /**
     Create parameters for custom cell option button

     - Parameter text: text displayed on option button
     - Parameter image: image displayed on option button
     - Parameter textColor: color of text displayed on options button
     - Parameter backgroundColor: background color of options button

     */
    public init(text: String, image: UIImage?, textColor: UIColor?, backgroundColor: UIColor?) {
        self.text = text
        self.image = image
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}
