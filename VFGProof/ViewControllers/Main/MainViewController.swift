//
//  MainViewController.swift
//  VFGProof
//
//  Created by vodafone on 03/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGSplash

class MainViewController: BaseViewController {
    
    override func loadView() {
        super.loadView()
        
//        loadProposedSolution();
        
//        loadUndocumentedSolution();
    }
    
    private func loadProposedSolution() {
//        self.view.addSubview(VFGAnimatedSplash.sharedInstance.returnViewController().view)
//
//            VFGAnimatedSplash.sharedInstance.startSplashAnimation(completion: {
//            VFGAnimatedSplash.sharedInstance.returnViewController().view.removeFromSuperview()
//
//            // set main root view to next screen
//            self.view = rootView
//        })
    }
    
    private func loadUndocumentedSolution() {
        
        VFGAnimatedSplash.sharedInstance.setComplitionHandler { (result) in
            VFGAnimatedSplash.sharedInstance.returnViewController().view.removeFromSuperview()
        }

        self.view.addSubview(VFGAnimatedSplash.sharedInstance.returnViewController().view)
        
        VFGAnimatedSplash.sharedInstance.splashInstance = VFGAnimatedSplash.sharedInstance.returnViewController()

        VFGAnimatedSplash.sharedInstance.runSplashAnimationFor(timeOut: 2)
    }
}
