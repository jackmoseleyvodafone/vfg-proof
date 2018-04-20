//
//  VFGDayNightHelper.swift
//  VFGCommonUtils
//
//  Created by Mateusz Zakrzewski on 09.12.2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import Foundation
import EDSunriseSet

/**
 This helper structs allows developers to determine if app should be in day or night mode.
 */
@objc public class VFGDayNightHelper: NSObject {
    
    
    public static let GPSDisabledValue : Double = -1
    
    /**
     Sunrise hour (in 24h format) which will be used in non-GPS mode
     */
    public static var sunriseHour : UInt = 6
    
    /**
     Sunset hour (in 24h format) which will be used in non-GPS mode
     */
    public static var sunsetHour : UInt = 19
    
    /**
     This function calculates day/night status based on GPS or configured sunrise/sunset hours. Params are optional and are needed only for GPS mode.
     
     - parameter latitude: latitude returned by core location or from any other source. This parameter is optional.
     - parameter longitude: longitude returned by core location or from any other source. This parameter is optional.
     - returns: true for day mode, false for night mode.
     
     */
    public static func isDay(latitude : Double = GPSDisabledValue, longitude : Double = GPSDisabledValue) -> Bool {
        
        let gpsMode : Bool = ((latitude >= 0) && (longitude >= 0))
        let currentDayHour : UInt = UInt(Calendar.current.component(.hour, from: Date.vfgConfiguredDate))
        
        var sunriseHour : UInt = self.sunriseHour
        var sunsetHour : UInt = self.sunsetHour
        var result : Bool = true
        
        if(gpsMode) {
            if let edSunriseSet : EDSunriseSet = EDSunriseSet(timezone: NSTimeZone.local, latitude: latitude, longitude: longitude) {
                edSunriseSet.calculate(Date.vfgConfiguredDate)
                if let localSunriseHour : Int = edSunriseSet.localSunrise().hour, let localSunsetHour : Int = edSunriseSet.localSunset().hour {
                    sunriseHour = UInt(localSunriseHour)
                    sunsetHour = UInt(localSunsetHour)
                }
                else {
                    VFGLogger.log("Cannot determine day/night based on GPS. Returning default value = " + String(result))
                    return result
                }
            }
        }
        
        if((currentDayHour < sunriseHour) || (currentDayHour > sunsetHour)) {
            result = false
        }
        
        VFGLogger.log("isDay method returns " + String(result))
        return result
    }
        
}
