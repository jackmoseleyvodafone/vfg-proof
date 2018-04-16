//
//  VFGVovBaseModel.swift
//  AdobeMobileSDK
//
//  Created by Ehab Alsharkawy on 9/28/17.
//

import Foundation



public enum MessagePriority : Int {
    case welocomeMessage = 1
    case cvm = 2
    case eventDriven = 3
}


public class VFGVovBaseModel : NSObject {
    public var piriorty : MessagePriority?
    public var recievedDate : NSDate?
    public var messageId : Int = 0

    public override init() {
        super.init()
    }

}
