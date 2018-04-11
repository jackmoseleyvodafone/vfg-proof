//
//  LoadingView.swift
//  VFGCommonUI
//
//  Created by Mohamed Magdy on 8/19/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import PureLayout

public class LoadingView: UIView {
    
    //MARK: - outlets
    
    @IBOutlet weak var loadingContainerView: UIView!
    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var topMarginStatusBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var loadingBackgroundImage: UIImageView!
    @IBOutlet weak var backgroundDimmedView: UIView!
    @IBOutlet weak var vodafoneLogoImageView: UIImageView!
    
    var shouldShowVodafoneLogo : Bool = false {
        didSet{
            self.vodafoneLogoImageView.isHidden =  !shouldShowVodafoneLogo
        }
    }
    //MARK: - Private Variables
    @IBInspectable var loadingMessage: String? {
        didSet {
            textLabel?.text = loadingMessage
        }
    }

    private var textPositionConstraint : NSLayoutConstraint?

    // MARK: UIView
    init(frame: CGRect, loadingMessage: String?) {
        super.init(frame: frame)
        self.loadingMessage = loadingMessage
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Setup
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        addSubview(spinner)
        if let textLabel : UILabel = textLabel {
            addSubview(textLabel)
        }
        
        setupConstraints()
        
    }
    
    // MARK: Public methods
    
    func startAnimating() {
        spinner.startAnimating()
    }
    
    func stopAnimating() {
        spinner.stopAnimating()
    }
    
    // MARK: Constraints
    
    var itemisedViewHeightConstraint: NSLayoutConstraint?
    
    fileprivate func setupConstraints() {
        spinner.autoSetDimension(.height, toSize: 100.0)
        spinner.autoSetDimension(.width, toSize: 100.0)
        spinner.autoCenterInSuperview()
        
        textLabel?.autoAlignAxis(toSuperviewAxis: .vertical)
        textLabel?.autoPinEdge(.top, to: .bottom, of: spinner, withOffset: 16.0)
        textLabel?.autoPinEdge(toSuperviewEdge: .leading)
        textLabel?.autoPinEdge(toSuperviewEdge: .trailing)
        textLabel?.text = loadingMessage
        textLabel?.numberOfLines = 0
    }
    
    func updateConstraintsForText(edge: ALEdge) {
        resetTextLabel()
        textLabel?.autoPinEdge(toSuperviewEdge: .leading)
        textLabel?.autoPinEdge(toSuperviewEdge: .trailing)
        textLabel?.autoAlignAxis(toSuperviewAxis: .vertical)
        switch edge {
        case .top:
            textLabel?.autoPinEdge(.bottom, to: .top, of: spinner, withOffset: -16.0)
            break
        case .bottom:
            textLabel?.autoPinEdge(.top, to: .bottom, of: spinner, withOffset: 16.0)
            break
        default:
            break
        }
    }
    
    private func resetTextLabel()
    {
        textLabel?.removeFromSuperview()
        textLabel = nil
        textLabel = UILabel()
        textLabel?.textAlignment = .center
        textLabel?.textColor = UIColor.white
        textLabel?.text = loadingMessage
        
        if let textLabel : UILabel = textLabel {
            self.addSubview(textLabel)
        }
    }
    
    // MARK: Property accessors
    fileprivate(set) var textLabel: UILabel? = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()

    
    //MARK: - Private Variables
    private var loadingViewController: VFGLoadingIndicator?


    fileprivate(set) var spinner: SpinnerView = {
        let spinner = SpinnerView()
        spinner.tintColor = UIColor.white
        return spinner
    }()

    override public func awakeFromNib() {
        setup()
    }
    
    
    
    //MARK: private methods
    
    private func setup() {
        backButton.setImage(UIImage.init(named: VFGTopBar.backIconImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil), for: .normal)
        
        MenuButton.setImage(UIImage.init(named: VFGTopBar.menuIconImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil), for: .normal)
        spinner.frame = CGRect.init(x: 0, y: 0, width: loadingContainerView.frame.size.width, height: loadingContainerView.frame.size.height)
        loadingContainerView.backgroundColor = UIColor.clear
        loadingContainerView.addSubview(spinner)
        
        self.vodafoneLogoImageView?.isHidden = !self.shouldShowVodafoneLogo

    }

    
    // MARK: Public methods
    func setLoadingViewController(loadingViewController: VFGLoadingIndicator? = nil){
        self.loadingViewController = loadingViewController
    }
    
    func setHasBackButton(hasButton: Bool){
            backButton.isHidden = !hasButton
    }
    func sethasMenuButton(hasButton: Bool){
            MenuButton.isHidden = !hasButton
    }
    func setBackgroundImage(image: UIImage){
        loadingBackgroundImage.image = image
    }
    func setLoadingThemeColor(color: UIColor){
        loadingLabel?.textColor = color
        spinner.tintColor = color
        
    }
    func setLoadingMessageTxT(message: String){
        loadingLabel?.text = message
    }
    func setHasDimmedBackground(isDimmed: Bool){
        if isDimmed {
            backgroundDimmedView.alpha = 0.5
        }
        else{
            backgroundDimmedView.alpha = 0
        }
    }
    func setShowAppSectionAsBackground(appSectionAsBackground: Bool){
            if appSectionAsBackground {
                    loadingBackgroundImage.alpha = 0
            }
            else{
                loadingBackgroundImage.alpha = 1
        }
    }
    
    
    //MARK: - actions
    
    @IBAction func menuClicked(_ sender: Any) {
        loadingViewController?.delegate.MenuButtonCallback()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        loadingViewController?.delegate.backButtonCallback()
    }
    
}
