//
//  OAuth2Authentication.swift
//  VFGDataAccess
//
//  Created by Shimaa Magdi on 7/25/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import Foundation

internal typealias DAFAuthenticationManagerSuccessClosure = (Token?) -> Void
internal typealias DAFAuthenticationManagerErrorClosure = (NSError) -> Void


protocol AuthenticationManager {
    
    func getToken(success:@escaping DAFAuthenticationManagerSuccessClosure, failure:  @escaping DAFAuthenticationManagerErrorClosure)
    
    
}
