//
//  VFServiceTypeServiceModel.swift
//  MyVodafone
//
//  Created by Mohamed Farouk on 10/10/17.
//  Copyright © 2017 TSSE. All rights reserved.
//

import Foundation

public struct VFServiceTypeServiceModel {
    var serviceType: VFServiceModel.ServiceType
    var serviceStatus: VFSiteModel.Status // service status the same model for site
}
