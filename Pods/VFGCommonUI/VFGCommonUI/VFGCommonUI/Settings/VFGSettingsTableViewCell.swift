//
//  VFGSettingsTableViewCell.swift
//  VFGCommonUI
//
//  Created by Ehab on 11/28/17.
//

import UIKit

class VFGSettingsTableViewCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var whiteBackgroundView: UIView!

    func setup(title: String, body: String, isSwitchHidden: Bool){
        self.titleLabel.text = title
        self.bodyLabel.text = body
        self.cellSwitch.isHidden = !isSwitchHidden
        self.arrowImageView.isHidden = isSwitchHidden
        self.setupShadow(view: self.whiteBackgroundView)
    }
    
    private func setupShadow(view:UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: -1, height: 3)
        view.layer.shadowRadius = 1
    }
}

