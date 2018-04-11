//
//  VFGBackgroundView.swift
//  VFGCommonUI
//
//  Created by kasa on 02/05/2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation


public class VFGBackgroundImageFactory
{
    static private let componentBackgroundImage = "CommonHeaderContainerBackground"

    static public func componentBackground() -> UIImage? {
        return UIImage(named: VFGBackgroundImageFactory.componentBackgroundImage, in: VFGCommonUIBundle.bundle(), compatibleWith: nil)
    }
}
