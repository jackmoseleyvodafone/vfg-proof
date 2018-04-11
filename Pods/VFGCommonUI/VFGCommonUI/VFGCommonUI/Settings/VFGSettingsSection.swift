//
//  VFGSettingsSection.swift
//  VFGCommonUI
//
//  Created by Ehab on 12/3/17.
//

import Foundation

public struct VFGSettingsSection {
    public var title : String
    
    public var subSection : [VFGSettingSubSection]
    
    public init(title : String, subSection: [VFGSettingSubSection]) {
        self.title = title
        self.subSection = subSection
    }
}

public struct VFGSettingSubSection{
    public var title : String
    public var body : String
    public var isSwitchHidden: Bool
    
    public init(title : String, body: String, isSwitchHidden: Bool) {
        self.title = title
        self.isSwitchHidden = isSwitchHidden
        self.body = body
    }
}
