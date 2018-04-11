//
//  VFGShadowView.swift
//  VFGReferenceApp
//
//  Created by Michał Kłoczko on 18/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

public class VFGShadowView: UIView {

    private static let shadowOpacity : Float = 0.5
    private static let shadowColor : UIColor = UIColor.black
    private static let shadowOffset : CGSize = CGSize(width: -2, height: -1)
    private static let shadowFrameInset = CGPoint(x: -2, y: -3)

    public var chipHeight : CGFloat = 0 {
        didSet {
            if oldValue != chipHeight {
                self.setNeedsLayout()
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupShadow()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupShadow()
    }

    private func setupShadow() {
        self.layer.shadowColor = VFGShadowView.shadowColor.cgColor
        self.layer.shadowOpacity = VFGShadowView.shadowOpacity
        self.layer.shadowOffset = VFGShadowView.shadowOffset
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        let shadowFrame = self.bounds.insetBy(dx: VFGShadowView.shadowFrameInset.x, dy: VFGShadowView.shadowFrameInset.y)
        self.layer.shadowPath = CGPath.chipped(chipHeight: self.chipHeight, shapeRect: shadowFrame)
    }

}
