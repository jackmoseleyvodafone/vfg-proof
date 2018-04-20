//
//  VFAccountTypesServiceModel.swift
//  MyVodafone
//
//  Created by Mohamed Farouk on 10/10/17.
//  Copyright © 2017 TSSE. All rights reserved.
//

import Foundation

public struct VFAccountTypesServiceModel {
    var type : VFLoggedUserServiceModel.CustomerType
    var serviceTypes :[VFServiceTypeServiceModel]
}
