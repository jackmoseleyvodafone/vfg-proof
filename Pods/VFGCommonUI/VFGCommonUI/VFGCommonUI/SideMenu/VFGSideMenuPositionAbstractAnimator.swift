//
//  VFGSideMenuPositionAnimator.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 01/02/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

protocol VFGSideMenuPositionAbstractAnimator {

    weak var sideMenu : UIView! {get set}
    var completion : ((_ : Bool) -> Void)? {get set}

    func animatePositionChange(fromPosition: CGPoint, toPosition: CGPoint)

}
