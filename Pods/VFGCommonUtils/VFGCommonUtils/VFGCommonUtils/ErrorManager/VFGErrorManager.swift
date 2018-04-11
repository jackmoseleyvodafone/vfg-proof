//
//  VFGErrorManager.swift
//  VFGCommonUtils
//
//  Created by Mateusz Zakrzewski on 23/08/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

/**
 This is an error manager class which should be used by all the components to report errors.
 */
@objc public class VFGErrorManager : NSObject {
    
    /**
     @return Singleton instance of VFGErrorManager
     */
    static public let sharedInstance : VFGErrorManager = VFGErrorManager()
    
    /**
     @return Const integrate action number which should be use to inform VFGErrorManager and group component that error is not supported by VFGErrorManager delegate
     */
    static public let VFGErrorManagerDelegateErrorNotSupported : Int = -1982
    
    /**
     @return VFGErrorManagerDelegate object which is responsible for displaying error messages to the user. Component should not call reportError() but use it's own error displaying code to present data to the user when this property is set to nil.
     */
    public weak var delegate : VFGErrorManagerDelegate?
    
    /**
     This method should be used to report errors which should be handled by VFGErrorManagerDelegate.
     
     @param error VFGError object to report.
     
     @return returns recovery action code from ErrorManagerDelegate.
     */
    @objc public func reportError(_ error : VFGError) -> Int {
        VFGLogger.log("VFGErrorManager dispatching error: ", error.description)
        if let delegate = delegate {
            return delegate.handleGroupComponentError(error)
        }
        
        return VFGErrorManager.VFGErrorManagerDelegateErrorNotSupported
    }
    
    private override init() {
        
    }
}
