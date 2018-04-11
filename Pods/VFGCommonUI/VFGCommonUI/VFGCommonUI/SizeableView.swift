//
//  SizeableView.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/24/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit

public protocol SizeableView: class {
    /**
     Implement to calculate and return the desired height of the View.
     
     - returns: The calculated height of the view.
     */
    func getViewHeight() -> CGFloat
}
