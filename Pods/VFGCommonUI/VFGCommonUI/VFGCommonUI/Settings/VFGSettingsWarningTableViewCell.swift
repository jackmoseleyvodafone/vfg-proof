//
//  File.swift
//  VFGNetPerform
//
//  Created by Ehab on 12/4/17.
//

import UIKit

public class VFGSettingsWarningTableViewCell: UITableViewCell{
    @IBOutlet weak var messageLabel: UILabel!

    public func setup(message: String){
        self.messageLabel.text = message
    }

}
