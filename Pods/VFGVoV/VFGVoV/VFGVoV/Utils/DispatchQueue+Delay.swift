//
//  DispatchQueue+Delay.swift
//  VFGVoV
//
//  Created by Mohamed Magdy on 11/2/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static func delayMainThreadWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}
