//
//  AuthenticationManager.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//
import Foundation
import Alamofire
import VFGCommonUtils

//Request Parameters
fileprivate struct RequestParameterKey {
    fileprivate static let grantTypeKey                :String       = "grant_type"
    fileprivate static let clientIDKey                 :String       = "client_id"
    fileprivate static let clientSecretKey             :String       = "client_secret"
    fileprivate static let scopeKey                    :String       = "scope"
    fileprivate static let usernameKey                 :String       = "username"
    fileprivate static let passwordKey                 :String       = "password"

}
//Request Headers
fileprivate struct RequestHeaderKey {
    fileprivate static let contentTypeKey              :String       = "Content-Type"
    fileprivate static let countryCodeKey              :String       = "vf-country-code"
    fileprivate static let acceptanceKey               :String       = "Accept"
}

fileprivate let tokenExpirationOffset                  :Int   = 30

class OAuth2Authentication : AuthenticationManager  {
    
    // MARK: - Properties
    private(set) var authenticationObject               : AuthenticationObject?
    private(set) var tokenObject                        : Token?
    private(set) var tokenArrivalDate                   : Date?
    
    // MARK: - Init
    required init(authenticationObject: AuthenticationObject?) {
        self.authenticationObject = authenticationObject
    }
    
    func getToken(success:@escaping DAFAuthenticationManagerSuccessClosure, failure:  @escaping DAFAuthenticationManagerErrorClosure) {
        let valid = validateAuthObj()
        if valid == true {
            validateToken(token: tokenObject, isTokenCached: true, success: success, failure: failure)
        } else {
            let error = NSError(domain: "", code: NetworkErrorCode.authNotValid.rawValue, userInfo: nil)
            failure(NSError.generateNetworkError(error))
        }
    }
    
    private func generateToken(success:@escaping DAFAuthenticationManagerSuccessClosure, failure:  @escaping DAFAuthenticationManagerErrorClosure){
        
        guard let authObject = authenticationObject else {
            VFGLogger.log("FATAL ERROR: Cannot unwrap authentication object! Calling failure block with default error.")
            failure(NSError())
            return
        }
        
        guard let clientID = authObject.clientID,
            let clientSecret = authObject.clientSecret,
            let clientUsername = authObject.username,
            let clientPassword = authObject.password,
            let clientScope = authObject.scope else {
                VFGLogger.log("FATAL ERROR: Cannot unwrap client data! Calling failure block with default error.")
                failure(NSError())
                return
        }
                
        
        let url                 : String               = VFDAF.configuration.stagingBaseURL + VFDAF.configuration.authTokenPath
        let headersDictionary   : [String : String]    = [RequestHeaderKey.contentTypeKey : "application/x-www-form-urlencoded",
                                                          RequestHeaderKey.countryCodeKey : (authenticationObject?.countryCode ?? ""),
                                                          RequestHeaderKey.acceptanceKey : "application/json"]
        
        let scopeString :String = clientScope.joined(separator: " ")
      
        let parametersDictionary: [String : Any] = [RequestParameterKey.grantTypeKey : "password",
                                                          RequestParameterKey.clientIDKey : clientID,
                                                          RequestParameterKey.clientSecretKey : clientSecret,
                                                          RequestParameterKey.scopeKey : scopeString,
                                                          RequestParameterKey.usernameKey : clientUsername,
                                                          RequestParameterKey.passwordKey : clientPassword
                                                          ]
        
        
        NetworkManager.request(url: url, requestMethod: .post, parameters: parametersDictionary, headers: headersDictionary, parameterEncoding: URLEncoding.default ,success: { jsonObj in
            
            guard let json : [String : Any] = jsonObj as? [String : Any] else {
                VFGLogger.log("FATAL ERROR: Cannot cast JSON to Dictionary. Calling failure block with default error.")
                failure(NSError())
                return
            }
            
            ParserManager.parse(modelObject: Token, json: json, success: {[weak self] (response) in
                guard let strongSelf    = self else{ return }
                strongSelf.tokenObject  = response as? Token
                strongSelf.validateToken(token: strongSelf.tokenObject, isTokenCached: false, success: success, failure: { _ in
                    // TODO: should add error code for token
                    let error = NSError(domain: "", code: NetworkErrorCode.authNotValid.rawValue, userInfo: nil)
                    failure(NSError.generateNetworkError(error))
                })
            }, failure : failure)
            
            
        }, failure: failure)
    }
    
    
    private func refreshToken (){
        // call refresh service
    }
    private func validateToken(token :Token?, isTokenCached: Bool, success:@escaping DAFAuthenticationManagerSuccessClosure, failure:  @escaping DAFAuthenticationManagerErrorClosure){
        
        if token != nil {
            if (token?.accessToken != nil && !isTokenExpired(token: token)){
                success(token)
            }
            else if token?.accessToken == nil {
                // TODO: should add error code for token
                let error = NSError(domain: "", code: NetworkErrorCode.authNotValid.rawValue, userInfo: nil)
                failure(NSError.generateNetworkError(error))
            }
            else{
                if isTokenCached {
                    // TODO: should call refresh
                    generateToken(success: success, failure: failure)
                }
                else {
                    // TODO: should add error code for token
                    let error = NSError(domain: "", code: NetworkErrorCode.authNotValid.rawValue, userInfo: nil)
                    failure(NSError.generateNetworkError(error))
                }
            }
        } else {
            generateToken(success: success, failure: failure)
        }
        
    }
    private func isTokenExpired(token: Token?) -> Bool {
        if let token = token {
            let currentDate = Date().secondsSince1970 + tokenExpirationOffset
            if let tokenExpiration = token.expirationTime {
                if let tokenExpirationInteger = Int(tokenExpiration) {
                    if (tokenExpirationInteger - currentDate > 0) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    private func validateAuthObj() -> Bool {
        var valid = false
        if authenticationObject != nil {
            if (authenticationObject?.clientID != nil  &&
                authenticationObject?.clientSecret != nil &&
                authenticationObject?.scope != nil &&
                authenticationObject?.username != nil &&
                authenticationObject?.password != nil &&
                authenticationObject?.countryCode != nil){
                valid = true
            }
        }
        return valid
    }
}
