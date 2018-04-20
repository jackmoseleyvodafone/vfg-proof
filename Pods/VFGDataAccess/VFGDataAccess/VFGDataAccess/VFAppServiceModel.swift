//
//  VFAppServiceModel.swift
//  MyVodafone
//
//  Created by Mohamed Farouk on 10/10/17.
//  Copyright © 2017 TSSE. All rights reserved.
//

import Foundation

struct VFAppServiceModel {
    var platform : Platform
    var from : String
    var to : String
    
    enum Platform: String {
        case android = "android"
        case ios = "ios"
        case mobileWeb = "web"
    }
}
