//
//  SplashView.swift
//  VFGProof
//
//  Created by vodafone on 16/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGSplash

class SplashView: BaseView {
    
    // MARK: - Views
    
    lazy var backgroundImageView: UIImageView = {
        let image: UIImage = UIImage(named: "home-background")!
        let imageView: UIImageView = UIImageView(image: image)
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var splashView: UIView = {
        let splashView: UIView = VFGAnimatedSplash.sharedInstance.returnViewController().view
        return splashView
    }()
    
    // MARK: - View setup

    override func setupSubviews() {
        
        backgroundColor = .red
        
        addSubview(backgroundImageView)
        addSubview(splashView)
    }
    
    override func setupAutolayout() {
        
        // background image
        backgroundImageView.alignWithView(self)
        
        // splash view
        splashView.alignWithView(self)
    }
}
