//
//  UIScreenExtension.swift
//  VFGommonUtil
//
//  Created by Ehab Alsharkawy on 8/16/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

public extension UIScreen {
    
    // MARK: - Device Size Checks
    enum Heights: CGFloat {
        case Inches_3_5 = 480
        case Inches_4 = 568
        case Inches_4_7 = 667
        case Inches_5_5 = 736
        case Inches_5_8 = 812
    }
    
    enum Inches: String {
        case Inches_3_5 = "3.5 Inches"
        case Inches_4 = "4 Inches"
        case Inches_4_7 = "4.7 Inches"
        case Inches_5_5 = "5.5 Inches"
        case Inches_5_8 = "5.8 Inches"
        case other = "other"
    }
    
    static var CURRENT_SIZE: Inches {
        if IS_3_5_INCHES() {
            return .Inches_3_5
        } else if IS_4_INCHES() {
            return .Inches_4
        } else if IS_4_7_INCHES() {
            return .Inches_4_7
        } else if IS_5_5_INCHES() {
            return .Inches_5_5
        } else if IS_5_8_INCHES() {
            return .Inches_5_8
        }
        return .other
    }
    
    // MARK: - Singletons
    static var TheCurrentDevice: UIDevice {
        return  UIDevice.current
    }
    
    static var TheCurrentDeviceVersion: Float {
        return Float(UIDevice.current
            .systemVersion)!
    }
    
    static var TheCurrentDeviceHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    // MARK: - Device Idiom Checks
    static var PHONE_OR_PAD: String {
        if isPhone {
            return "iPhone"
        } else if isIpad {
            return "iPad"
        }
        return "Not iPhone nor iPad"
    }
    
    static var DEBUG_OR_RELEASE: String {
        #if DEBUG
            return "Debug"
        #else
            return "Release"
        #endif
    }
    
    static var SIMULATOR_OR_DEVICE: String {
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return "Simulator"
        #else
            return "Device"
        #endif
    }
    
    public static var isPhone: Bool {
        get{
            return TheCurrentDevice.userInterfaceIdiom == .phone
        }
    }

    
    public static var isIpad: Bool {
        get{
            return TheCurrentDevice.userInterfaceIdiom == .pad
        }
    }

    static func isDebug() -> Bool {
        return DEBUG_OR_RELEASE == "Debug"
    }
    
    static func isRelease() -> Bool {
        return DEBUG_OR_RELEASE == "Release"
    }
    
    static func isSimulator() -> Bool {
        return SIMULATOR_OR_DEVICE == "Simulator"
    }
    
    static func isDevice() -> Bool {
        return SIMULATOR_OR_DEVICE == "Device"
    }
    
    static var CURRENT_VERSION: String {
        return "\(TheCurrentDeviceVersion)"
    }
    
    static func isSize(height: Heights) -> Bool {
        return TheCurrentDeviceHeight == height.rawValue
    }
    
    // MARK: Retina Check
    static func IS_RETINA() -> Bool {
        return UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale))
    }
    
    // MARK: 3.5 Inch Checks
    static func IS_3_5_INCHES() -> Bool {
        return isPhone && isSize(height: .Inches_3_5)
    }
    
    // MARK: 4 Inch Checks
    static func IS_4_INCHES() -> Bool {
        return isPhone && isSize(height: .Inches_4)
    }
    
    // MARK: 4.7 Inch Checks
    static func IS_4_7_INCHES() -> Bool {
        return isPhone && isSize(height: .Inches_4_7)
    }
    
    // MARK: 5.5 Inch Checks
    static func IS_5_5_INCHES() -> Bool {
        return isPhone && isSize(height: .Inches_5_5)
    }
    
    // MARK: 5.8 Inch Checks
    static func IS_5_8_INCHES() -> Bool {
        return isPhone && isSize(height: .Inches_5_8)
    }
}
