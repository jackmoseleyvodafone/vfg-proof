//
//  VFGSwipeableTableViewCell.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 09/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 VFGSwipeableTableViewCell table cell which displays custom options with image and text after doing swipe on a cell. Cell has to be used with VFGBlockableTableView. Your table cell class should subclass VFGSwipeableTableViewCell. To actually use it you'll need set VFGCellOptionsView on the .optionViewproperty. VFGCellOptionsView init expects array of [VFGCellOption]. The VFGCellOption serves as a view model for each custom VFGCellOptionsButton button (you should not be needing to explicitly use VFGCellOptionsButton class if standard functionality is sufficient).
 */
open class VFGSwipeableTableViewCell: UITableViewCell {
    public func isCurrentDeviceIpad() -> Bool {
        return self.getDeviceType() == .pad
    }
    
    public func getDeviceType() -> UIUserInterfaceIdiom {
        return UIScreen.main.traitCollection.userInterfaceIdiom
        
    }
    
    /**
     View with custom options. has to be set by subclasses or when constructing the cell.
     */
    public var optionsView : VFGCellOptionsView? {
        willSet {
            self.optionsView?.removeFromSuperview()
            self.optionsPresenter = nil
        }
        didSet {
            self.setupOptions()
        }
    }
    var optionsPresenter : VFGSwipeableCellOptionsPresenter?
    
    /**
     Informs if cell displays custom options.
     */
    public var areOptionsPresented : Bool {
        get {
            return self.optionsPresenter != nil && optionsPresenter!.areOptionsShown
        }
        set {
            if (newValue) {
                self.optionsPresenter?.showOptions()
            } else {
                self.optionsPresenter?.hideOptions()
            }
        }
    }
    
    /**
     Returns VFGBlockableTableView table in which this cell is present.
     
     */
    public func vfgBlockableTableView() -> VFGBlockableTableView? {
        return self.superview?.superview as? VFGBlockableTableView
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let optionsPresenter = self.optionsPresenter {
            optionsPresenter.panOffset = self.optionsWitdh()
            optionsPresenter.layoutViews()
        }
    }
    
    /**
     Present or hide cell custom options.
     
     - Parameter present: true to present options, false to hide
     - Parameter withAnimation: animate hiding or showing of options
     
     */
    public func presentOptions(present: Bool, withAnimation isAnimating: Bool) {
        if (isAnimating == false) {
            self.areOptionsPresented = present
        } else if (present) {
            self.showOptionsAnimating()
        } else {
            self.hideOptionsAnimating()
        }
    }
    
    private func setupOptions() {
        guard let optionsView : VFGCellOptionsView = self.optionsView else {
            VFGLogger.log("VFGSwipeableTableViewCell optionsView is nil")
            return
        }
        
        self.addSubview(optionsView)
        let views = ["options" : optionsView]
        var constraintH : [NSLayoutConstraint];
        if isCurrentDeviceIpad(){
            constraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:[options(101)]|", options: [], metrics: nil, views: views)
        } else{
            constraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:[options]|", options: [], metrics: nil, views: views)
        }
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[options]|", options: [], metrics: nil, views: views)
        self.addConstraints(constraintH)
        self.addConstraints(constraintV)
        
        self.optionsPresenter = VFGSwipeableCellOptionsPresenter(content: self.contentView, options: optionsView)
    }
    
    func showOptionsAnimating() {
        if (!self.areOptionsPresented) {
            self.optionsPresenter?.showOptions(animating: true)
        }
    }
    
    func hideOptionsAnimating() {
        self.optionsPresenter?.hideOptions(animating: true)
    }
    
    private func optionsWitdh() -> CGFloat {
        if let optionsView = self.optionsView {
            return optionsView.frame.width
        }
        return 0;
    }
}
