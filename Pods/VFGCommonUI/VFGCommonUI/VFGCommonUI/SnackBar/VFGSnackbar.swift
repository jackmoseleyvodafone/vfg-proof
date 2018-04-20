//
//  VFGSnackbar.swift
//  VFGCommonUI
//
//  Created by Ehab on 11/28/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation
import SwiftMessages

open class VFGSnackbar : NSObject {
    /**
       View which will be passed to SwiftMessages.show(). This property can be used to customize message displayed by SwiftMessages pod.
    */
    public var messageView = MessageView.viewFromNib(layout: .messageView)
    
    open func show(message: String, duration: TimeInterval , image: UIImage?) {
        
        let icon = UIImage(fromCommonUINamed: "tick")
        
        messageView.configureTheme(backgroundColor: .black, foregroundColor: .white, iconImage: icon, iconText: nil)
        
        messageView.configureContent(title: "", body: message)
        
        messageView.button?.removeFromSuperview()
        
        messageView.bodyLabel?.font = UIFont.VFGXL() ?? UIFont.systemFont(ofSize: 20)
        
        var config = SwiftMessages.Config()
        
        // Slide up from the bottom.
        config.presentationStyle = .bottom
        
        // Display in a window at the specified window level: UIWindowLevelStatusBar
        // displays over the status bar while UIWindowLevelNormal displays under.
        config.presentationContext = .window(windowLevel: UIWindowLevelAlert)
        
        // Disable the default auto-hiding behavior.
        config.duration = .seconds(seconds: duration)
        
        // Specify one or more event listeners to respond to show and hide events.
        config.eventListeners.append() { event in
            if case .didHide = event { print("yep") }
        }
        
        SwiftMessages.show(config: config, view: messageView)
    }
}
