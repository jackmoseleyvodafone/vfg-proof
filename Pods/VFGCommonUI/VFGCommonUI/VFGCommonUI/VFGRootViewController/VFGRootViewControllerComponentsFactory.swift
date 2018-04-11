//
//  VFGRootViewControllerComponentsFactory.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 12/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

class VFGRootViewControllerComponentsFactory: NSObject {

    func statusBarManager() -> VFGRootViewControllerStatusBarManager {
        return VFGRootViewControllerStatusBarManager()
    }

    func sideMenuViewController(inViewController controller: UIViewController) -> VFGSideMenuViewController {
        return VFGSideMenuViewController.sideMenuViewController(inViewController: controller)
    }
    
}
