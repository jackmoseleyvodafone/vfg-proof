//
//  VFGVovGeneralModel.swift
//  VFGVoV
//
//  Created by Ehab Alsharkawy on 6/12/17.
//  Copyright © 2017 Vodafone. All rights reserved..
//

import Foundation

public class VFGVovGeneralModel: VFGVovBaseModel {
    public var title: String = ""
    public var subtitle: String = ""
    public var leftButton: VFGVovButtonModel?
    public var rightButton: VFGVovButtonModel?
    public var campaignType: String = ""
    public var eventLabel: String = ""
    public var campaignName: String = ""
    public var campaignId: String = ""
    public var isViewed: Bool? = false
    
    required public init(title: String, subtitle: String, leftButton : VFGVovButtonModel?, rightButton: VFGVovButtonModel?, campaignType:String, eventLabel: String, recievedDateTimeInterval :TimeInterval, campaignName: String ,campaignId: String, messageId: Int) {
        super.init()
        
        print(["title:",title, "\n","subtitle:",subtitle, "\n","left button text:",leftButton?.text, "\n","right button text:",rightButton?.text, "\n"])
        
        self.title = title
        self.subtitle = subtitle
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.campaignType = campaignType
        self.eventLabel  = eventLabel
        self.campaignName = campaignName
        self.campaignId   = campaignId
        self.recievedDate = NSDate(timeIntervalSince1970: recievedDateTimeInterval/1000)
        self.messageId = messageId
        
        if leftButton == nil || leftButton?.text.characters.count == 0 ||
            rightButton == nil || rightButton?.text.characters.count == 0 {
            self.piriorty = .eventDriven
        } else {
            self.piriorty = .cvm
        }
    }
}
