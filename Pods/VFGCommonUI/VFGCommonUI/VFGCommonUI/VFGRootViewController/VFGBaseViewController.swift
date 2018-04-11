//
//  VFGBaseViewController.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/20/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import PureLayout

open class VFGBaseViewController: UIViewController, VFGViewProtocol {
    
    //MARK: - Instance Variables
    var loadingIndicator: VFGLoadingIndicator = {
        let loading = VFGLoadingIndicator(frame: CGRect.zero, loadingMessage: "Loading...")
        return loading
    }()

    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingFrame()

        
    }
    /**
     Set loading message of the loading indicator
     - Parameter message: the message to be shown
     */
    open func setLoadingMessage(_ message: String) {
        loadingIndicator.setLoadingMessage(message)
    }
    /**
     Shows loading indicator on the view
     */
    open func showLoadingIndicator(){
        self.view.addSubview(loadingIndicator)
    }
    
    open func showLoadingIndicator(backgroundImage: UIImage?, backgroundColor: UIColor = .gray) {
        
        loadingIndicator.isHidden = true
        self.view.addSubview(loadingIndicator)
        
        if let image : UIImage = backgroundImage {
            let backgroundImageView : UIImageView = UIImageView(image: image)
            self.loadingIndicator.addSubview(backgroundImageView)
            self.loadingIndicator.sendSubview(toBack: backgroundImageView)
            self.loadingIndicator.addSubview(backgroundImageView)
            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            let top = NSLayoutConstraint(item: backgroundImageView,
                                         attribute: NSLayoutAttribute.top,
                                         relatedBy: NSLayoutRelation.equal,
                                         toItem: self.loadingIndicator,
                                         attribute: NSLayoutAttribute.top,
                                         multiplier: 1,
                                         constant: 0)
            
            let bottom = NSLayoutConstraint(item: backgroundImageView,
                                            attribute: NSLayoutAttribute.bottom,
                                            relatedBy: NSLayoutRelation.equal,
                                            toItem: self.loadingIndicator,
                                            attribute: NSLayoutAttribute.bottom,
                                            multiplier: 1,
                                            constant: 0)
            
            let leading = NSLayoutConstraint(item: backgroundImageView,
                                             attribute: NSLayoutAttribute.leading,
                                             relatedBy: NSLayoutRelation.equal,
                                             toItem: self.loadingIndicator,
                                             attribute: NSLayoutAttribute.leading,
                                             multiplier: 1,
                                             constant: 0)
            
            let trailing = NSLayoutConstraint(item: backgroundImageView,
                                              attribute: NSLayoutAttribute.trailing,
                                              relatedBy: NSLayoutRelation.equal,
                                              toItem: self.loadingIndicator,
                                              attribute: NSLayoutAttribute.trailing,
                                              multiplier: 1,
                                              constant: 0)
            self.loadingIndicator.addConstraints([top, bottom, trailing, leading])
        }
        
        self.loadingIndicator.backgroundColor = backgroundColor
        
        loadingIndicator.isHidden = false
        
    }
    /**
     Hides the loading indicator from the view
     */
    open func hideLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
    }
    
    /**
     Updates loading indicator's label position relative to the spinner
     - Parameter position: takes a value .top or .bottom to update the text position (Only Top and Botton positions are supported)
     */
    open func updateLoadingIndicatorLabelPosition(position: ALEdge) {
        loadingIndicator.updateTextPositionTo(position: position)
    }
    
    private func setupLoadingFrame() {
        if isTopBarVisible() {
            loadingIndicator.frame = CGRect(x: view.frame.origin.x, y: VFGTopBar.topBarHeight + VFGCommonUISizes.statusBarHeight, width: view.frame.size.width, height: view.frame.size.height - VFGTopBar.topBarHeight - VFGCommonUISizes.statusBarHeight)
        }
        else {
            loadingIndicator.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
        }
        
    }
    
    private func isTopBarVisible() -> Bool {
        if let rootNavigation = VFGRootViewController.shared.containerNavigationController {
            return rootNavigation.viewControllers.count > 1
        }
        return false
    }
}
