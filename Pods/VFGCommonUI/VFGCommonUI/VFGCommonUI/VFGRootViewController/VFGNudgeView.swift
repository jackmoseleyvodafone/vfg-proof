//
//  VFGNudgeView.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 11/15/17.
//

import UIKit
import VFGCommonUtils

class VFGNudgeView: UIView {
    
    var currentHeight: CGFloat {
        get{
            return self.containerView.bounds.size.height
        }
    }
    var closeButtonAction: (()->Void)?
    private var primaryButtonAction: (()->Void)?
    private var secondaryButtonAction: (()->Void)?
    @IBOutlet weak private var width: NSLayoutConstraint!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var primaryButton: UIButton!
    @IBOutlet weak private var secondaryButton: UIButton!
    @IBOutlet weak private var verticalSpaceBetweenPrimaryButtonAndSecondaryButton: NSLayoutConstraint!
    @IBOutlet weak private var primaryButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var secondaryButtonLeftConstraint: NSLayoutConstraint!
    private let numberOflines: Int = 4
    private let nibName: String = "VFGNudgeView"
    
    func setup(title: String? = "", description: String, primaryButtonTitle: String? = "", secondaryButtonTitle: String? = "", primaryButtonAction: (()->Void)?, secondaryButtonAction: (()->Void)?){
        
        self.titleLabel.text = title ?? ""
        self.descriptionLabel.text = description
        
        if descriptionLabel.numberOfVisibleLines > numberOflines {
            descriptionLabel.numberOfLines = numberOflines
        }
        self.containerView.layoutIfNeeded()
        
        if primaryButtonTitle?.count != 0,  secondaryButtonTitle?.count != 0 {
            self.verticalSpaceBetweenPrimaryButtonAndSecondaryButton.priority = UILayoutPriority.high
            self.primaryButtonRightConstraint.priority = UILayoutPriority.low
            self.secondaryButtonLeftConstraint.priority = UILayoutPriority.low
            self.primaryButton.setTitle(primaryButtonTitle, for: .normal)
            self.secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
            self.primaryButtonAction = primaryButtonAction
            self.secondaryButtonAction = secondaryButtonAction
            
        } else if primaryButtonTitle?.count != 0{
            self.primaryButtonRightConstraint.priority = UILayoutPriority.high
            self.secondaryButtonLeftConstraint.priority = UILayoutPriority.low
            self.verticalSpaceBetweenPrimaryButtonAndSecondaryButton.priority = UILayoutPriority.low
            self.primaryButton.setTitle(primaryButtonTitle, for: .normal)
            self.primaryButtonAction = primaryButtonAction
            
        } else if secondaryButtonTitle?.count != 0 {
            self.verticalSpaceBetweenPrimaryButtonAndSecondaryButton.priority = UILayoutPriority.low
            self.primaryButtonRightConstraint.priority = UILayoutPriority.low
            self.secondaryButtonLeftConstraint.priority = UILayoutPriority.high
            self.secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
            self.secondaryButtonAction = secondaryButtonAction
        }
        self.containerView.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    @IBAction private func closeButtonPressed(_ sender: UIButton) {
        closeButtonAction?()
    }
    @IBAction private func primaryButtonPressed(_ sender: UIButton) {
        primaryButtonAction?()
    }
    @IBAction private func secondaryButtonPressed(_ sender: UIButton) {
        secondaryButtonAction?()
    }
    
    private func loadFromNib() {
        if let contentView : UIView = VFGCommonUIBundle.bundle()?.loadNibNamed(self.nibName, owner: self, options: nil)?.first as? UIView {
            contentView.frame = bounds
            self.addSubview(contentView)
            self.layoutIfNeeded()
            self.width.constant = UIScreen.main.bounds.size.width
        }
    }
    
    
}
fileprivate extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

