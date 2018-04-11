//
//  VFGExpandedContentWithButtonCell.swift
//  VFGCommonUI
//
//  Created by mohamed matloub on 1/30/18.
//

import UIKit

public class VFGExpandedContentWithButtonCell: UITableViewCell {

    @IBOutlet weak var actionView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var arrowImageView: UIImageView!
    @IBOutlet weak private var descriptionLabel: UILabel!
    @IBOutlet weak private var actionButton: UIButton!
    @IBOutlet weak private var descriptionView: UIView!
    @IBOutlet weak private var actionViewHeightConstraint: NSLayoutConstraint!
    
    var contentAttributedString = NSMutableAttributedString()

    public var cardContents: NormalParagraphWithAction?{
        didSet{
            self.bindData()
        }
    }

    public var cardTitle : String!{
        didSet{
            self.titleLabel.text = cardTitle
        }
    }
    public override func awakeFromNib() {
        self.selectionStyle = .none
        descriptionLabel.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGOverlayOnTapTertiaryGray))
        self.isExpanded = false
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
                descriptionView.isHidden = true
                descriptionLabel.text = ""
                actionViewHeightConstraint.constant = 0
                
            } else {
                angle = CGFloat(Double.pi)
                isExpanded = true
                descriptionView.isHidden = false
                let resultAttributedString = getText(cardContents: cardContents!)
                descriptionLabel.attributedText = resultAttributedString
                actionViewHeightConstraint.constant = 70
            }
            
            self.layoutSubviews()
            UIView.animate(withDuration: 0.3) {[weak self] in
                let tr = CGAffineTransform.identity.rotated(by: angle)
                self?.arrowImageView.transform = tr
            }
            
        }
    }
    
    func bindData(){
        self.actionButton.setTitle(self.cardContents?.actionTitle ?? "", for: .normal)
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        self.cardContents?.action()
    }
    
    private func getText(cardContents: NormalParagraphWithAction) -> NSMutableAttributedString {
        contentAttributedString.setAttributedString(NSAttributedString(string: ""))
            if contentAttributedString.length != 0 {
                contentAttributedString.append(NSAttributedString(string: ""))
                self.appendStringWithContentType(item: cardContents)
            }else{
                self.appendStringWithContentType(item: cardContents)
            }
        return contentAttributedString
    }
    
    private func appendStringWithContentType(item: NormalParagraphWithAction) {
            contentAttributedString.append(NSAttributedString(string: item.paragraph))
            contentAttributedString.append(NSAttributedString(string: "\n"))
    }

}
