//
//  PlanTextViewCell.swift
//  Pods
//
//  Created by Ahmed Askar on 8/27/17.
//
//

import UIKit

public class PlanTextViewCell: UITableViewCell {
    
    @IBOutlet weak private var customCellTitle: UILabel!
    @IBOutlet weak var customCellSeeMoreText: UILabel!
    @IBOutlet weak var cutomCellLinkButton: UIButton!
    /** Property to set cell title */
    public var cellTitle: String? {
        didSet {
            customCellTitle.text = cellTitle
            customCellTitle.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGOverlayOnTapTertiaryGray))
        }
    }
    
    //seeMoreText property
    public var cellSeeMoreText: String? {
        didSet {
            customCellSeeMoreText.text = cellSeeMoreText
            customCellSeeMoreText.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGOverlayOnTapTertiaryGray))
            customCellSeeMoreText.adjustsFontSizeToFitWidth = true
//            customCellSeeMoreText.sizeToFit()
             customCellSeeMoreText.isHidden = false
        }
    }
    //seeMoreText property
    public var cellLinkTitle: String? {
        didSet {
            cutomCellLinkButton.setTitle(cellLinkTitle, for: .normal)
            
           //underline
            #if swift(>=4.1)
            let underlineAttribute = [kCTUnderlineStyleAttributeName as NSAttributedStringKey: NSUnderlineStyle.styleSingle.rawValue]
            #else
            let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
            #endif
            let underlineAttributedString = NSAttributedString(string:  (cutomCellLinkButton.titleLabel?.text ?? "")!, attributes: underlineAttribute)
            cutomCellLinkButton.titleLabel?.attributedText = underlineAttributedString

            

            cutomCellLinkButton.titleLabel?.adjustsFontSizeToFitWidth = true
            cutomCellLinkButton.titleLabel?.sizeToFit()
            
            cutomCellLinkButton.sizeToFit()

        }
    }

    
    public func getButton() -> UIButton {
        return cutomCellLinkButton
    }
    
}
