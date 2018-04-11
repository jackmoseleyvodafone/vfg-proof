//
//  VFGCommonHeaderContainerController.swift
//  VFGCommon
//
//  Created by kasa on 10/11/2016.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Object of this class serve as container for other view controllers.
 This class provides chipped view, image background and possibility to scroll the view. Contained viewss are put inside chipped view
 */
public class VFGCommonHeaderContainerController: UIViewController, VFGRootViewControllerContent {
    
    static let storyboardName : String = "VFGCommonHeaderContainer"
    static private let backgroundImageName = "CommonHeaderContainerBackground";
    
    static let verticalHeaderMargin: CGFloat = UIScreen.isIpad ? 30.0 : 10.0
    static let horizontalContentMargin: CGFloat = UIScreen.isIpad ? 30.0 : 10.0
    static let headerFontSize : CGFloat = UIScreen.isIpad ? 39.9 : 30.0
    

    /**
     content Top Margin To TopBar, default = 93.0
     */

    public var contentTopMarginToTopBar: CGFloat = UIScreen.isIpad ? 117.0 : 93.0
    static let headerLabelMarginToContent: CGFloat = UIScreen.isIpad ? 40.0 : 24.0
    
    
    @IBOutlet weak var shadowBackgroundView: VFGChippedShadowView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    /**
     Title of header presented above chipped view.
     */
    public var headerTitle : String? {
        didSet {
            self.headerLabel?.text = headerTitle
        }
    }
    
    /**
     The background image of the container controller.
     */
    public var backgroundImage : UIImage? = UIImage(named: VFGCommonHeaderContainerController.backgroundImageName, in: VFGCommonUIBundle.bundle(), compatibleWith: nil) {
        didSet {
            self.backgroundImageView?.image = backgroundImage
        }
    }
    
    
    public var rootViewControllerContentStatusBarState : VFGRootViewControllerStatusBarState = .black
    
    public var rootViewControllerContentTopBarScrollDelegate : VFGTopBarScrollDelegate? = VFGTopBarScrollDelegate()
    
    public var topBarRightButtonHidden: Bool = false
    
    public var rootViewControllerContentTopBarTitle: String = ""
    
    var containerYOffsetBasedOnContenView : CGFloat = 0 {
        didSet {
            self.headerLabel.frame = self.currentFrameForHeaderLabel()
            self.shadowBackgroundView.frame = self.currentFrameForShadowBackground()
            self.rootViewControllerContentTopBarScrollDelegate?.didScroll(withOffset: containerYOffsetBasedOnContenView)
        }
    }
    
    var contentOriginYBasedOnContainer : CGFloat = 0 {
        didSet {
            self.rootViewControllerContentTopBarScrollDelegate?.alphaChangeYPosition = contentOriginYBasedOnContainer
            self.scrollableContainedViewController?.originY = contentOriginYBasedOnContainer
        }
    }
    
    public var containedController : UIViewController?
    public var scrollableContainedViewController : VFGCommonHeaderContentController?
    
    /**
     Creates common header component with not scrollable container views
     
     - Parameter withViewController: View controller which will be put inside this controller
     
     */
    static public func commonHeaderContainerController(withViewController viewController: UIViewController) -> VFGCommonHeaderContainerController {
        guard let commonHeaderVC : VFGCommonHeaderContainerController =  UIStoryboard(name:storyboardName, bundle:VFGCommonUIBundle.bundle()).instantiateViewController(withIdentifier: String(describing: self)) as? VFGCommonHeaderContainerController else {
            VFGLogger.log("Cannot cast data to VFGCommonHeaderContainerController")
            return VFGCommonHeaderContainerController()
        }
        
        commonHeaderVC.addChildViewController(viewController)
        commonHeaderVC.view.addSubview(viewController.view)
        commonHeaderVC.containedController = viewController
        commonHeaderVC.didMove(toParentViewController: viewController)
        
        return commonHeaderVC
    }
    
    /**
     Creates common header component with scrollable container views
     
     - Parameter withViewController: View controller which will be put inside this controller and based on which scroll the container views will be moved
     
     */
    static public func scrollableCommonHeaderContainerController(withViewController viewController: VFGCommonHeaderContentController) -> VFGCommonHeaderContainerController {
        let commonHeaderVC : VFGCommonHeaderContainerController =  self.commonHeaderContainerController(withViewController: viewController)
        
        viewController.adjustedScrollOffsetChangedCallback = { [weak commonHeaderVC] (offset : CGFloat) in
            commonHeaderVC?.containerYOffsetBasedOnContenView = offset
        }
        commonHeaderVC.scrollableContainedViewController = viewController
        
        return commonHeaderVC
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBackground()
        self.setupBackgroundImage()
        self.setupHeader()
    }
    
    private func setupBackgroundImage() {
        self.backgroundImageView.image = self.backgroundImage
    }
    
    private func setupHeader() {
        
        rootViewControllerContentTopBarTitle = headerTitle ?? ""
        self.headerLabel.font = UIFont.vodafoneRegularFont(VFGCommonHeaderContainerController.headerFontSize)
        self.headerLabel.minimumScaleFactor = 0.5;
        self.headerLabel.textColor = UIColor.white
        self.headerLabel.textAlignment = .center
        self.headerLabel.text = self.headerTitle
        self.view.addSubview(self.headerLabel)
    }
    
    private func setupBackground() {
        self.shadowBackgroundView.visibleBackgroundColor = UIColor.VFGChippViewBackground
        self.view.addSubview(self.shadowBackgroundView)
    }
    
    private func currentFrameForHeaderLabel() -> CGRect {
        var frame = self.baseFrameForHeaderLabel()
        frame.origin.y -= self.containerYOffsetBasedOnContenView
        return frame
    }
    
    private func currentFrameForShadowBackground() -> CGRect {
        var frame = self.baseFrameForShadowBackground()
        frame.origin.y -= self.containerYOffsetBasedOnContenView
        frame.size.height += self.containerYOffsetBasedOnContenView
        return frame
    }
    
    private func baseFrameForHeaderLabel() -> CGRect {
        let size = self.headerLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        var frame = CGRect(origin: CGPoint.zero, size: size)
        frame.origin.x = (self.view.bounds.width - frame.size.width)/2;
        frame.origin.y = self.baseFrameForShadowBackground().minY - VFGCommonHeaderContainerController.headerLabelMarginToContent - size.height
        return frame;
    }
    
    private func baseFrameForShadowBackground() -> CGRect {
        var frame = self.view.bounds
        frame.origin.y = VFGTopBar.topBarHeight + self.contentTopMarginToTopBar
        frame.size.height -= frame.origin.y
        return frame;
    }
    
    private func baseFrameForContentView() -> CGRect {
        return self.view.bounds.insetBy(dx: VFGCommonHeaderContainerController.horizontalContentMargin, dy: 0)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerLabel.frame = self.currentFrameForHeaderLabel()
        self.shadowBackgroundView.frame = self.currentFrameForShadowBackground()
        self.backgroundImageView.frame = self.view.bounds
        if (!self.contentOriginYBasedOnContainer.equalsWithEpsilon(other: self.computedContentYOrigin())) {
            self.contentOriginYBasedOnContainer = self.computedContentYOrigin()
        }
        if (self.scrollableContainedViewController == nil) {
            self.containedController?.view.frame = baseFrameForStaticContentView()
        } else {
            self.scrollableContainedViewController?.layoutContentInArea(self.baseFrameForContentView())
        }
    }
    
    private func computedContentYOrigin() -> CGFloat {
        
        return UIScreen.isIpad ? (VFGCommonUISizes.statusBarHeight + self.baseFrameForShadowBackground().minY + 12) : VFGCommonUISizes.statusBarHeight + self.baseFrameForShadowBackground().minY
    }
    
    private func baseFrameForStaticContentView() -> CGRect {
        var frame : CGRect = self.baseFrameForContentView()
        frame.origin.y = self.baseFrameForShadowBackground().minY + VFGCommonUISizes.statusBarHeight
        frame.size.height -= (self.baseFrameForShadowBackground().minY + VFGCommonUISizes.statusBarHeight * 2)
        
        return frame
    }
    
}
