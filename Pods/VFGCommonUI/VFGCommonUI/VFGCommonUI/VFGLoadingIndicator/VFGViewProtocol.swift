//
//  VFGLoadingIndicatorProtocol.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/20/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

@objc public protocol VFGViewProtocol {
    
    /**
     Set loading message of the loading indicator
     - Parameter message: the message to be shown
     */
    @objc optional func setLoadingMessage(_ message: String)
    
    /**
     Shows loading indicator on the view
     */
    @objc optional func showLoadingIndicator()
    
    /**
     Shows loading indicator on the view
     @param backgroundImage optinal UIImage
     @param backgroundColor UIColor with defult value gray color
     */
    @objc optional func showLoadingIndicator(backgroundImage: UIImage?, backgroundColor: UIColor)
    
    /**
     Hides the loading indicator from the view
     */
    @objc optional func hideLoadingIndicator()
    
}


