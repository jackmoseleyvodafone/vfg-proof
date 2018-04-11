//
//  SideMenuTableViewCell.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 09/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

class VFGSideMenuTableViewCell: UITableViewCell {
    
    static let expandImage : String = "chevron-down"
    static let fontSize : CGFloat = 17
    static let iPadSize : CGFloat = 21
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var badge: VFGBadgeView!
    @IBOutlet weak var expandButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selecedCellWhiteView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.leftImage.tintColor = UIColor.white
        self.rightImage.tintColor = UIColor.white
        
        if isIPad() {
            self.titleLabel.font = UIFont.vodafoneRegularFont(VFGSideMenuTableViewCell.iPadSize)
        }
        else {
            self.titleLabel.font = UIFont.vodafoneRegularFont(VFGSideMenuTableViewCell.fontSize)
        }
        self.separator.backgroundColor = UIColor.VFGMenuSeparator
        let expand : UIImage? = UIImage(fromCommonUINamed: VFGSideMenuTableViewCell.expandImage)?.withRenderingMode(.alwaysTemplate)
        let collapse : UIImage? = expand?.mirroredDown
        self.expandButton.imageView?.tintColor = UIColor.white
        self.expandButton.setImage(expand, for: .normal)
        self.expandButton.setImage(collapse, for: .selected)
        self.expandButton.setImage(collapse, for: [.selected, .highlighted])
        self.expandButton.isUserInteractionEnabled = false
        self.expandButton.sizeToFit()
        self.badge.backgroundColor = UIColor.VFGPrimaryRed
        self.backgroundColor = UIColor.clear
        
    }
    override func prepareForReuse() {
        self.backgroundColor = .clear
        self.selecedCellWhiteView.isHidden = true
    }
    func setExpanded(expanded: Bool) {
        self.expandButton?.isSelected = expanded
    }
    
}
