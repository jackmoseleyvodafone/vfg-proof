//
//  VFGVoVGeneralCell.swift
//  VFGVoV
//
//  Created by Ehab Alsharkawy on 6/12/17.
//  Copyright © 2017 Vodafone. All rights reserved..
//

import UIKit

public class VFGVoVGeneralCell: VFGVoVBaseView {
    
    @IBOutlet weak var layoutWidth: NSLayoutConstraint?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet var containerView: UIView!
    let cellHeight : CGFloat = 100.0
    let expetedCellWidth : CGFloat = 568

    var indexPath: IndexPath!
   
    //MARK:- Properties
    private var model: VFGVovGeneralModel? {
        didSet {
            mapData()
              self.layoutIfNeeded()
        }
    }
    
    //MARK:- Init
    /**
     Initializer for the view class
     
     - Parameter frame: view frame in super view
     - Parameter model: class model to set its outlets
     
     **/
    public required init(model: VFGVovGeneralModel) {
        let frame : CGRect = CGRect(x: 0, y: 0, width: expetedCellWidth, height: cellHeight)
        super.init(frame: frame)
        loadFromNib()
        self.layoutWidth?.constant = expetedCellWidth
        self.layoutIfNeeded()
        updateModel(model: model)
        self.frame = .zero
        self.layoutIfNeeded()
        self.frame = self.containerView.bounds
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        self.titleLabel.isHidden = true
        self.rightButton.isHidden = true
        self.leftButton.isHidden = true
        
        if self.model?.leftButton != nil {
            self.setupLeftButton()
        }
        if self.model?.rightButton != nil {
            self.setupRightButton()
        }
        self.setupTextLabel()
    }
    
    private func setupLeftButton() {
        self.leftButton.layer.borderColor = UIColor.black.cgColor
        self.leftButton.layer.borderWidth = 1
        self.leftButton.isHidden = !(self.model?.leftButton?.isEnabled ?? false)
        if let text : String = self.model?.leftButton?.text {
            self.leftButton.isHidden = !(text.characters.count > 0)
        }
        else {
            self.leftButton.isHidden = true
        }
        self.leftButton.setTitle(self.model?.leftButton?.text, for: .normal)
        self.leftButton.setTitle(self.model?.leftButton?.text, for: .highlighted)

    }

    private func setupRightButton() {
        self.rightButton.layer.borderColor = UIColor.black.cgColor
        self.rightButton.layer.borderWidth = 1
        self.rightButton.isHidden = !(self.model?.rightButton?.isEnabled ?? false)
        if let text : String = self.model?.rightButton?.text {
            self.rightButton.isHidden = !(text.characters.count > 0)
        }
        else {
            self.rightButton.isHidden = true
        }
        self.rightButton.setTitle(self.model?.rightButton?.text, for: .normal)
        self.rightButton.setTitle(self.model?.rightButton?.text, for: .highlighted)
    }

    
    private func setupTextLabel() {
        if model?.title != nil && !(model?.title.isEmpty ?? true) {
            self.titleLabel.isHidden = false
            titleLabel.setMutableAttributedText(text: model?.title ?? "" + "\n")
            
            if titleLabel.numberOfVisibleLines >= 2 {
                titleLabel.numberOfLines = 2
            }
            else {
                titleLabel.numberOfLines = 1
            }
        } else {
            titleLabel.text = ""
        }
        
        bodyLabel.setMutableAttributedText(text: model?.subtitle ?? "")
        if bodyLabel.numberOfVisibleLines > 4 {
            bodyLabel.numberOfLines = 4
        }
        self.layoutIfNeeded()
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
