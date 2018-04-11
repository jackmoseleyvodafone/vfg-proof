//
//  VFGCommonHeaderContentControllerViewController.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 01/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 Base class for all view controllers that are put inside VFGCommonHeaderContainerController.
 */
open class VFGCommonHeaderContentController: UIViewController {

    /**
     Callback which should be called by VFGCommonHeaderContentController when content is scrolled.
     Purpose of this callback is to inform container (VFGCommonHeaderContainerController) that its views should be scrolled (chipped view and shadow view).
     */
    public var adjustedScrollOffsetChangedCallback : ((_ offset: CGFloat) -> Void)?

    /**
     Initial y position of content presented by VFGCommonHeaderContentController view controller. Initial y position is below chip of chipped view.
     */
    open var originY : CGFloat = 0

    /**
     Called to inform view controller where to place content view. 
     
     - parameter areaRect: Frame in which content view is placed.

     */
    open func layoutContentInArea(_ areaRect : CGRect) {
    }

}
