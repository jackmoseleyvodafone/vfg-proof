//
//  VFGEasingFunctions.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 4/30/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit

public extension CAMediaTimingFunction {
    
    public static var easeInSine : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
        }
    }
    
    public static var easeOutSine : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
        }
    }

    public static var easeInOutSine : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
        }
    }

    
    
    public static var easeInQuad : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
        }
    }
    
    public static var easeOutQuad : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
        }
    }
    
    public static var easeInOutQuad : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
        }
    }
    
    
    
    public static var easeInCubic : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
        }
    }
    
    public static var easeOutCubic : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
        }
    }
    
    public static var easeInOutCubic : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
        }
    }
    
    
    
    public static var easeInQuart : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
        }
    }
    
    public static var easeOutQuart : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
        }
    }
    
    public static var easeInOutQuart : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
        }
    }
    
    
    
    public static var easeInQuint : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
        }
    }
    
    public static var easeOutQuint : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
        }
    }
    
    public static var easeInOutQuint : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
        }
    }

    
    
    public static var easeInExpo : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
        }
    }
    
    public static var easeOutExpo : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
        }
    }
    
    public static var easeInOutExpo : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
        }
    }
    
    
    
    public static var easeInCirc : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
        }
    }
    
    public static var easeOutCirc : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
        }
    }
    
    public static var easeInOutCirc : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
        }
    }
    
    
    
    public static var easeInBack : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
        }
    }
    
    public static var easeOutBack : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
        }
    }
    
    public static var easeInOutBack : CAMediaTimingFunction {
        get {
            return CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
        }
    }
    
    
}

