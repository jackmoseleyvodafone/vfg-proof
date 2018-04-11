//
//  VFGLoadingIndicatorProtocol.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/20/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

@objc public protocol VFGLoadingIndicatorViewProtocol {
    
    
    /* This function controls the status of the back button in loading screen,
     if returns false, the back button will be hidden. */
    @objc optional func hasBackButton() -> Bool
    
    /* This function controls the status of the Menu button in loading screen,
     if returns false, the menu button will be hidden. */
    @objc optional func hasMenuButton() -> Bool
    
    /* This function returns the background image of the loading screen. */
    @objc optional func getBackgroundImage() -> UIImage
    
    /* This function returns the loading message of the loading screen. */
    @objc optional func getLoadingMessage() -> String
    
    /* This function controls the color of the loading spinner and label text. */
    @objc optional func getThemeColor() -> UIColor
    
    /* This function controls if the background will be transparent or not. */
    @objc optional func showAppSectionAsBackground() -> Bool
    
    /* Adds uiview with black color & alpha 0.5. */
    @objc optional func hasDimmedBackground() -> Bool
    
    
    /* This function controls the status of the Vodafone Logo in loading screen,
     if returns false, the Vodafone Logo will be hidden. */
    @objc optional func shouldShowVodafoneLogo() -> Bool
    
    /* Callback methods implemented when the user clicks on menu and back button */
    //////Required methods
    @objc func backButtonCallback()
    @objc func MenuButtonCallback()
}

