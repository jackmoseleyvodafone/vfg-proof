//
//  VFGExpandedContentCell.swift
//  TestProj
//
//  Created by Ahmed Askar on 8/9/17.
//  Copyright © 2017 Askar. All rights reserved.
//

import UIKit

public class VFGExpandedContentCell: UITableViewCell {
    
    public var cardContents: [VFGPrivacyOptionsContentCard]?
    
    public var onExpandComplete: (() -> Void)?
    
    @IBOutlet weak private var stripViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var stripView: UIView!
    
    @IBOutlet weak private var viewContent :UIView!
    
    @IBOutlet weak private var customCellTitle: UILabel!
    
    @IBOutlet weak private var contentLabel: UILabel!
    
    @IBOutlet weak private var arrowImage: UIImageView!
    
    /** Property to set cell title */
    public var cellTitle: String? {
        didSet {
            customCellTitle.applyStyle(VFGTextStyle.cellTitleColored(UIColor.VFGOverlayOnTapTertiaryGray))
            customCellTitle.text = cellTitle
        }
    }
    
    /** Property to set strip view color */
    public var stripViewColor : UIColor? {
        didSet {
            stripView.backgroundColor = stripViewColor
        }
    }
    
    /** Property to assign strip view visibility */
    public var stripViewHidden : Bool = false {
        didSet {
            if stripViewHidden == true {
                stripViewWidthConstraint.constant = 0
            }else{
                stripViewWidthConstraint.constant = 5
            }
            self.layoutIfNeeded()

        }
    }
    
    public override func awakeFromNib() {
        self.selectionStyle = .none
        contentLabel.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGOverlayOnTapTertiaryGray))
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentAttributedString.setAttributedString(NSAttributedString(string: ""))
    }
    
    public var isExpanded: Bool = false
    {
        didSet
        {
            var angle: CGFloat = 0.0
            if !isExpanded {
                angle = CGFloat(-Double.pi * 2)
                isExpanded = false
                contentLabel.text = ""
                
            } else {
                angle = CGFloat(Double.pi)
                isExpanded = true
                let resultAttributedString = getText(cardContents: cardContents!)
                contentLabel.attributedText = resultAttributedString
            }
            
            UIView.animate(withDuration: 0.3) {[weak self] in
                let tr = CGAffineTransform.identity.rotated(by: angle)
                self?.arrowImage.transform = tr
            }
            
        }
    }
    
    var contentAttributedString = NSMutableAttributedString()
    
    private func getText(cardContents: [VFGPrivacyOptionsContentCard]) -> NSMutableAttributedString {
        
        contentAttributedString.setAttributedString(NSAttributedString(string: ""))
        
        for item in cardContents {
            if contentAttributedString.length != 0 {
                contentAttributedString.append(NSAttributedString(string: ""))
                self.appendStringWithContentType(item: item)
            }else{
                self.appendStringWithContentType(item: item)
            }
        }
        return contentAttributedString
    }
    
    private func appendStringWithContentType(item: VFGPrivacyOptionsContentCard) {
        
        switch item.contentType {
            
        case .normal:
            contentAttributedString.append(NSAttributedString(string: (item as! NormalParagraph).paragraph))
            contentAttributedString.append(NSAttributedString(string: "\n"))
            
        case .bullets:
            contentAttributedString.append(NSAttributedString(string: (item as! ParagraphWithBullets).paragraph))
            contentAttributedString.append(NSAttributedString(string: "\n\n"))
            for itemBullet in (item as! ParagraphWithBullets).bullets {
                contentAttributedString.append(NSAttributedString(string: "• "))
                contentAttributedString.append(NSAttributedString(string: itemBullet))
                contentAttributedString.append(NSAttributedString(string: "\n\n"))
            }
        }
    }
}
