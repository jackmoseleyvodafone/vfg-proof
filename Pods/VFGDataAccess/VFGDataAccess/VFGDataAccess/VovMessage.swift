//
//  VovMessage.swift
//  VFGDataAccess
//
//  Created by Ehab Alsharkawy on 7/4/17.
//  Copyright © 2017 VFG. All rights reserved.
//

import ObjectMapper
import VFGCommonUtils
import Gloss

fileprivate struct MappingKey {

    static let messageTitle : String = "messageTitle"
    static let messageBody : String = "messageBody"
    static let ctaButtonText : String = "ctaButtonText"
    static let url : String = "url"
    static let dismissButtonText : String = "dismissButtonText"
    static let campaignId : String = "campaignId"
    static let eventLabel : String = "eventLabel"
    static let campaignName : String = "campaignName"
    static let timestamp : String = "timestamp"
    static let deliveryMethod : String = "deliveryMethod"
    static let secondCtaButtonText : String = "secondCtaButtonText"
    static let secondUrl : String = "secondUrl"
    static let message_extras = "extras"
    static let locale = "locale"
    static let autoExpireAsInt = "autoExpireAsInt"
    static let autoExpire = "autoExpire"
    static let dateReceived = "dateReceived"
    static let messageId = "messageId"
}

@objc public enum VovMessageType : Int {
    case eventDriven = 0
    case campagin = 1
}

/**
 *  Model of VovMessages for Voice of Vodafone Component
 *
 - messageBody : For campaign body
 - ctaButtonText : For call to action button title
 - url : For action url
 - dismissButtonText : For dimiss button title
 - campaignId : For campaign Id
 */

@objc public enum messagePirioty : Int {
    case welocomeMessage = 1
    case cvm = 2
    case eventDriven = 3
}

public class VovMessage: BaseModel {

    public var messageTitle : String?
    public var messageBody : String?
    public var deliveryMethod : Int?
    public var timestamp : Double?
    public var ctaButtonText : String?
    public var url : String?
    public var secondCtaButtonText : String?
    public var secondUrl : String?
    public var dismissButtonText : String?
    public var campaignId : String?
    public var eventLabel : String?
    public var campaignName : String?
    public var messageId : Int = 0
    public var message_extras: AnyObject?
    public var locale: String?
    public var autoExpire : String?
    public var autoExpireAsInt : Int?
    public var dateReceived: Date?
    

    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(messageTitle, forKey: MappingKey.messageTitle)
        aCoder.encode(messageBody, forKey: MappingKey.messageBody)
        aCoder.encode(deliveryMethod, forKey: MappingKey.deliveryMethod)
        aCoder.encode(timestamp, forKey: MappingKey.timestamp)
        aCoder.encode(ctaButtonText, forKey: MappingKey.ctaButtonText)
        aCoder.encode(url, forKey: MappingKey.url)
        aCoder.encode(secondCtaButtonText, forKey: MappingKey.secondCtaButtonText)
        aCoder.encode(secondUrl, forKey: MappingKey.secondUrl)
        aCoder.encode(dismissButtonText, forKey: MappingKey.dismissButtonText)
        aCoder.encode(campaignId, forKey: MappingKey.campaignId)
        aCoder.encode(eventLabel, forKey: MappingKey.eventLabel)
        aCoder.encode(campaignName, forKey: MappingKey.campaignName)
        aCoder.encode(messageId, forKey: MappingKey.messageId)
        aCoder.encode(message_extras, forKey: MappingKey.message_extras)
        aCoder.encode(autoExpire, forKey: MappingKey.autoExpire)
        aCoder.encode(autoExpireAsInt, forKey: MappingKey.autoExpireAsInt)
        aCoder.encode(dateReceived, forKey: MappingKey.dateReceived)
        aCoder.encode(locale, forKey: MappingKey.locale)
        
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init()
        if aDecoder.containsValue(forKey: MappingKey.messageTitle) {
            messageTitle = aDecoder.decodeObject(forKey: MappingKey.messageTitle) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.messageBody) {
            messageBody = aDecoder.decodeObject(forKey: MappingKey.messageBody) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.ctaButtonText) {
            ctaButtonText = aDecoder.decodeObject(forKey: MappingKey.ctaButtonText) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.url) {
            url = aDecoder.decodeObject(forKey: MappingKey.url) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.secondCtaButtonText) {
            secondCtaButtonText = aDecoder.decodeObject(forKey: MappingKey.secondCtaButtonText) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.secondUrl) {
            secondUrl = aDecoder.decodeObject(forKey: MappingKey.secondUrl) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.dismissButtonText) {
            dismissButtonText = aDecoder.decodeObject(forKey: MappingKey.dismissButtonText) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.campaignId) {
            campaignId = aDecoder.decodeObject(forKey: MappingKey.campaignId) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.eventLabel) {
            eventLabel = aDecoder.decodeObject(forKey: MappingKey.eventLabel) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.campaignName) {
            campaignName = aDecoder.decodeObject(forKey: MappingKey.campaignName) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.deliveryMethod) {
            deliveryMethod = aDecoder.decodeObject(forKey: MappingKey.deliveryMethod) as? Int
        }
        if aDecoder.containsValue(forKey: MappingKey.timestamp) {
            timestamp = aDecoder.decodeObject(forKey: MappingKey.timestamp) as? Double
        }
        if aDecoder.containsValue(forKey: MappingKey.message_extras) {
            message_extras = aDecoder.decodeObject(forKey: MappingKey.message_extras) as AnyObject
        }
        if aDecoder.containsValue(forKey: MappingKey.autoExpire) {
            autoExpire = aDecoder.decodeObject(forKey: MappingKey.autoExpire) as? String
        }
        if aDecoder.containsValue(forKey: MappingKey.autoExpireAsInt) {
            autoExpireAsInt = aDecoder.decodeObject(forKey: MappingKey.autoExpireAsInt) as? Int
        }
        if aDecoder.containsValue(forKey: MappingKey.dateReceived) {
            dateReceived = aDecoder.decodeObject(forKey: MappingKey.dateReceived) as? Date
        }
        if aDecoder.containsValue(forKey: MappingKey.locale) {
            locale = aDecoder.decodeObject(forKey: MappingKey.locale) as? String
        }

    }

    private func getDecodedObject(_ key: String,coder aDecoder: NSCoder) -> Any? {
        if aDecoder.containsValue(forKey: key) {
            let decodedObject = aDecoder.decodeObject(forKey: key)!
            if type(of: decodedObject) == String.self {
                return aDecoder.decodeObject(forKey: key) as? String
            } else if type(of: decodedObject) == Int.self {
                return aDecoder.decodeObject(forKey: key) as? Int
            } else if type(of: decodedObject) == Double.self {
                return aDecoder.decodeDouble(forKey: key)
            } else if type(of: decodedObject) == Bool.self {
                return aDecoder.decodeBool(forKey: key)
            } else if type(of: decodedObject) == Date.self {
                return aDecoder.decodeObject(forKey: key) as? Date
            } else {
                return aDecoder.decodeObject(forKey: key)
            }
        }
        return nil
    }

    public required init?(map: Map) {
        super.init(map: map)
    }

    public required init?(json: JSON) {
        super.init()
    }
    
    public var type : VovMessageType {
        get{
            if self.ctaButtonText == nil || self.ctaButtonText?.count == 0 ||
                self.dismissButtonText == nil || self.dismissButtonText?.count == 0 {
                return .eventDriven
            }
            return .campagin
        }
    }

    public var piriorty : messagePirioty {
        get{
            switch self.type {
            case .campagin:
                return .cvm
            case .eventDriven:
                return .eventDriven
            }
        }
    }

    public var recievedDateTimeInterval : TimeInterval = 0
    public var recievedDate : Date = Date()

    public override func mapping(map: Map) {

        messageTitle <- map[MappingKey.messageTitle]
        messageBody <- map[MappingKey.messageBody]
        ctaButtonText <- map[MappingKey.ctaButtonText]
        secondCtaButtonText <- map[MappingKey.secondCtaButtonText]
        timestamp <- map[MappingKey.timestamp]
        deliveryMethod <- map[MappingKey.deliveryMethod]
        url <- map[MappingKey.url]
        secondUrl <- map[MappingKey.secondUrl]
        dismissButtonText <- map[MappingKey.dismissButtonText]
        campaignId <- map[MappingKey.campaignId]
        eventLabel <- map[MappingKey.eventLabel]
        campaignName <- map[MappingKey.campaignName]
        recievedDateTimeInterval = NSDate().timeIntervalSince1970 * 1000
        recievedDate = Date(timeIntervalSince1970: Double(recievedDateTimeInterval/1000))
        messageId = VFGCampaignManager.sharedInstance.messageCounter
        message_extras <- map[MappingKey.message_extras]
        locale <- map[MappingKey.locale]
        autoExpire <- map[MappingKey.autoExpire]
        autoExpireAsInt <- map[MappingKey.autoExpireAsInt]
    }
}
