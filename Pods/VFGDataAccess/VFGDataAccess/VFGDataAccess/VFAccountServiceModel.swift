//
//  VFAccountServiceModel.swift
//  MyVodafone
//
//  Created by Mohamed Farouk on 10/10/17.
//  Copyright © 2017 TSSE. All rights reserved.
//

import Foundation

// Account also known as Site
struct VFAccountServiceModel {
    var statuses : [VFSiteModel.Status]
    var accountTypes : [VFAccountTypesServiceModel]
}
