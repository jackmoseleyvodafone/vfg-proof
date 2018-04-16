//
//  VoVModel.swift
//  VFGVoV
//
//  Created by Mohamed Magdy on 5/23/17.
//  Copyright © 2017 Mohamed Magdy. All rights reserved.
//

import Foundation
import VFGCommonUtils


public class VFGVovGreetingModel : NSObject {
    public private(set) var greetingText: String
    public private(set) var startInterval: VFGTime = VFGTime(hours: 0, minutes: 0)
    public private(set) var endInterval: VFGTime  = VFGTime(hours: 0, minutes: 0)
    
    public required init(startInterval: VFGTime, endInterval: VFGTime,greetingText : String ) {
        self.startInterval = startInterval
        self.endInterval = endInterval
        self.greetingText = greetingText
    }
}
public class VFGTime : NSObject {
    public private(set) var hours: Int = 0
    public private(set) var minutes: Int = 0
    
    public required init(hours: Int, minutes: Int) {
        self.hours = hours
        self.minutes = minutes
    }
}

public class VFGVovWelcomeMessage : VFGVovBaseModel {
    public static let isWelcomeMessageAnimatedOnceBefore : String = "isWelcomeMessageAnimatedOnceBefore"
    private static let defaultMorningGreeting: String = "Good Morning"
    private static let defaultAfternoonGreeting: String = "Good Afternoon"
    private static let defaultEveningGreeting: String = "Good Evening"
    
    //MARK:- Constants
    public static let defaultMorningInterval: VFGVovGreetingModel = VFGVovGreetingModel(startInterval: VFGTime(hours: 0, minutes: 0), endInterval: VFGTime(hours: 11, minutes: 59), greetingText : defaultMorningGreeting)
    public static let defaultAfternoonInterval: VFGVovGreetingModel = VFGVovGreetingModel(startInterval: VFGTime(hours: 12, minutes: 0), endInterval: VFGTime(hours: 17, minutes: 59), greetingText : defaultAfternoonGreeting)
    public static let defaultEveningInterval: VFGVovGreetingModel = VFGVovGreetingModel(startInterval: VFGTime(hours: 18, minutes: 0), endInterval: VFGTime(hours: 23, minutes: 59), greetingText : defaultEveningGreeting)
    
    
    //MARK:- Properties
    public private(set) var username: String?
    public private(set) var appName: String?
    public private(set) var welcomeMessage: String?
    public private(set) var morningGreetingModel: VFGVovGreetingModel!
    public private(set) var afternoonGreetingModel: VFGVovGreetingModel!
    public private(set) var eveningGreetingModel: VFGVovGreetingModel!
    
    //MARK:- Init
    required public init(username: String?,
                         appname: String?,
                         welcomeMessage: String?,
                         morningGreetingModel: VFGVovGreetingModel = defaultMorningInterval,
                         afternoonGreetingModel: VFGVovGreetingModel = defaultAfternoonInterval,
                         eveningGreetingModel: VFGVovGreetingModel = defaultEveningInterval) {
        super.init()
        self.username = username
        self.appName = appname
        self.welcomeMessage = welcomeMessage
        self.morningGreetingModel = morningGreetingModel
        self.afternoonGreetingModel = afternoonGreetingModel
        self.eveningGreetingModel = eveningGreetingModel
        self.piriorty = .welocomeMessage
        
    }
    //MARK:- Computed Properties
    
    private func getDate(model: VFGTime) -> Date
    {
        
        return Date().dateAt(hours: model.hours, minutes: model.minutes)
    }
    
    /**
     Computed properted that returns the greeting to show based on the previously set time intervals
     */
    public var greetingToShow: String? {
        get {
            
            let morningStartDate = self.getDate(model: morningGreetingModel.startInterval)
            var morningEndDate = self.getDate(model: morningGreetingModel.endInterval)
            if (morningEndDate < morningStartDate) {
                morningEndDate = Calendar.current.date(byAdding: .day, value: 1, to: morningEndDate)!
            }
            
            let afternoonStartDate = self.getDate(model: afternoonGreetingModel.startInterval)
            var afternoonEndDate = self.getDate(model: afternoonGreetingModel.endInterval)
            if (afternoonEndDate < afternoonStartDate) {
                afternoonEndDate = Calendar.current.date(byAdding: .day, value: 1, to: afternoonEndDate)!
            }
            
            let eveningStartDate = self.getDate(model: eveningGreetingModel.startInterval)
            var eveningEndDate = self.getDate(model: eveningGreetingModel.endInterval)
            if (eveningEndDate < eveningStartDate) {
                eveningEndDate = Calendar.current.date(byAdding: .day, value: 1, to: eveningEndDate)!
            }
            
            var currentDate = Date().currentTimeZoneDate()
            

            var result = ""
            if (currentDate.timeIntervalSince1970 >= morningStartDate.timeIntervalSince1970 &&
                currentDate.timeIntervalSince1970 <= morningEndDate.timeIntervalSince1970) {
                result = morningGreetingModel.greetingText
            }
            else if (currentDate.timeIntervalSince1970 >= afternoonStartDate.timeIntervalSince1970 &&
                currentDate.timeIntervalSince1970 <= afternoonEndDate.timeIntervalSince1970) {
                result = afternoonGreetingModel.greetingText
            }
            
            if eveningStartDate.timeIntervalSince1970 > currentDate.timeIntervalSince1970 {
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!

            }
            if (currentDate.timeIntervalSince1970 >= eveningStartDate.timeIntervalSince1970 &&
                currentDate.timeIntervalSince1970 <= eveningEndDate.timeIntervalSince1970) {
                result = eveningGreetingModel.greetingText
            }
            return result
        }
    }
}
