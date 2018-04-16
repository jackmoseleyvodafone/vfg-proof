//
//  VFGVoVView.swift
//  VFGVoV
//
//  Created by Mohamed Magdy on 5/23/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

let labelsInitialTranslation    : CGFloat    = -8.0
let separatorInitialTranslation : CGFloat    = 20.0

class VFGVovWelcomeMessageCollectionViewCell: VFGCollectionViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var verticalSeparator: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var marketNameLabel: UILabel!
    
    //MARK:- Properties
    static fileprivate let welcomeFont: UIFont? = UIScreen.isIpad ? UIFont.vodafoneRegularFont(20.0) : UIFont.vodafoneRegularFont(16.0)
    static fileprivate let messageFont: UIFont? = UIScreen.isIpad ? UIFont.vodafoneBoldFont(20.0) : UIFont.vodafoneBoldFont(16.0)
    
    private var model: VFGVovWelcomeMessage? {
        didSet{
            self.mapData()
        }
    }
    
    //MARK:- Private Methods
    private func mapData() {
        self.cellType = .welcome
        if let greeting = model?.greetingToShow {
            greetingLabel.text = greeting
            if ((model?.username) != nil) {
                if ((model?.username!.count) != nil) {
                    greetingLabel.text?.append(", ")
                    greetingLabel.text?.append((model?.username!)!)
                }
                
            }
            
        }
        else {
            greetingLabel.text = model?.greetingToShow
        }
//        usernameLabel.text = model?.username
        
        marketNameLabel.getLabelFormattedStringForWelcomeMessage(model: model)
    }

    
    //MARK:- Public Methods
    public func updateModel(model:VFGVovWelcomeMessage) {
        self.model = model
    }
    
    //MARK:- Animation
    func startAnimation() {
        self.mapData()
        
        verticalSeparator.transform = CGAffineTransform(translationX: separatorInitialTranslation, y: 0.0)
        
        greetingLabel.transform = CGAffineTransform(translationX: labelsInitialTranslation, y: 0.0)
        
//        usernameLabel.transform = CGAffineTransform(translationX: labelsInitialTranslation, y: 0.0)
        
        marketNameLabel.transform = CGAffineTransform(translationX: labelsInitialTranslation, y: 0.0)
        
        UIView.animate(withDuration: generalAnimationDuration, animations: {[weak self] in
            guard let strongSelf = self else {
                VFGLogger.log("failed to get self ")
                return
            }
            strongSelf.verticalSeparator.alpha = 1.0
            strongSelf.verticalSeparator.transform = CGAffineTransform.identity
        })
        
        DispatchQueue.delayMainThreadWithSeconds(generalAnimationDuration * 0.5) {
            UIView.animate(withDuration: generalAnimationDuration, animations: {[weak self] in
                guard let strongSelf = self else {
                    VFGLogger.log("failed to get self ")
                    return
                }
                
                strongSelf.greetingLabel.alpha = 1.0
                strongSelf.greetingLabel.transform = CGAffineTransform.identity
                
//                strongSelf.usernameLabel.alpha = 1.0
//                strongSelf.usernameLabel.transform = CGAffineTransform.identity
                
                strongSelf.marketNameLabel.alpha = 1.0
                strongSelf.marketNameLabel.transform = CGAffineTransform.identity
            })
        }
    }
}
fileprivate extension UILabel {
     func getLabelFormattedStringForWelcomeMessage(model:VFGVovWelcomeMessage?)  {
        var fullNameArr : Array = ((model?.appName) ?? "").components(separatedBy: " ")
        
        let vodafoneString = " " + (fullNameArr.last ?? "")
        fullNameArr.removeLast()
        let myString    =  fullNameArr.joined(separator: " ")

         let myAttrString: NSAttributedString = NSAttributedString(string: myString, attributes: [NSFontAttributeName: VFGVovWelcomeMessageCollectionViewCell.welcomeFont!, NSForegroundColorAttributeName: UIColor.white])
        
        let VodafoneAttrString: NSAttributedString = NSAttributedString.init(string: vodafoneString, attributes: [NSFontAttributeName: VFGVovWelcomeMessageCollectionViewCell.messageFont!, NSForegroundColorAttributeName: UIColor.white])
        
           let welcomeAttrString: NSAttributedString = NSAttributedString.init(string: (model?.welcomeMessage) ?? "", attributes: [NSFontAttributeName: VFGVovWelcomeMessageCollectionViewCell.welcomeFont!, NSForegroundColorAttributeName: UIColor.white])
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        let attrString: NSMutableAttributedString = NSMutableAttributedString()
        
        paragraphStyle.lineBreakMode = .byCharWrapping
        
        attrString.append(welcomeAttrString)
        attrString.append(myAttrString)
        attrString.append(VodafoneAttrString)
        
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText =  attrString
        
    }
}
