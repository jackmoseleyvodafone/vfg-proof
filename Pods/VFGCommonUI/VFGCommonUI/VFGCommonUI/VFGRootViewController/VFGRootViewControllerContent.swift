//
//  VFGRootViewControllerContent.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 13/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 View controller implementing this protocol is added to VFGRootViewController and modifies appearance of components on the screen.
 Properties of this protocol modify behaviour of a top bar (VFGTopBar) .
 */
 public protocol VFGRootViewControllerContent {

    /**
     State of a status bar when this view controller is presented.
     */
     var rootViewControllerContentStatusBarState : VFGRootViewControllerStatusBarState { get }

    /**
     Top bar scroll delegate used by top bar when this view controller is presented.
     */
     var rootViewControllerContentTopBarScrollDelegate : VFGTopBarScrollDelegate? { get }

    /**
     Title set on top bar when this view controller is presented.
     */
     var rootViewControllerContentTopBarTitle : String { get set }
    
    
    /**
     Bool for showing or hiding menu burger icon
     */
    var topBarRightButtonHidden: Bool { get set }
    
}
