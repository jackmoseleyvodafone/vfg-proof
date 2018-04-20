//
//  VFGLoadingIndicator.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/19/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import PureLayout

public class VFGLoadingIndicator: UIView {
   
    //MARK: - Private Variables
    
    private var loadingIndicator        : LoadingView!
    private var defaultLoadingMessage   : String = "loading..."
    private var defaultImageName        : String = "evening_sl"
    private var defaultThemeColor       : UIColor = UIColor.white
    private var hasBackButton           : Bool = true
    private var hasMenuButton           : Bool = true
    private var hasDimmedBackground           : Bool = true
    private var appSectionAsBackground : Bool = false

    public var delegate: VFGLoadingIndicatorViewProtocol!
    
    required public init(frame: CGRect, loadingMessage: String) {
        super.init(frame: frame)
        self.defaultLoadingMessage = loadingMessage
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = aDecoder.decodeCGRect(forKey: "frame")
        if let defaultLoadingMessage = aDecoder.decodeObject(forKey: "defaultLoadingMessage") as? String {
            self.defaultLoadingMessage = defaultLoadingMessage
        }
    }
    
    override public var frame: CGRect {
        didSet {
            loadingIndicator?.removeFromSuperview()
            loadingIndicator = nil
            setupView()
        }
    }
    
    //MARK: - Private Methods
    private func setupView() {
        loadingIndicator = LoadingView(frame: bounds, loadingMessage: defaultLoadingMessage)
        self.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        loadingIndicator.backgroundColor = UIColor.clear
        backgroundColor = UIColor.gray.withAlphaComponent(1)
    }

    //MARK: - Configuration Methods
    /**
     sets the loading message of the loading indicator
     - Parameter message: message to be shown
     */
    public func setLoadingMessage(_ message: String) {
        loadingIndicator.loadingMessage = message
    }
    
    /**
     Updates label position relative to the spinner
     - Parameter position: takes a value .top or .bottom to update the text position (Only Top and Botton positions are supported)
     */
    public func updateTextPositionTo(position: ALEdge) {
        loadingIndicator.updateConstraintsForText(edge: position)
    }

    /*
     loading indicator initalizer, takes a class object which implements VFGLoadingIndicatorViewProtocol protocol.
     
     */
    public init(delegate: VFGLoadingIndicatorViewProtocol) {
        super.init(frame: (UIApplication.shared.keyWindow?.frame)!)
        
        self.delegate = delegate
        
        loadingIndicator = UINib.init(nibName: "LoadingView", bundle: VFGCommonUIBundle.bundle()).instantiate(withOwner: nil, options: [:]).first! as! LoadingView
        loadingIndicator.frame = (UIApplication.shared.keyWindow?.bounds)!

        loadingIndicator.setLoadingViewController(loadingViewController: self)

    
        
    }
    
    //MARK: -  configuration methods
    private func configureLoadingIndicator() {
        loadingIndicator.setBackgroundImage(image: (delegate?.getBackgroundImage?() ?? UIImage.init(named: defaultImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil))!)
        loadingIndicator.setHasBackButton(hasButton: delegate?.hasBackButton?() ?? hasBackButton)
        loadingIndicator.sethasMenuButton(hasButton: delegate?.hasMenuButton?() ?? hasMenuButton)
        loadingIndicator.setLoadingThemeColor(color: delegate?.getThemeColor?() ?? UIColor.white)
        loadingIndicator.setHasDimmedBackground(isDimmed: delegate?.hasDimmedBackground?() ?? hasDimmedBackground )
        loadingIndicator.setShowAppSectionAsBackground(appSectionAsBackground: delegate?.showAppSectionAsBackground?() ?? appSectionAsBackground)
        loadingIndicator.setLoadingMessageTxT(message: delegate?.getLoadingMessage?() ?? defaultLoadingMessage)
        loadingIndicator.shouldShowVodafoneLogo = self.delegate?.shouldShowVodafoneLogo?() ?? false
    }
    
    /*
     adds the loading view to the keywindow
     */
    public func showLoading(){
        configureLoadingIndicator()
        loadingIndicator.startAnimating()
        UIApplication.shared.keyWindow?.addSubview(loadingIndicator)
    }
    
    /*
     remove the loading view to the keywindow
     */
    public func hideLoading() {
        loadingIndicator.startAnimating()
        loadingIndicator.removeFromSuperview()
    }
}
