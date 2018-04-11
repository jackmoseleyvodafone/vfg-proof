//
//  VFGError.swift
//  VFGCommonUtils
//
//  Created by Mateusz Zakrzewski on 23/08/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

/**
 This class describes error object which will be used by app to communicate group components errors to end user.
 */
@objc open class VFGError : NSObject {
    /**
     @return error identifier
     */
    public private(set) var identifier : String
    
    /**
     @return group component in which error occured
     */
    public private(set) var component : String?
    
    /**
     @return error title
     */
    public private(set) var errorTitle : String?
    
    /**
     @return error message
     */
    public private(set) var errorMessage : String
    /**
     @return text for buttons (or any other UI object) which will present possible options.
     */
    public private(set) var optionsTexts : [String]
    /**
     @return Code to call for each possible option.
     */
    public private(set) var optionsActions : [(()->Void)?]?
    
    /**
     @return Optional error code connected to this error
     */
    public private(set) var errorCode : Int?
    
    /**
     @return Optional dictionary with extra, error specific data
     */
    public private(set) var extraData : Dictionary<String,Any>?
    
    /**
     Default constructor.
     
     @param identifier Unique error identifier. This will be used in logs, so it cannot be an empty string.
     @param errorTitle Optional error title.
     @param errorMessage Error message.
     @param optionsTexts An array of labels for recovery actions.
     @param optionsActions An array of functions which should be called for recovery actions
     @param errorCode Optional error code connected to this error.
     @param extraData Optional dictionary which allows to pass extra informations.
     
     @return error message
     */
    public init(_ identifier : String, component : String, errorTitle : String?, errorMessage : String, optionsTexts : [String], optionsActions : [(()->Void)?]?, errorCode : Int? = nil, extraData : Dictionary<String,Any>? = nil) {
        self.identifier = identifier
        self.component = component
        self.errorTitle = errorTitle
        self.errorMessage = errorMessage
        self.optionsTexts = optionsTexts
        self.optionsActions = optionsActions
        self.errorCode = errorCode
        self.extraData = extraData
    }
    
    open override var description: String {
        return identifier
    }
}
