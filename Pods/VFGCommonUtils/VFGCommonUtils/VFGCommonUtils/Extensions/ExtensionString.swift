//
//  ExtensionString.swift
//  VFGCommonUtils
//
//  Created by Ehab Alsharkawy on 7/24/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

public extension String {
    public func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with:self)
    }
    public func isValidPhone() -> Bool {
        
        let regEx = "\\b[\\d]{3}\\-[\\d]{3}\\-[\\d]{4}\\b"
        let test = NSPredicate(format:"SELF MATCHES %@", regEx)
        return test.evaluate(with:self)
    }
}

