//
//  BaseViewController.swift
//  VFGProof
//
//  Created by vodafone on 03/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGCommonUI

class BaseViewController: UIViewController {
    
    // MARK: - Views
    var _rootView: BaseView?
    
    var rootView: BaseView? { return _rootView }
    
    // MARK: - View Life Cycle Methods
    override func loadView() {
        super.loadView()
        
        if let view = self.rootView {
            self.view = view
        }
        
        loadData()
    }
    
    // MARK: - Data Load
    func loadData() {
        
    }
}
