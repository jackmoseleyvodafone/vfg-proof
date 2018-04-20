//
//  VFGCellOptionsButton.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 14/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Button for custom cell option. Used with VFGCellOptionsView
 */
public class VFGCellOptionsButton: UIButton {

    private static let labelTopToButtonHeightProportion : CGFloat = 66.0/123.0
    private static let buttonWidthProportion : CGFloat = 72.0/360.0
    private static let fontSize : CGFloat = 11.5
    private static let minimumFontScaleFactor : CGFloat = 0.5
    private static let minimumFrame : CGRect = CGRect(x: 0, y: 0, width: 0, height: 16)

    var label : UILabel!
    var myImageView : UIImageView!
    var labelTopConstraint : NSLayoutConstraint!

    /**
     Creates button based on option parameters

     - Parameter option: option based on which button is created
     */
    public init(option: VFGCellOption) {
        super.init(frame: VFGCellOptionsButton.minimumFrame)
        self.setupCell(option)
    }

    /**
     Do not call this, because we don't have option parameter

     - Parameter coder: Decoder
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupCell(_ option : VFGCellOption) {
        self.translatesAutoresizingMaskIntoConstraints = false
        #if swift(>=4.1)
        self.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        #else
        self.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        #endif
        self.backgroundColor = option.backgroundColor
        self.setupLabel(option.text, textColor: option.textColor)
        self.setupImage(option.image)
    }

    private func setupLabel(_ text: String, textColor: UIColor?) {
        self.label = UILabel(frame: CGRect.zero)
        self.label.font = UIFont.systemFont(ofSize: VFGCellOptionsButton.fontSize)
        self.label.numberOfLines = 0;
        self.label.text = text
        self.label.translatesAutoresizingMaskIntoConstraints = false;
        self.label.minimumScaleFactor = VFGCellOptionsButton.minimumFontScaleFactor
        self.label.adjustsFontSizeToFitWidth = true
        self.label.textAlignment = .center
        self.label.textColor = textColor ?? UIColor.black
        self.addSubview(label)

        self.labelTopConstraint = NSLayoutConstraint (item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: self.computedLabelTop())

        let bottom = NSLayoutConstraint (item: label, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint (item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint (item: label, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .leading, multiplier: 1, constant: 5)
        let right = NSLayoutConstraint (item: label, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1, constant: 5)

        self.addConstraints([self.labelTopConstraint, bottom, centerX, left, right])
    }

    private func setupImage(_ image : UIImage?) {
        self.myImageView = UIImageView(image: image)
        self.myImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.myImageView.contentMode = .scaleAspectFit
        self.addSubview(self.myImageView)

        let centerX = NSLayoutConstraint (item: self.myImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint (item: self.myImageView, attribute: .bottom, relatedBy: .equal, toItem: self.label, attribute: .top, multiplier: 1, constant: -2)
        let top = NSLayoutConstraint (item: self.myImageView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1, constant: 5)

        guard let myImageView : UIImageView = self.myImageView else {
            VFGLogger.log("Cannot unwrap self.myImageView")
            return
        }
        
        let views = ["view" : myImageView]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(<=10)-[view]-(>=10)-|", options: [], metrics: nil, views: views)

        self.addConstraints([centerX, bottom, top])
        self.addConstraints(vertical)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if (self.computedLabelTop() != self.labelTopConstraint.constant) {
            self.labelTopConstraint.constant = self.computedLabelTop()
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: VFGCellOptionsButton.buttonWidthProportion * UIScreen.main.bounds.width, height:  UIViewNoIntrinsicMetric)
    }

    private func computedLabelTop() -> CGFloat {
        return VFGCellOptionsButton.labelTopToButtonHeightProportion * self.bounds.height;
    }
    
}
