//
//  VoVRepository.swift
//  VFGProof
//
//  Created by vodafone on 16/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit
import VFGVoV
import VFGDataAccess

class VoVRepository: NSObject {

    static func requestVoVWelcomeMessage() -> VFGVovWelcomeMessage {
        
        // fill VFGVoVModel with required data
        let username = "Jack"
        let appname = "MyVodafone POC"
        
        let firstIntervalStart = convertIntervalStringToVFGTime(timeIntervalString: "00:00")
        let firstIntervalEnd = convertIntervalStringToVFGTime(timeIntervalString:"11:59")
        
        let secondIntervalStart = convertIntervalStringToVFGTime(timeIntervalString:"12:00")
        let secondIntervalEnd = convertIntervalStringToVFGTime(timeIntervalString:"17:59")
        
        let thirdIntervalStart = convertIntervalStringToVFGTime(timeIntervalString:"18:00")
        let thirdIntervalEnd = convertIntervalStringToVFGTime(timeIntervalString:"23:59")
        
        let firstIntervalGreeting = NSLocalizedString("good_morning", comment: "")
        let secondIntervalGreeting = NSLocalizedString("good_afternoon", comment: "")
        let thirdIntervalGreeting = NSLocalizedString("good_evening", comment: "")
        let welcomeText = NSLocalizedString("welcome_to", comment: "")
        
        let welcomeMessage = VFGVovWelcomeMessage(username: username,
                                                  appname: appname,
                                                  welcomeMessage: welcomeText,
                                                  morningGreetingModel: VFGVovGreetingModel.init(startInterval: firstIntervalStart, endInterval: firstIntervalEnd, greetingText: firstIntervalGreeting),
                                                  afternoonGreetingModel: VFGVovGreetingModel.init(startInterval: secondIntervalStart, endInterval: secondIntervalEnd, greetingText: secondIntervalGreeting),
                                                  eveningGreetingModel: VFGVovGreetingModel.init(startInterval: thirdIntervalStart, endInterval: thirdIntervalEnd, greetingText: thirdIntervalGreeting))
        
        return welcomeMessage
    }
    
    static func requestVoVCampaignMessages() -> [VFGVovGeneralModel] {
        
        var messages: [VFGVovGeneralModel] = [VFGVovGeneralModel]()
        
        // title
        let title : String = "Title"
        
        // messageBody
        let subtitle: String = "Message"
        
        // setup left and right buttons
        for index in 1...3 {
            
            let rightButton : VFGVovButtonModel  = VFGVovButtonModel.init(isEnabled: true, text: "Right Button", messageIndex:  index)
            
            let leftButton : VFGVovButtonModel = VFGVovButtonModel.init(isEnabled: true, text: "Left Button", messageIndex:  index)
            
            // fill VFGVovGeneralModel with required data
            let generalModel : VFGVovGeneralModel = VFGVovGeneralModel(title: title,
                                                                       subtitle: subtitle,
                                                                       leftButton: leftButton,
                                                                       rightButton: rightButton,
                                                                       campaignType: "",
                                                                       eventLabel: "",
                                                                       recievedDateTimeInterval: 0,
                                                                       campaignName: "",
                                                                       campaignId: "",
                                                                       messageId: index)
            messages.append(generalModel)
        }
        
        return messages
    }
    
    private static func convertIntervalStringToVFGTime(timeIntervalString: String) -> VFGTime {
        let colonOperator: String = ":"
        
        let timeInterval = timeIntervalString.components(separatedBy: colonOperator)
        if let hours = Int(timeInterval.first!), let minutes = Int(timeInterval.last!) {
            return VFGTime(hours: hours, minutes: minutes)
        }
        
        return VFGTime(hours: 0, minutes: 0)
    }
}
