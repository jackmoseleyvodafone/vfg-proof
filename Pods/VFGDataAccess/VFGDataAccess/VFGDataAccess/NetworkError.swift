//
// case .swift
//  VFDAF
//
//  Created by Ehab Alsharkawy on 5/29/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

public struct NetworkErrorConstants {
    internal struct Description {
        static let timeOut: String = "timeOut"
        static let cancelled: String = "cancelled"
        static let noConnectionDevice: String = "noConnectionDevice"
        static let noConnectionToHost: String = "noConnectionToHost"
        static let serverNotFound: String = "serverNotFound"
        static let connectionLost: String = "connectionLost"
        static let emptyResponse: String = "emptyResponse"
        static let parser: String = "parserError"
        static let authNotValid: String = "authError"
        
    }
    public struct Key {
        public static let client: String = "DAF_ERR_HTTPS_4xx"
        public static let timeout: String = "DAF_ERR_TIMEOUT"
        public static let cancelled: String = "DAF_ERR_CANCELLED"
        public static let noConnectionDevice: String = "DAF_ERR_NOCONNECTIONDEVICE"
        public static let noConnectionToHost: String = "DAF_ERR_NOCONNECTIONTOHOST"
        public static let serverNotFound: String = "DAF_ERR_SERVERNOTFOUND"
        public static let connectionLost: String = "DAF_ERR_CONNECTION_LOST"
        public static let emptyResponse: String = "DAF_ERR_EMPTYRESPONSE"
        public static let parser: String = "PARSER_ERROR"
        public static let authNotValid: String = "AUTHENICATION_ERROR"
        
    }
}

internal enum NetworkErrorCode: Int {
    case noConnectionDevice = -1004
    case noConnectionToHost = -1009
    case connectionLost = -1005
    case encoding = -1016
    case timeOut = -1001
    case serverNotFound = -1003
    case emptyResponse = -1014
    case internalServerError = 500
    case cancelled = -999
    case parser = -13
    case authNotValid = -15
    
}

internal extension NSError {
    static func generateNetworkError (_ error: NSError) -> NSError {
        var errorKey: String = ""
        var errorDescription: String  = ""
        switch error.code {
        case NetworkErrorCode.noConnectionDevice.rawValue :
            errorKey = NetworkErrorConstants.Key.noConnectionDevice
            errorDescription = NetworkErrorConstants.Description.noConnectionDevice
            break
        case NetworkErrorCode.noConnectionToHost.rawValue :
            errorKey = NetworkErrorConstants.Key.noConnectionToHost
            errorDescription = NetworkErrorConstants.Description.noConnectionToHost
            break
        case NetworkErrorCode.serverNotFound.rawValue :
            errorKey = NetworkErrorConstants.Key.serverNotFound
            errorDescription = NetworkErrorConstants.Description.serverNotFound
            break
        case NetworkErrorCode.connectionLost.rawValue :
            errorKey = NetworkErrorConstants.Key.connectionLost
            errorDescription = NetworkErrorConstants.Description.connectionLost
            break
        case NetworkErrorCode.timeOut.rawValue :
            errorKey = NetworkErrorConstants.Key.timeout
            errorDescription = NetworkErrorConstants.Description.timeOut
            break
        case NetworkErrorCode.emptyResponse.rawValue:
            errorKey = NetworkErrorConstants.Key.emptyResponse
            errorDescription = NetworkErrorConstants.Description.emptyResponse
            break
        case NetworkErrorCode.parser.rawValue :
            errorKey = NetworkErrorConstants.Key.parser
            errorDescription = NetworkErrorConstants.Description.parser
            break
        case NetworkErrorCode.cancelled.rawValue:
            errorKey = NetworkErrorConstants.Key.cancelled
            errorDescription = NetworkErrorConstants.Description.cancelled
            break
        default:
            return error
        }
        let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey: errorDescription ,
                                             NSLocalizedFailureReasonErrorKey: errorKey ]
        let returnedError: NSError = NSError(domain: error.domain, code: error.code, userInfo: userInfo)
        return returnedError
    }
}
