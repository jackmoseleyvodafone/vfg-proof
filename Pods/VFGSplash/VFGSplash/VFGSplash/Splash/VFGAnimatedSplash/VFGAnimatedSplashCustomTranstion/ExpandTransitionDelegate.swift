//
//  VFGAnimatedSplash.swift
//  VFGAnimatedSplash
//
//  Created by ahmed elshobary on 8/21/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

class ExpandTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ExpandTransitionAnimation()
    }


}
