//
//  VFGTealiumHelperProtocol.swift
//  VFGAnalytics
//
//  Created by Mateusz Zakrzewski on 10/07/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

@objc public protocol VFGTealiumHelperProtocol : NSObjectProtocol {
    /**
     This method when be called when app will receive Tealium command.
     
     - parameter command: Tealium remote command object provided by VFGAnalytics
     */
    func executeRemoteCommand(_ command: VFGTealiumHelperRemoteCommand) -> Void
}
