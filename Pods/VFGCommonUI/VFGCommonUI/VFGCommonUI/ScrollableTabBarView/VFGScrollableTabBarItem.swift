//
//  VFGScrollableTabBarItem.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 3/15/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

@objc public enum VFGScrollableTabBarItemStatus: Int {
    
    case enabled
    case selected
    case disabled
}

open class VFGScrollableTabBarItem: NSObject {

    public var title: String?
    public var image: UIImage?  //this var will be always read by the scrollableTabbar view.
    public var viewController: UIViewController?
    public var status: VFGScrollableTabBarItemStatus = .enabled
    public var normalImage: UIImage?    //the image for icon in normal state.. for that case not having notification.
    public var notificationImage: UIImage?  //the image for icon in notification state.
    
    //this variable will indicate if the current item is being displayed in notification mode or not. it also contains a didSet which automatically changes the image var to the associated icon relative to the mode.
  
    private var hasNewNotification: Bool = false {
        didSet {
            if hasNewNotification {
                image = notificationImage
            }
            else {
                image = normalImage
            }
        }
        
    }

    public convenience init(withTitle title: String?, image: UIImage?, viewController: UIViewController?) {
        self.init(withTitle: title, image: image, status: .enabled)
        self.viewController = viewController
        
        
    }
    
    
    public convenience init(withTitle title: String?, image: UIImage?) {
        self.init(withTitle: title, image: image, status: .enabled)
    }
    
    //new initalizer takes NotificationImage as a new parameter, the notificationImage are supposed to be the image which will displayed if the item in notification mode.
    
    public convenience init(withTitle title: String?, image: UIImage?,NotificationImage: UIImage?) {
        self.init(withTitle: title, image: image, status: .enabled)
        self.notificationImage = NotificationImage
        
    }

    public init(withTitle title: String?, image: UIImage?, status: VFGScrollableTabBarItemStatus) {
        
        self.title = title
        self.image = image
        self.normalImage = image

        self.status = status
    }
    
    //getters and setters to hasNewNotification variable
    
    public func switchToNewNotificationMode(hasNewNotification:  Bool){
        self.hasNewNotification = hasNewNotification
    }
    public func ItemIconIsNewNotification() -> Bool{
        return hasNewNotification
    }

}
