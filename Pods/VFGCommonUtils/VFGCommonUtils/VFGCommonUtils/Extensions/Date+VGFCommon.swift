//
//  Date+VGFCommon.swift
//  VFGCommonUtils
//
//  Created by Michał Kłoczko on 03/01/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

/**
 Extension helps handle date specific issues.
 */

fileprivate let timezoneString : String = "GMT"

public extension Date {
    
    /**
     Returns the date converted into time interval in seconds
     */
    public var secondsSince1970: Int {
        return Int((self.timeIntervalSince1970).rounded())
    }
    
    private static var _vfgConfiguredDate : Date? = nil
    
    /**
     Extensions tuple with month and year for given date
     */
    public var monthAndYear : (month: Int, year: Int) {
        get {
            var result = (month: 0, year: 0)
            
            let calendar : Calendar = Calendar.current
            let components : DateComponents = calendar.dateComponents([.month , .year], from: self)
            
            if let month : Int = components.month, let year : Int = components.year {
                result = (month: month, year: year)
            }
            else {
                VFGLogger.log("monthAndYear() failed - Invalid month/year combination")
            }
            
            return result
        }
    }
    
    /**
     Current date provider for group components which allows date overridding.
     */
    static public var vfgConfiguredDate : Date {
        get {
            if let _vfgConfiguredDate = _vfgConfiguredDate {
                return _vfgConfiguredDate
            }
            return Date()
        }
    }
    
    /**
     Get the current time zone Date object
     */
    public func currentTimeZoneDate() -> Date {
        let sourceTimeZone : TimeZone? = TimeZone(abbreviation: timezoneString)
        let destinationTimeZone : TimeZone = TimeZone.current
        guard let sourceGMTOffset : Int = sourceTimeZone?.secondsFromGMT(for: self) else {
            VFGLogger.log("Cannot unwrap sourceTimeZone. Returning default Date()")
            return Date()
        }
        let destinationGMTOffset : Int = destinationTimeZone.secondsFromGMT(for: self)
        let interval : TimeInterval = TimeInterval(destinationGMTOffset - sourceGMTOffset)
        let date : Date = Date(timeInterval: interval, since: self)
        return date
    }
    /**
     Get the date instance at a specific hours and minutes
     */
    public func dateAt(hours: Int, minutes: Int) -> Date
    {
        var result : Date = Date()
        
        guard let calendar : NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) else {
            VFGLogger.log("Cannot construct calend with identifier: " + NSCalendar.Identifier.gregorian.rawValue)
            return result
        }
        
        guard let timezone : TimeZone = TimeZone(abbreviation: timezoneString) else {
            VFGLogger.log("Cannot construct timezone for " + timezoneString)
            return result
        }
        
        var date_components = calendar.components(in: timezone, from: self)
        
        date_components.timeZone = timezone
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        if let newDate : Date = calendar.date(from: date_components) {
            result = newDate
        }
        
        return result
    }
    
    /**
     This method can be used to simulate different time & date. It should not be used in production builds.
     
     - parameter date: date object which will be provided by vfgConfiguredDate instead of real date.
     
     */
    static public func configureDate(_ date : Date?) -> Void {
        
        _vfgConfiguredDate = date
        
    }
}

// MARK: - VFGDateComponent

public extension Date {
    /// Returns a new `Date` by adding a `VFGDateComponent` to this `Date`.
    ///
    /// i.e.:
    /// ```swift
    /// date.adding(3.hours)
    /// // or
    /// date.adding(.hours(3))
    /// ```
    ///
    /// - Parameter dateComponent: The component to add.
    /// - Returns: The new `Date`.
    public func adding(_ dateComponent: VFGDateComponent) -> Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: dateComponent.rawValue.component, value: dateComponent.rawValue.value, to: self)
    }
    
    /// Returns a new `Date` by subtracting a `VFGDateComponent` to this `Date`.
    ///
    /// i.e.:
    /// ```swift
    /// date.subtracting(3.hours)
    /// // or
    /// date.subtracting(.hours(3))
    /// ```
    ///
    /// - Parameter dateComponent: The component to subtract.
    /// - Returns: The new `Date`.
    public func subtracting(_ dateComponent: VFGDateComponent) -> Date? {
        return Calendar.autoupdatingCurrent.date(byAdding: dateComponent.rawValue.component, value: -dateComponent.rawValue.value, to: self)
    }
}

// MARK: - Range Operations

extension Date {
    /// Returns a `Bool` value indicating if the `Date` is between the given dates. It uses a `ClosedRange` (`...`) to evaluate the sentence.
    ///
    /// - Parameters:
    ///   - date1: A `Date`.
    ///   - date2: A `Date`.
    /// - Returns: The `Bool` value.
    public func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

// MARK: - Converts String to Date, with format

extension Date {
    public static func changeDateFormat(date: String) -> (date: Date, dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yy"
            return(date, dateFormatter.string(from: date))
        }else{
            return (Date.init(), "")
        }
    }
    
    public func changeDateFormatTo(toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from:self)
    }
    
}
