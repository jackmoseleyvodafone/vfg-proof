//
//  VFGAlertViewDynamic.swift
//  VFGCommonUI
//
//  Created by Michael Attia on 8/22/17.
//  Copyright © 2017 Michael Attia. All rights reserved.
//

import UIKit
import RBBAnimation
import VFGCommonUtils

public class VFGConfigurableAlertView: UIViewController {

    //MARK: - Class Constants
    private static let dynamicAlertStoryboard = "ConfigurableAlertView"
    private static let viewIdentifier = "configurableAlertView"
    private static let closeIcon = "close"
    private static let sidePadding: CGFloat = 30.5
    
    //MARK: - View Outlets
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thridButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - Instance properties
    private var firstButtonCallBack: (()->())?
    private var secondButtonCallBack: (()->())?
    private var thirdButtonCallBack: (()->())?
    private var closeButtonCallback: (()->())?
    
    //MARK: - Setup public methods
    
    /**
     A method that configures and returns an overlay configurable View
     
     - parameter title: the title text to view on the overlay
     - parameter subView: The view to insert in the overlay
     - parameter closeButtonCallback : the close button callback
     
     - returns: an instanse of the configurable AlertView
     */
    public static func configureView<T: UIView>(title: String, subView: T, closeButtonCallback: (()->())?)->VFGConfigurableAlertView? where T: SizeableView{
        let storyboard = UIStoryboard(name: dynamicAlertStoryboard, bundle: VFGCommonUIBundle.bundle())
        guard let alertView : VFGConfigurableAlertView = storyboard.instantiateInitialViewController() as? VFGConfigurableAlertView else {
            VFGLogger.log("Cannot cast to VFGConfigurableAlertView")
            return nil
        }
        let screenWidth = UIScreen.main.bounds.width
        
        alertView.view.backgroundColor = UIColor.VFGBlackTwo
        alertView.headerTitle.text = title
        alertView.headerTitle.applyStyle(VFGTextStyle.headerColored(UIColor.VFGWhite))
        alertView.closeButton.tintColor = UIColor.white
        alertView.closeButton.setImage(UIImage(fromCommonUINamed:closeIcon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        subView.frame.size = CGSize(width: screenWidth - (sidePadding * 2), height: subView.frame.height)
        
        let viewHeight = subView.getViewHeight()
        
        subView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: alertView.containerView.frame.width, height: viewHeight))
        alertView.containerView.frame.size = subView.frame.size
        alertView.containerView.addSubview(subView)
        
        alertView.containerHeight.constant = viewHeight
        
        alertView.closeButton.imageView?.image = UIImage(named: VFGConfigurableAlertView.closeIcon)
        alertView.closeButtonCallback = closeButtonCallback
        
        alertView.firstButton.isHidden = true
        alertView.secondButton.isHidden = true
        alertView.thridButton.isHidden = true
        
        return alertView
    }
    
    /**
     A method that configures and returns an overlay configurable View
     
     - parameter title: the title text to view on the overlay
     - parameter header: the header paragraph of the view
     - parameter img: The image to show
     - parameter imgHeight: the desired image height
     - parameter imgWidth: the desired image width
     - parameter paragraph: the subparagraph to show below the image
     - parameter closeButtonCallback : the close button callback
     
     - returns: an instanse of the configurable AlertView
     */
    public static func configureView(title: String, header: String?, img: UIImage?, imgHeight: Float, imgWidth: Float, paragraph: String?, closeButtonCallback: (()->())?)->VFGConfigurableAlertView? {
        
        if let view : VFGCustomView = VFGCustomView.fromNib() {
            view.setUpView(header: header, paragraph: paragraph, img: img, imgHeight: imgHeight, imgWidth: imgWidth)
        return VFGConfigurableAlertView.configureView(title: title, subView: view, closeButtonCallback: closeButtonCallback)
        }
        
        return nil
    }
    
    /// Use to show and configure the frist button with title and callback action and optoinal style
    public func configureFirstButton(title: String, style: VFGButtonStyle = VFGButtonStyle.primaryButton, callBack: (()->())?)->VFGConfigurableAlertView{
        self.firstButton.isHidden = false
        self.firstButton.titleLabel?.text = title
        self.firstButton.setTitle(title, for: .normal)
        self.firstButton.applyStyle(style)
        self.firstButtonCallBack = callBack
    
        return self
    }
    
    /// Use to show and configure the second button with title and callback action and optoinal style
    public func configureSecondButton(title: String, style: VFGButtonStyle = VFGButtonStyle.secondryButton, callBack: (()->())?)->VFGConfigurableAlertView{
        self.secondButton.isHidden = false
        self.secondButton.titleLabel?.text = title
        self.secondButton.setTitle(title, for: .normal)
        self.secondButton.applyStyle(style)
        self.secondButtonCallBack = callBack
        
        return self
    }
    
    /// Use to show and configure the second button with title and callback action and optoinal style
    public func configureThirdButton(title: String, style: VFGButtonStyle = VFGButtonStyle.tertiaryButton, callBack: (()->())?)->VFGConfigurableAlertView{
        self.thridButton.isHidden = false
        self.thridButton.titleLabel?.text = title
        self.thridButton.setTitle(title, for: .normal)
        self.thridButton.applyStyle(style)
        self.thirdButtonCallBack = callBack
        
        return self
    }
    
    /// Use to change the padding between the overlay title and the injected view
    public func topPadding(_ padding: Float)->VFGConfigurableAlertView{
        self.topPadding.constant = CGFloat(padding)
        return self
    }
    
    /// Call this method to show the alert view
    public func show(){
        
        if let topController = getTopViewController(){
            topController.present(self, animated: true, completion: nil)
        }
    }
    
    //MARK: - View Actions
    
    @IBAction func closebuttonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: closeButtonCallback)
    }
    
    @IBAction func firstButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: firstButtonCallBack)
    }
    
    @IBAction func secondButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: secondButtonCallBack)
    }
    
    @IBAction func thirdButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: thirdButtonCallBack)
    }
    
    //MARK: - View lifecycle
    public override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

}
