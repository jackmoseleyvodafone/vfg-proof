//
//  VFGVovButtonModel.swift
//  Pods
//
//  Created by Ehab Alsharkawy on 6/12/17.
//  Copyright © 2017 Vodafone. All rights reserved..
//

import Foundation

@objc public enum ActivityAction : Int {
    case call = 0
    case internalWebView = 1
    case externalBrowser = 2
    case deepLink = 3
}

public class VFGVovButtonModel:NSObject {
    public var isEnabled: Bool
    public var text: String
    public var messageIndex: Int
    
    public init(isEnabled: Bool, text: String, messageIndex : Int) {
        self.isEnabled = isEnabled
        self.text = text
        self.messageIndex  = messageIndex
    }
}
