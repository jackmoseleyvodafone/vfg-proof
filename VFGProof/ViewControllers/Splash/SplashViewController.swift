//
//  SplashViewController.swift
//  VFGProof
//
//  Created by vodafone on 16/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGSplash

class SplashViewController: BaseViewController {

    override var rootView: SplashView? {
        get {
            if _rootView == nil {
                let rootView:SplashView = SplashView()
                
                _rootView = rootView
            }
            
            return _rootView as? SplashView
        }
    }
    
    // MARK: - View setup
    
    override func loadView() {
        super.loadView()
        
//        loadProposedSolution();
        
        loadUndocumentedSolution();
    }
    
    //    private func loadProposedSolution() {
    //        self.view.addSubview(VFGAnimatedSplash.sharedInstance.returnViewController().view)
    //
    //        VFGAnimatedSplash.sharedInstance.startSplashAnimation(completion: {
    //            VFGAnimatedSplash.sharedInstance.returnViewController().view.removeFromSuperview()
    //
    //            // set main root view to next screen
    //            self.view = rootView
    //        })
    //    }
    
    private func loadUndocumentedSolution() {
        
        VFGAnimatedSplash.sharedInstance.setComplitionHandler { (result) in
            
            VFGAnimatedSplash.sharedInstance.removeSplashView(completionHandler: nil)
            
            // check data loaded
            
            self.navigationController?.pushViewController(HomeViewController(), animated: false)
        }
        
        VFGAnimatedSplash.sharedInstance.splashInstance = VFGAnimatedSplash.sharedInstance.returnViewController()
        
        VFGAnimatedSplash.sharedInstance.runSplashAnimationFor(timeOut: 2)
    }
    
    // MARK: - Data load
    
    override func loadData() {
    
    }
}
