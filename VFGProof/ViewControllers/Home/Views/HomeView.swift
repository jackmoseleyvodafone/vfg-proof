//
//  HomeView.swift
//  VFGProof
//
//  Created by vodafone on 13/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGVoV

class HomeView: BaseView {
    
    // MARK: - Views
    
    lazy var backgroundImageView: UIImageView = {
        let image: UIImage = UIImage(named: "home-background")!
        let imageView: UIImageView = UIImageView(image: image)
        return imageView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    lazy var vovView: VFGVoiceOfVodafoneView = {
        let view: VFGVoiceOfVodafoneView = VFGVoiceOfVodafoneView()
        return view
    }()
    
    lazy var blankView: UIView = {
        let view: UIView = UIView()
        return view
    }()
    
    // MARK: - View setup
    
    override func setupSubviews() {
        
        addSubview(backgroundImageView)
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(vovView)
        containerView.addSubview(blankView)
    }
    
    override func setupAutolayout() {
        
        // background image view
        backgroundImageView.alignWithView(self)
        
        // scroll view
        scrollView.alignTopAndLeadingEdgesWithView(self, topConstant: 0, leadingConstant: 0)
        scrollView.constrainWidthWithView(self, constant: 0)
        scrollView.constrainHeightWithView(self, constant: 0)
        
        // container view
        containerView.alignTopAndLeadingEdgesWithView(scrollView, topConstant: 0, leadingConstant: 0)
        containerView.constrainWidthWithView(scrollView, constant: 0)
        containerView.alignBottomEdgeWithView(scrollView, constant: 0)
        
        // vov view
        vovView.alignTopAndLeadingEdgesWithView(containerView, topConstant: 64, leadingConstant: 0)
        vovView.alignTrailingEdgeWithView(containerView, constant: 0)
        vovView.constrainWidthWithView(containerView, constant: 0)
        vovView.heightConstraint = vovView.constrainHeight(135)
        
        // blank view
        blankView.alignAttribute(.top, WithView: vovView, Attribute: .bottom, constant: 0)
        blankView.alignLeadingAndTrailingEdgesWithView(containerView, leadingConstant: 0, trailingConstant: 0)
        blankView.constrainHeight(2000)
        blankView.alignBottomEdgeWithView(containerView, constant: 0)
    }
}
