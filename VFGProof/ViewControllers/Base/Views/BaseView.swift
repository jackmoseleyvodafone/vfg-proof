//
//  BaseView.swift
//  VFGProof
//
//  Created by vodafone on 03/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    // MARK: - Properties
    
    var _coder: NSCoder?
    
    var coder: NSCoder? { return _coder }
    
    // MARK: - Init Methods
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupSubviews()
        setupAutolayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - View Setup
    
    func setupSubviews() {
        
    }
    
    func setupAutolayout() {
        
    }
}
