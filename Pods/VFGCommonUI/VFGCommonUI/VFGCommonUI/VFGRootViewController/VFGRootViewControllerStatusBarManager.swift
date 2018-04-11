//
//  VFGRootViewStatusBarManager.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 11/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 Style of status bar background.

 - black: status bar with black background
 - transparent: status bar with transparent background

 */
public enum VFGRootViewControllerStatusBarState  {
    /**
     Status bar with black background
     */
    case black
    /**
     Status bar with transparent background
     */
    case transparent
}

class VFGRootViewControllerStatusBarManager: NSObject {

    var statusBarBackgroundView: UIView? {
        didSet {
            self.update()
        }
    }

    var statusBarState : VFGRootViewControllerStatusBarState = .black {
        didSet {
            self.update()
        }
    }

    private func update() {
        self.statusBarBackgroundView?.backgroundColor = self.statusBarState == .black ? UIColor.black : UIColor.clear
    }

}
