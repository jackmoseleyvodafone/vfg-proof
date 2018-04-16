//
//  UIViewExtensions.swift
//  VFGProof
//
//  Created by vodafone on 13/04/2018.
//  Copyright © 2018 vodafone. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: Align different edges
    func alignAttribute(_ selfAttribute: NSLayoutAttribute, WithView relatedView: UIView, Attribute relatedViewAttribute: NSLayoutAttribute, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: selfAttribute, relatedBy: .equal, toItem: relatedView, attribute: relatedViewAttribute, multiplier: 1, constant: constant))
    }
    
    // MARK: Single edge layout
    
    func alignTopEdgeWithView(_ relatedView: UIView, constant: CGFloat) {
        
        alignAttribute(.top, WithView: relatedView, Attribute: .top, constant: constant)
    }
    
    func alignLeadingEdgeWithView(_ relatedView: UIView, constant: CGFloat) {
        
        alignAttribute(.leading, WithView: relatedView, Attribute: .leading, constant: constant)
    }
    
    func alignBottomEdgeWithView(_ relatedView: UIView, constant: CGFloat) {
        
        alignAttribute(.bottom, WithView: relatedView, Attribute: .bottom, constant: constant)
    }
    
    func alignTrailingEdgeWithView(_ relatedView: UIView, constant: CGFloat) {
        
        alignAttribute(.trailing, WithView: relatedView, Attribute: .trailing, constant: constant)
    }
    
    // MARK: Multple edge layout
    
    func alignTopAndLeadingEdgesWithView(_ relatedView: UIView, topConstant: CGFloat, leadingConstant: CGFloat) {
        self.alignTopEdgeWithView(relatedView, constant: topConstant)
        self.alignLeadingEdgeWithView(relatedView, constant: leadingConstant)
    }
    
    func alignBottomAndTrailingEdgesWithView(_ relatedView: UIView, bottomConstant: CGFloat, trailingConstant: CGFloat) {
        self.alignBottomEdgeWithView(relatedView, constant: bottomConstant)
        self.alignTrailingEdgeWithView(relatedView, constant: trailingConstant)
    }
    
    func alignLeadingAndTrailingEdgesWithView(_ relatedView: UIView, leadingConstant: CGFloat, trailingConstant: CGFloat) {
        self.alignLeadingEdgeWithView(relatedView, constant: leadingConstant)
        self.alignTrailingEdgeWithView(relatedView, constant: trailingConstant)
    }
    
    func alignWithView(_ relatedView: UIView) {
        self.alignTopAndLeadingEdgesWithView(relatedView, topConstant: 0, leadingConstant: 0)
        self.alignBottomAndTrailingEdgesWithView(relatedView, bottomConstant: 0, trailingConstant: 0)
    }
    
    // MARK: Width and height layout
    
    func constrainWidth(_ constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant))
    }
    
    func constrainHeight(_ constant: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constant)

        constraint.isActive = true

        return constraint
    }
    
    func constrainWidthWithView(_ relatedView: UIView, constant: CGFloat) {
        alignAttribute(.width, WithView: relatedView, Attribute: .width, constant: constant)
    }
    
    func constrainHeightWithView(_ relatedView: UIView, constant: CGFloat) {
        alignAttribute(.height, WithView: relatedView, Attribute: .height, constant: constant)
    }
    
    // MARK: Center layout
    func alignCenterYWithView(_ relatedView: UIView, constant: CGFloat) {
        alignAttribute(.centerY, WithView: relatedView, Attribute: .centerY, constant: constant)
    }
    
    func alignCenterXWithView(_ relatedView: UIView, constant: CGFloat) {
        alignAttribute(.centerX, WithView: relatedView, Attribute: .centerX, constant: constant)
    }
}
