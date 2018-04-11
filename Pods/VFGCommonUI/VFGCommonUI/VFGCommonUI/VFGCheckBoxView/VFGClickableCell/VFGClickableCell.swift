//
//  CustomTableViewCell.swift
//  TestProj
//
//  Created by Ahmed Askar on 8/9/17.
//  Copyright © 2017 Askar. All rights reserved.
//

import UIKit
import VFGCommonUtils

public enum ClickableCellStyle: Int {
    case none = 0   // Simple cell with text label "title" and "sub title"
    case toggle     // Right aligned switch control
    case image      // Right aligned image
    case disclosureIndicator    // regular chevron.
    case expandable     //Right aligned down arrow
}

public class ToggleStyle {
    fileprivate(set) var isChecked : Bool = false
    fileprivate(set) var toggleSwitch: UISwitch?
    public var onToggleActionComplete: ((_ isChecked : Bool) -> Void)?
}

public class ImageStyle {
    fileprivate(set) var contentViewImage: UIImageView?
    public var onClickImageActionComplete: (() -> Void)?
}

public class ExpandStyle {
    fileprivate(set) var isExpanded :Bool = false
    public var onExpandComplete: (() -> Void)?
}

public class VFGClickableCell: UITableViewCell {
    
    public var toggleStyle : ToggleStyle?
    
    public var imageStyle : ImageStyle?
    
    public var expandStyle : ExpandStyle?
    
    @IBOutlet weak private var stripViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var stripView: UIView!
    
    @IBOutlet weak private var viewContent :UIView!
    
    @IBOutlet weak private var customCellTitle: UILabel!
    
    @IBOutlet weak private var customCellSubtitle: UILabel!
    
    private var arrowImage = UIImageView()
    
    /** Property to set cell title */
    public var cellTitle: String? {
        didSet {
            customCellTitle.text = cellTitle
            customCellTitle.applyStyle(VFGTextStyle.cellTitleColored(UIColor.VFGBlack))
        }
    }
    
    /** Property to set cell sub-title */
    public var cellSubTitle: String? {
        didSet {
            customCellSubtitle.text = cellSubTitle
            customCellSubtitle.applyStyle(VFGTextStyle.paragraphColored(UIColor.VFGBlack))
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
            
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
        }
    }
    
    /** Property to assign image button incase your cell of type image */
    public var cellImage: UIImage? {
        didSet {
            imageStyle?.contentViewImage?.image = cellImage
        }
    }
    
    /** Used to define the cell style */
    public var cellStyle : ClickableCellStyle? {
        didSet {
            switch cellStyle! {
            case .none :
                self.selectionStyle = .none
                viewContent.translatesAutoresizingMaskIntoConstraints = false
                break
            case .toggle:
                
                toggleStyle = ToggleStyle()
                
                let switchBtn = UISwitch()
                
                switchBtn.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
                switchBtn.onTintColor = UIColor(red: 4/255, green: 123/255, blue: 147/255, alpha: 1)
                switchBtn.layer.cornerRadius = 16.0;
                
                switchBtn.addTarget(self, action: #selector(toggleSwitchAction), for: UIControlEvents.valueChanged)
                switchBtn.translatesAutoresizingMaskIntoConstraints = false
                toggleStyle?.toggleSwitch = switchBtn
                
                if let toggleSwitch = toggleStyle?.toggleSwitch {
                    self.viewContent.addSubview(toggleSwitch)
                    let xConstraint = NSLayoutConstraint(item: toggleSwitch, attribute: .centerX, relatedBy: .equal, toItem: self.viewContent, attribute: .centerX, multiplier: 1, constant: 0)
                    let yConstraint = NSLayoutConstraint(item: toggleSwitch, attribute: .centerY, relatedBy: .equal, toItem: self.viewContent, attribute: .centerY, multiplier: 1, constant: 0)
                    self.viewContent.addConstraint(xConstraint)
                    self.viewContent.addConstraint(yConstraint)
                    self.selectionStyle = .none
                }
                
            case .image:
                
                imageStyle = ImageStyle()
                
                let image = UIImageView()
                image.frame = CGRect(x: 0, y: 20, width: 60.0, height: 60.0)
                image.translatesAutoresizingMaskIntoConstraints = false
                imageStyle?.contentViewImage = image
                
                if let contentViewImage = imageStyle?.contentViewImage {
                    
                    self.viewContent.addSubview(contentViewImage)
                    
                    let topConstraint = NSLayoutConstraint(item: image, attribute: .top, relatedBy: .equal, toItem: viewContent, attribute: .top, multiplier: 1, constant: 25)
                    
                    let trailingConstraint = NSLayoutConstraint(item: viewContent, attribute: .trailing, relatedBy: .equal, toItem: image, attribute: .trailing, multiplier: 1, constant: 11)
                    
                    let widthConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: image.frame.size.width)
                    
                    let heightConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: image.frame.size.height)
                    
                    self.viewContent.addConstraint(widthConstraint)
                    self.viewContent.addConstraint(heightConstraint)
                    self.viewContent.addConstraint(topConstraint)
                    self.viewContent.addConstraint(trailingConstraint)
                    NSLayoutConstraint.activate([topConstraint, trailingConstraint,widthConstraint,heightConstraint])
                    
                    contentViewImage.contentMode = UIViewContentMode.center
                    
                    self.selectionStyle = .none
                    
                    image.isUserInteractionEnabled = true
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImageAction(tapGestureRecognizer:)))
                    image.addGestureRecognizer(tapGestureRecognizer)
                }
                
            case .disclosureIndicator:
                
                let arrowImage = UIImageView()
                arrowImage.frame = CGRect(x: 0, y: 0, width: 11, height: 20)
                let image = UIImage(named: "right_arrow", in:VFGCommonUIBundle.bundle(), compatibleWith: nil)
                arrowImage.image = image
                arrowImage.contentMode = .scaleToFill
                arrowImage.translatesAutoresizingMaskIntoConstraints = false
                self.viewContent.addSubview(arrowImage)
                
                let trailingConstraint = NSLayoutConstraint(item: self.viewContent!, attribute: .trailing, relatedBy: .equal, toItem: arrowImage, attribute: .trailing, multiplier: 1, constant: 20)
                
                let yConstraint = NSLayoutConstraint(item: arrowImage, attribute: .centerY, relatedBy: .equal, toItem: self.viewContent, attribute: .centerY, multiplier: 1, constant: 0)
                
                let widthConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: arrowImage.frame.size.width)
                
                let heightConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: arrowImage.frame.size.height)
                
                self.viewContent.addConstraint(trailingConstraint)
                self.viewContent.addConstraint(yConstraint)
                self.viewContent.addConstraint(widthConstraint)
                self.viewContent.addConstraint(heightConstraint)
                
                self.selectionStyle = .none
                
            case .expandable:
                
                expandStyle = ExpandStyle()
                arrowImage.frame = CGRect(x: 0, y: 15, width: 24, height: 13)
                let image = UIImage(named: "down_arrow", in:VFGCommonUIBundle.bundle(), compatibleWith: nil)
                arrowImage.image = image
                arrowImage.contentMode = .scaleToFill
                arrowImage.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(arrowImage)
                
                let topConstraint = NSLayoutConstraint(item: arrowImage, attribute: .top, relatedBy: .equal, toItem: viewContent, attribute: .top, multiplier: 1, constant: 44)
                
                let trailingConstraint = NSLayoutConstraint(item: viewContent, attribute: .trailing, relatedBy: .equal, toItem: arrowImage, attribute: .trailing, multiplier: 1, constant: 20)
                
                let widthConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: arrowImage.frame.size.width)
                
                let heightConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: arrowImage.frame.size.height)
                
                self.addConstraint(topConstraint)
                self.addConstraint(trailingConstraint)
                self.addConstraint(widthConstraint)
                self.addConstraint(heightConstraint)
                self.selectionStyle = .none
                let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(expandAction))
                self.viewContent.addGestureRecognizer(tapGuesture)
            }
        }
    }
    
    public override func awakeFromNib() {
        viewContent.layer.shadowColor = UIColor.lightGray.cgColor;
        viewContent.layer.shadowOffset = CGSize(width:0, height: 2)
        viewContent.layer.shadowOpacity = 0.8;
        viewContent.layer.shadowRadius = 3;
        viewContent.layer.masksToBounds = false;
    }
    
    public func setImageAction(_ action: @escaping () -> ()) {
        if let image = imageStyle {
            image.onClickImageActionComplete = action
        }
        else {
            VFGLogger.log("Calling setImage action on empty image optional")
        }
    }
    
    public  func setToggleAction(_ action: @escaping (Bool) -> ()) {
        if let toggle = toggleStyle {
            toggle.onToggleActionComplete = action
        }
        else {
            VFGLogger.log("Calling setToggleAction on empty toggle optional")
        }
    }
    
    public func setExpandAction(_ action: @escaping () -> ()) {
        if let expand = expandStyle {
            expand.onExpandComplete = action
        }
    }
    
    @objc private func toggleSwitchAction(sender: AnyObject) {
        
        let switchBtn: UISwitch? = sender as? UISwitch
        if let switchBtn = switchBtn {
            if switchBtn.isOn {
                toggleStyle?.isChecked = true
            }else{
                toggleStyle?.isChecked = false
            }
            
            if let callback = toggleStyle?.onToggleActionComplete {
                callback (toggleStyle!.isChecked)
            }
            else {
                VFGLogger.log("ToggleSwitchAction callback is missing")
            }
        }
        else {
            VFGLogger.log("Calling toggleSwitchAction on empty UISwitch optional")
        }
    }
    
    @objc private func clickImageAction(tapGestureRecognizer: UITapGestureRecognizer) {
        
        if let callback = imageStyle?.onClickImageActionComplete {
            callback ()
        }
        else {
            VFGLogger.log("clickImageAction callback is missing")
        }
    }
    
    @objc private func expandAction() {
        
        var angle: CGFloat = 0.0
        
        if let expand = expandStyle {
            if expand.isExpanded {
                angle = CGFloat(Double.pi * 2)
                stripViewHidden = false
                expandStyle?.isExpanded = false
                
            }else{
                angle = CGFloat(Double.pi)
                stripViewHidden = true
                expand.isExpanded = true
            }
        }
        
        UIView.animate(withDuration: 2, animations: {
            self.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.7) {[weak self] in
            let tr = CGAffineTransform.identity.rotated(by: angle)
            self?.arrowImage.transform = tr
        }
        
        if let callBack = expandStyle?.onExpandComplete {
            callBack()
        }
    }
}

