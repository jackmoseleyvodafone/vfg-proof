//
//  CheckBoxView.swift
//  CustomViewFromXib
//
//  Created by Ahmed Askar on 8/10/17.
//  Copyright (c) 2017 Ahmed Askar. All rights reserved.
//

import UIKit
import VFGCommonUtils

public class VFGCheckBoxView: UIView {
    
    // Our custom view from the XIB file
    private var mainView: UIView?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkBoxBtn: UIButton!
    
    public var onCheckComplete: ((_ isChecked : Bool) -> Void)?

    /** Property to assign checkbox enable or disabled */
    @IBInspectable public var isEnabled : Bool = true {
        didSet {
            VFGLogger.log("Setting VFGCheckBox view disabled property to " + String(isEnabled))
            if isEnabled == true {
                checkBoxBtn.isEnabled = true
                titleLabel.textColor = UIColor.white
            }else{
                checkBoxBtn.isEnabled = false
                titleLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction private func checkButtonDidTouch(sender: AnyObject) {
        // Do something
        let button: UIButton? = sender as? UIButton
        if let button = button {
            button.isSelected = !button.isSelected
            
            // Callback
            if let callback = self.onCheckComplete {
                callback(button.isSelected)
            }
            else {
                VFGLogger.log("VFGCheckBoxView button callback is missing")
            }
        }
    }
    
    /** Property to assign view title */
    @IBInspectable public var viewTitle: String? {
        didSet {
            titleLabel.text = viewTitle
        }
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    private func xibSetup() {
        mainView = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        mainView?.frame = bounds
        
        // Make the view stretch with containing view
        mainView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        if let mainView : UIView = mainView {
            addSubview(mainView)
        }
        
        titleLabel.applyStyle(VFGTextStyle.checkBoxTitleColored(UIColor.VFGWhite))
    }
    
    private func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "VFGCheckBoxView", bundle: VFGCommonUIBundle.bundle())
        // Assumes UIView is top level and only object in CustomView.xib file
        guard let view : UIView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            VFGLogger.log("Cannot cast NIB content to UIView. Returning empty UIView")
            return UIView()
        }
        
        return view
    }
}
