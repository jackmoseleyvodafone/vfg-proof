//
//  VFGVoiceOfVodafoneViewDelegate.swift
//  Pods
//
//  Created by Ehab Alsharkawy on 9/26/17.
//
//

import Foundation

/**
 Voice of Vodafone protocol
 **/

@objc public protocol VFGVoiceOfVodafoneViewDelegate: NSObjectProtocol {
    
    /**
     Optional function: Return the number of views in scroll view
     */
    @objc optional func maxNumberOfMessages() -> Int
    
    /**
     Optional function: Return the Index for selected view
     
     - Parameter index: the index of the view inside scrollview
     */
    @objc optional func leftButtonDidSelected(_ index: Int)
    
    /**
     Optional function: Return the Index for selected view
     
     - Parameter index: the index of the view inside scrollview
     */
    @objc optional func rightButtonDidSelected(_ index: Int)
}
