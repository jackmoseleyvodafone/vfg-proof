//
//  VFGLogger.swift
//  VFGCommonUtils
//
//  Created by kasa on 26/10/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation

/**
 Default Common library logger, logging action can be customised through closure
 */
@objc public class VFGLogger: NSObject {
    
    /**
     Overridable handling of the logged message, uses NSLog by default

     - parameter message: Message to log
    */
    @objc static public var loggingClosure : (String) -> Void = { (_ message: String) -> Void in
        NSLog(message)
    }
    /**
     Overridable configuration class
     */
    static public var configuration : VFGConfiguration.Type = VFGConfiguration.self
    
    /**
     Path to logs file in app documents directory. By default this is disabled and set to nil. Call VFGLogger.redirectLogsToFile() to enable this functionality.
    */
    static public private(set) var outputFilePath : String? = nil

    //static public var componentsWithDisabledLogging : [VFGLoggingComponent] = [] //TODO this should be provided by Ciphered CoreData, some accessor methods should be provide instead of exposing collection

    /**
     Logs a message applying CoreData filtering configuration on global and component level.

     - parameter component: Optional parameter to use component level filtering configuration (either on/off). Must conform to VFGLoggingComponent protocol

     - parameter format: output String format

     - parameter args: optional arguments for output string format

     */
    static public func log(component: Bundle? = nil,  _ format: String?, _ args: CVarArg...) {
        
        if configuration.loggingEnabled, let format = format {
            if let component = component  {
                if configuration.isLoggingEnabled(for: component) {
                    VFGLogger.loggingClosure(String(format:format, arguments: args))
                }
            } else {
                VFGLogger.loggingClosure(String(format:format, arguments: args))
            }
        }
    }
    
    /**
     Filename which will be used byredirectLogsToFile()
    */
    static internal let logsFileName : String = "VFGDebugTools.log"
    
    /**
     Redirects stdout and stderr to file stored in documents directory. THIS METHOD SHOULD NOT BE USED IN PRODUCTION BUILDS.
    */
    static public func redirectLogsToFile() -> Void {
        let paths : [String] =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory : String = paths[0]
        let stderrOutputFilename : String = VFGLogger.logsFileName
        let stderrOutputURL = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(stderrOutputFilename)
        let stderrOutputFilePath : String = stderrOutputURL.path
        
        freopen(stderrOutputFilePath, "w", stderr)
        
        VFGLogger.outputFilePath = stderrOutputFilePath
    }
}
