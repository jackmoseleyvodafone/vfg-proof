//
//  VFGSettingsHeaderTableViewCell.swift
//  VFGCommonUI
//
//  Created by Ehab on 11/28/17.
//

import UIKit

class VFGSettingsHeaderTableViewCell : UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(title: String){
        self.titleLabel.text = title
    }
}
