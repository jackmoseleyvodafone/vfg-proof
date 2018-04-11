//
//  VFGErrorManagerDelegate.swift
//  VFGCommonUtils
//
//  Created by Mateusz Zakrzewski on 23/08/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

/**
 This protocol should be implemented by some object (viewcontroller?) on the application side which will be responsible for displaying error messages to end user.
 */
@objc public protocol VFGErrorManagerDelegate : NSObjectProtocol {
    /**
     This method will be called when one of the group components will report an error.
 
     @param error error object with all the informations needed to presesnt it to end user.
     */
    func handleGroupComponentError(_ error : VFGError) -> Int
    
}
