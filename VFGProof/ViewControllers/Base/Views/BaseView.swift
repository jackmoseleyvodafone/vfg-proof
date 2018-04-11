//
//  BaseView.swift
//  VFGProof
//
//  Created by vodafone on 03/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    // MARK: Init Methods
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        setupSubviews()
        setupAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: View Setup
    
    func setupSubviews() {
        
    }
    
    func setupAutolayout() {
        
    }
}
