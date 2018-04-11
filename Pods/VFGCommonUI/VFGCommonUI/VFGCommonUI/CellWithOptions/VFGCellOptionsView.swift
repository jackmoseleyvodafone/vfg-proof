//
//  VFGCellOptionsView.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 14/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 View containing options buttons.
*/
public class VFGCellOptionsView: UIView {

    /**
     Buttons representing cell custom options.
     */
    public private(set) var buttons : [VFGCellOptionsButton] = []

    /**
     Create view with option buttons with given parameters

     - Parameter withOptions: options buttons parameters

     */
    public init(withOptions options: [VFGCellOption]) {
        super.init(frame: CGRect.zero)
        self.setButtons(options: options)
        self.translatesAutoresizingMaskIntoConstraints = false;
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    private func setButtons(options: [VFGCellOption]) {
        var buttons : [VFGCellOptionsButton] = []

        for option in options {
            buttons .append(VFGCellOptionsButton(option: option))
        }

        var rightSibling : VFGCellOptionsButton?
        let firstButton = buttons.first
        for button in buttons.reversed() {
            var views = ["button" : button]
            var visualH = "H:"
            if (firstButton == button) {
                visualH.append("|-(0)-")
            }
            visualH.append("[button]")
            if rightSibling == nil {
                visualH.append("-(0)-|")
            } else {
                views["right"] = rightSibling!
                visualH.append("-(0)-[right]")
            }

            self.addSubview(button)

            let constraintsV = self.constraints(withVisual: "V:|[button]|", views: views);
            let constraintsH = self.constraints(withVisual: visualH, views: views);
            self.addConstraints(constraintsH)
            self.addConstraints(constraintsV)

            rightSibling = button
        }

        self.buttons = buttons
    }

    private func constraints(withVisual visual: String, views: [String : Any]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: visual, options: [], metrics: nil, views: views)
    }
    
}
