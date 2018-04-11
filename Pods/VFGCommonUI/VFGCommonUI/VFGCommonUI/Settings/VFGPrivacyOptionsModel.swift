//
//  PrivacyOptionsModel.swift
//  PrivacyOptions
//
//  Created by Ahmed Askar on 8/21/17.
//  Copyright © 2017 Askar. All rights reserved.
//

import Foundation
import UIKit


public class PrivacyOptionsItem {
    
    public var label: String
    public var description: String
    public var seeMoreText: String
    public var link: String
    public var questionTitle: String
    public var contents :[VFGPrivacyOptionsContentCard]
    
    
    public init(label: String,description: String,questionTitle: String, contents: [VFGPrivacyOptionsContentCard]) {
        self.label = label
        self.description = description
        self.questionTitle = questionTitle
        self.contents = contents
        self.seeMoreText = ""
        self.link = ""
    }
    //privacyItemWithAction
    public init(label: String,description: String,questionTitle: String, contents: [VFGPrivacyOptionsContentCard],seeMoreText: String, link: String ) {
        self.label = label
        self.description = description
        self.seeMoreText = seeMoreText
        self.link = link
        self.questionTitle = questionTitle
        self.contents = contents
    }
}


public class VFGPrivacyOptionsModel {
    
//    public var isPrivacyPage : Bool
    public var pageTitle: String
    public var msisdn: String?
    public var anonymizeOption: PrivacyOptionsItem
    public var personalizedOption: PrivacyOptionsItem
    public var personalizePermission : PermissionPopModel
    public var anonymizePermission : PermissionPopModel
    public var personalizeConfirmation : ConfirmationPopModel
    public var anonymizeConfirmation : ConfirmationPopModel
    
    required public init(
                         pageTitle: String,
                         msisdn: String?,
                         anonymizeOption: PrivacyOptionsItem,
                         personalizedOption: PrivacyOptionsItem,
                         personalizePermission: PermissionPopModel,
                         anonymizePermission: PermissionPopModel,
                         personalizeConfirmation: ConfirmationPopModel,
                         anonymizeConfirmation: ConfirmationPopModel) {
        
        self.pageTitle = pageTitle
        self.msisdn = msisdn
        self.anonymizeOption = anonymizeOption
        self.personalizedOption = personalizedOption
        self.personalizePermission = personalizePermission
        self.anonymizePermission = anonymizePermission
        self.personalizeConfirmation = personalizeConfirmation
        self.anonymizeConfirmation = anonymizeConfirmation
    }
}


public class VFGPrivacyPolicyCard {
    
    public var cardTitle: String
    public var cardContents: [VFGPrivacyOptionsContentCard]
    
    public init(cardTitle: String, cardContents: [VFGPrivacyOptionsContentCard]) {
        self.cardTitle = cardTitle
        self.cardContents = cardContents
    }
}

public class VFGPrivacyOptionsContentCard {
    
    public var contentType: ParagraphContentType
    
    public init(contentType: ParagraphContentType) {
        self.contentType = contentType
    }
}

public class VFGPrivacyPolicySection {
    
    public var sectionTitle: String
    public var cards: [VFGPrivacyPolicyCard]
    
    public init(sectionTitle: String, cards: [VFGPrivacyPolicyCard]) {
        self.sectionTitle = sectionTitle
        self.cards = cards
    }
}

public enum ParagraphContentType {
    case normal
    case bullets
}

public class NormalParagraph : VFGPrivacyOptionsContentCard {
    public var paragraph: String
    
    required public init(paragraph: String) {
        self.paragraph = paragraph
        super.init(contentType: .normal)
    }
}


public class ParagraphWithBullets : VFGPrivacyOptionsContentCard {
    
    public var paragraph: String
    public var bullets: [String]
    
    required public init(paragraph: String, bullets: [String]) {
        self.paragraph = paragraph
        self.bullets = bullets
        super.init(contentType: .bullets)
    }
}

public class NormalParagraphWithAction : VFGPrivacyOptionsContentCard {
    public var paragraph: String
    public var actionTitle: String
    public var action : ()->()
    required public init(paragraph: String, actionTitle: String , action : @escaping ()->()) {
        self.paragraph = paragraph
        self.actionTitle = actionTitle
        self.action = action
        super.init(contentType: .normal)
    }
}

public class ConfirmationPopModel {
    
    public var overlayTitle: String
    public var header: String
    public var paragraph: String
    public var titleNo: String
    public var titleOk: String
    
    required public init(overlayTitle: String, header: String,paragraph: String ,titleNo: String, titleOk: String) {
        self.overlayTitle = overlayTitle
        self.header = header
        self.paragraph = paragraph
        self.titleNo = titleNo
        self.titleOk = titleOk
    }
}

public class PermissionPopModel {
    
    public var permissionTitle: String
    public var header: String
    public var titleNo: String
    public var titleOk: String
    public var titleSettings: String
    public var permissions: [PermissionItem]
    
    required public init(permissionTitle: String,
                         header: String,
                         titleNo: String,
                         titleOk: String,
                         titleSettings: String,
                         permissions: [PermissionItem]){
        
        self.permissionTitle = permissionTitle
        self.header = header
        self.titleNo = titleNo
        self.titleOk = titleOk
        self.titleSettings = titleSettings
        self.permissions = permissions
    }
}

public class PermissionItem {
    public var icon: PermissionItemIcon
    public var title: String
    public var description: String
    required public init(icon: PermissionItemIcon, title: String, description: String){
        self.icon = icon
        self.title = title
        self.description = description
    }
}

public enum PermissionItemIcon {
    case phone
    case sms
    case location
    case other(UIImage)
}
