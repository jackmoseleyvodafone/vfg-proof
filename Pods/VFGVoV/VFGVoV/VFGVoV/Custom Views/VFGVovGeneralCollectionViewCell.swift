//
//  VFGVoVGeneralCell.swift
//  VFGVoV
//
//  Created by Ehab Alsharkawy on 6/12/17.
//  Copyright © 2017 Vodafone. All rights reserved..
//

import UIKit

protocol VFGVoVGeneralCellDelegate {
    func rightButtonDidSelected(_ index: Int)
    func leftButtonDidSelected(_ index: Int)
}

internal class VFGCollectionViewCell : UICollectionViewCell {
    internal var cellType: VovCellType = .eventDriven
}

internal class VFGVovGeneralCollectionViewCell: VFGCollectionViewCell {
    
    @IBOutlet weak var layoutWidth: NSLayoutConstraint?
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    internal var delegate: VFGVoVGeneralCellDelegate?
    let cellHeight : CGFloat = 100.0
    var indexPath: IndexPath!
    
    
    
    
    //MARK:- Properties
    internal var model: VFGVovGeneralModel? {
        didSet {
            mapData()
            self.layoutIfNeeded()
        }
    }
    
    //MARK:- Public Methods
    public func updateModel(model:VFGVovGeneralModel) {
        self.model = model
    }
    
    //MARK:- Private Methods
    private func mapData() {
        self.setupViews()
    }
    
    private func setupViews() {
//        self.titleLabel.isHidden = true
        self.rightButton.isHidden = true
        self.leftButton.isHidden = true
        
        if self.model?.leftButton != nil {
            self.setupLeftButton()
        }
        if self.model?.rightButton != nil {
            self.setupRightButton()
        }
        self.setupTextLabel()
        self.cellType()
    }
    
    func cellType() {
        if self.leftButton.isHidden || self.rightButton.isHidden {
            self.cellType = .eventDriven
        }
        else{
            self.cellType = .campagin
        }
    }
    
    private func setupLeftButton() {
        self.leftButton.layer.borderColor = UIColor.black.cgColor
        self.leftButton.layer.borderWidth = 1
        self.leftButton.isHidden = !(self.model?.leftButton?.isEnabled ?? false)
        if let text : String = self.model?.leftButton?.text {
            self.leftButton.isHidden = !(text.count > 0)
        }
        else {
            self.leftButton.isHidden = true
        }
        self.leftButton.setTitle(self.model?.leftButton?.text, for: .normal)
        self.leftButton.setTitle(self.model?.leftButton?.text, for: .highlighted)
        
        self.leftButton.addTarget(self, action: #selector(self.leftButtonAction(button:)), for: .touchUpInside)
        
    }
    
    func leftButtonAction(button: UIButton) {
        // if rightButton is not  hidden this means left button is not for dismiss(buiness requirement)
        
        if let index : Int = self.model?.leftButton?.messageIndex {
            self.delegate?.leftButtonDidSelected(index)
       
        }
    }
    
    private func setupRightButton() {
        self.rightButton.layer.borderColor = UIColor.black.cgColor
        self.rightButton.layer.borderWidth = 1
        self.rightButton.isHidden = !(self.model?.rightButton?.isEnabled ?? false)
        if let text : String = self.model?.rightButton?.text {
            self.rightButton.isHidden = !(text.count > 0)
        }
        else {
            self.rightButton.isHidden = true
        }
        self.rightButton.setTitle(self.model?.rightButton?.text, for: .normal)
        self.rightButton.setTitle(self.model?.rightButton?.text, for: .highlighted)
        self.rightButton.addTarget(self, action: #selector(self.rightButtonAction(button:)), for: .touchUpInside)
    }
    
    func rightButtonAction(button: UIButton) {
        if let index : Int = self.model?.rightButton?.messageIndex{
            VoVAnalyticsHandler.trackEventWithCampaign(eventLabel: self.model?.eventLabel, eventAction: "VOV Discarded", eventName: "vov_message_discarded", campainName: self.model?.campaignName, campainId: self.model?.campaignId, eventType: "campaign_discard")
            self.delegate?.rightButtonDidSelected(index)
        }
    }
    
    private func setupTextLabel() {

        let messageText = !(model?.title.isEmpty)! ? "\(model!.title)\r\(model!.subtitle)" : model!.subtitle
        
        let attributedString = NSMutableAttributedString(string: messageText, attributes: [
            NSFontAttributeName: UIFont.vodafoneRegularFont(16)!,
            NSForegroundColorAttributeName: UIColor(white: 51.0 / 255.0, alpha: 1.0)
            ])
 
        if !(model?.title.isEmpty)! {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.vodafoneRegularFont(24)!, range: NSRange(location: 0, length: model!.title.count))
        }

        titleLabel.attributedText = attributedString
    }
    public func getLabelHeight() -> CGFloat{
        return titleLabel.estimatedHeightOfLabel()
    }
    
}

fileprivate extension UILabel {
    
    func estimatedHeightOfLabel() -> CGFloat {
        let text = self.text!
        let size = CGSize(width: self.frame.width - 16, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 10)]
        
        let rectangleHeight = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
        
        return rectangleHeight
    }
    

    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
    
    func setMutableAttributedText(text : String) {
        let textString: NSAttributedString = NSAttributedString(string: text , attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.init(red: 51.0/255, green: 51.0/255, blue: 51.0/255, alpha: 1.0)])
        let paragraphStyle = NSMutableParagraphStyle()
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .left
        attrString.append(textString)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

