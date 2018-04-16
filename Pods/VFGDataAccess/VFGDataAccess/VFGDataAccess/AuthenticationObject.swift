//
//  AuthenticationObject.swift
//  VFGDataAccess
//
//  Created by Mohamed Magdy on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation


public class AuthenticationObject {
    
    // MARK: - Properties
    private(set) var clientID       :String?
    private(set) var clientSecret   :String?
    private(set) var scope          :[String]?
    private(set) var username       :String?
    private(set) var password       :String?
    private(set) var countryCode    :String?
    
    // MARK: - Init
    public init(clientID: String?,
         clientSecret: String?,
         scope: [String]?,
         username:String?,
         password: String?,
         countryCode: String?) {
        
        self.clientID       = clientID
        self.clientSecret   = clientSecret
        self.scope          = scope
        self.username       = username
        self.password       = password
        self.countryCode    = countryCode
        
    }
    
}
