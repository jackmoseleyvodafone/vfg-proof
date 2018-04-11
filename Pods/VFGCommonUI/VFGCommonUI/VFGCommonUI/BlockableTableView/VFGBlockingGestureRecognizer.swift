//
//  VFGTouchGestureRecognizer.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 09/11/16.
//  Copyright © 2016 Mich. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class VFGBlockingGestureRecognizer: UIGestureRecognizer {

    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.delaysTouchesBegan = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .recognized
    }

}
