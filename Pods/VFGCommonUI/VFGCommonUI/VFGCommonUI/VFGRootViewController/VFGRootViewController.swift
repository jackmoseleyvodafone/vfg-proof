//
//  VFGRootViewController.swift
//  VFGCommonUI
//
//  Created by Mateusz Zakrzewski on 03.01.2017.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 View controller which should be a root view controller of the application. Provides top bar and navigation buttons.
 All view controllers should be added to its `containerNavigationController`
 */

public enum BubbleColor {
    case red
    case white
}

public class VFGRootViewController: UIViewController {
    
    // MARK: - Public Instance Variables
    
    /**
     * Keeping track of number of view controllers inside the navigation stack
     */
    var navigationControllerCounter: Int = 0
    /**
     * Enum value to set the background color of the VFGNeedHelp floating bubble, default value is **White**
     */
    public var floatingBubbleColor: BubbleColor = .red
    // MARK: - Private Instance Constants
    
    private static let rootViewControllerStoryboardName = "VFGRootViewControllerStoryboard"
    private static let rootViewControllerStoryboardId = "VFGRootViewController"
    private static let embedSegue = "embedNavigationController"
    private static let animationDuration = 0.2
    private let topBarYPosition: CGFloat = 20
    private let animationDuarationTime: TimeInterval = 0.5
    
    static var componentsFactory : VFGRootViewControllerComponentsFactory = VFGRootViewControllerComponentsFactory()
    
    /**
     Top Bar containing navigation buttons.
     */
    @IBOutlet public  weak var topBar: VFGTopBar!
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var blackOverlayView: UIView!
    @IBOutlet weak var nudgeView: VFGNudgeView!
    @IBOutlet weak var nudgeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    private var shouldNudgeView:Bool = false
    /**
     Show Nudge View with Data
     @param title Optinal String, title of Nudge view
     @param description String, description of Nudge view
     @param primaryButtonTitle String, primary Button Title of Nudge view
     @param secondaryButtonTitle String, secondary Button Title of Nudge view
     @param primaryButtonAction Optinal callback, primary Button Action of Nudge view
     @param secondaryButtonAction Optinal callback, secondary Button Action of Nudge view
     @param closeAction Optinal callback, close Action of Nudge view
     */
    public func showNudgeView(title: String? = "", description: String, primaryButtonTitle: String? = "", secondaryButtonTitle: String? = "", primaryButtonAction: (()->Void)?, secondaryButtonAction:(()->Void)?, closeAction: @escaping ()->Void) {
        
        nudgeView.setup(title: title, description: description, primaryButtonTitle: primaryButtonTitle, secondaryButtonTitle: secondaryButtonTitle, primaryButtonAction: primaryButtonAction, secondaryButtonAction: secondaryButtonAction)
        
        nudgeView.closeButtonAction = closeAction
        
        self.showNudge()
    }
    
    private func showNudge(){
        self.currentTopBarScrollDelegate.refresh()
        self.shouldNudgeView = true
        
        self.nudgeView.isHidden = false
        
        nudgeViewHeightConstraint.constant = nudgeView.currentHeight - self.topBarYPosition
        self.currentTopBarScrollDelegate.topBarInitialY = nudgeView.currentHeight
        self.currentTopBarScrollDelegate.topBar = self.topBar
        UIView.animate(withDuration: self.animationDuarationTime, animations:{
            self.view.layoutIfNeeded()
        })
        
    }
    
    public func hideNudgeView() {
        self.currentTopBarScrollDelegate.refresh()
        nudgeViewHeightConstraint.constant = 0.0
        self.currentTopBarScrollDelegate.topBarInitialY = self.topBarYPosition
        self.currentTopBarScrollDelegate.topBar = self.topBar
        UIView.animate(withDuration: self.animationDuarationTime, animations: {[weak self] in
            self?.view.layoutIfNeeded()
        }){ (done) in
            self.nudgeView.isHidden = true
        }
        self.shouldNudgeView = false
    }
    
    private func hideNudgeViewTemp(){
        let showNudgeTmp = self.shouldNudgeView
        self.hideNudgeView()
        self.shouldNudgeView = showNudgeTmp
    }
    /**
     Side menu which is presented when user clicks on menu button.
     */
    public internal(set) lazy var sideMenu: VFGSideMenuViewController = {
        return VFGRootViewController.componentsFactory.sideMenuViewController(inViewController: self)
    }()
    
    public var floatingBubble: VFGFloatingBubbleView?
    
    private lazy var statusBarManager : VFGRootViewControllerStatusBarManager = {
        return VFGRootViewController.componentsFactory.statusBarManager()
    }()
    
    public var containerNavigationController: VFGNavigationController!
    
    private var currentTopBarScrollDelegate : VFGTopBarScrollDelegate {
        return self.contentTopBarScrollDelegate ?? self.defaultTopBarScrollDelegate
    }
    private var contentTopBarScrollDelegate : VFGTopBarScrollDelegate? = nil
    private var defaultTopBarScrollDelegate : VFGTopBarScrollDelegate = VFGTopBarScrollDelegate()
    
    private var topBarTransitionInProgress : Bool = false
    
    /**
     Defines appearance of status bar background.
     */
    public var statusBarState : VFGRootViewControllerStatusBarState {
        get {
            return self.statusBarManager.statusBarState
        }
        set {
            
            VFGLogger.log("Setting new VFGRootViewController statusBarState to " + String(newValue.hashValue))
            
            self.statusBarManager.statusBarState = newValue
        }
    }
    
    /**
     This property returns singleton instance of root view controller.
     */
    public static let shared : VFGRootViewController =  {
        
        VFGLogger.log("Returning VFGRootViewController singleton instance")
        
        return VFGRootViewController.create()
    }()
    
    static func create() -> VFGRootViewController {
        let storyboard = UIStoryboard(name:rootViewControllerStoryboardName, bundle: VFGCommonUIBundle.bundle())
        let rootViewController = storyboard.instantiateViewController(withIdentifier:rootViewControllerStoryboardId) as! VFGRootViewController
        _ = rootViewController.view
        return rootViewController
    }
    
    /**
     Set root view controller which view is presented as first top screen.
     */
    public func setRootViewController(_ viewController: UIViewController) {
        let fromTopBarScrollDelegate : VFGTopBarScrollDelegate = self.currentTopBarScrollDelegate
        
        self.clearTopBarDelegate()
        self.containerNavigationController.setViewControllers([viewController], animated: false)
        self.navigationControllerCounter = 1
        self.updateTopBar(viewController)
        self.topBarTransition(fromDelegate: fromTopBarScrollDelegate)
        
    }
    
    /**
     Push view controller on navigation stack
     */
    public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let fromTopBarScrollDelegate : VFGTopBarScrollDelegate = self.currentTopBarScrollDelegate
        self.clearTopBarDelegate()
        self.navigationControllerCounter = self.containerNavigationController.viewControllers.count + 1
        self.containerNavigationController.pushViewController(viewController, animated: animated)
        self.updateTopBar(viewController)
        self.topBarTransition(fromDelegate: fromTopBarScrollDelegate)
        
    }
    
    
    /**
     Pop view controller which is on top of navigation stack.
     */
    public func popToRootViewController(animated: Bool) {
        let fromTopBarScrollDelegate : VFGTopBarScrollDelegate = self.currentTopBarScrollDelegate
        self.clearTopBarDelegate()
        self.containerNavigationController.popToRootViewController(animated: animated)
        self.navigationControllerCounter = 1
        self.updateTopBar(self.containerNavigationController.topViewController)
        self.topBarTransition(fromDelegate: fromTopBarScrollDelegate)
    }
    
    /**
     Pop view controller which is on top of navigation stack.
     */
    public func popViewController(animated: Bool) {
        let fromTopBarScrollDelegate : VFGTopBarScrollDelegate = self.currentTopBarScrollDelegate
        self.clearTopBarDelegate()
        self.containerNavigationController.popViewController(animated: animated)
        self.navigationControllerCounter -= 1
        self.updateTopBar(self.containerNavigationController.topViewController)
        self.topBarTransition(fromDelegate: fromTopBarScrollDelegate)
    }
    /**
     Show view controllers on the top of root view controller
     */
    public func showOnRootController(_ viewControllers: [UIViewController], animated: Bool) {
        let fromTopBarScrollDelegate : VFGTopBarScrollDelegate = self.currentTopBarScrollDelegate
        self.clearTopBarDelegate()
        
        let rootViewController : UIViewController? = self.containerNavigationController.viewControllers.first
        var presentedControllers : [UIViewController] = []
        
        if let controller = rootViewController {
            presentedControllers.append(controller)
        }
        presentedControllers.append(contentsOf: viewControllers)
        self.navigationControllerCounter = presentedControllers.count
        self.containerNavigationController.setViewControllers(presentedControllers, animated: animated)
        
        self.updateTopBar(viewControllers.last)
        self.topBarTransition(fromDelegate: fromTopBarScrollDelegate)
    }
    
    public func fadeInOverlay(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.blackOverlayView.alpha = 1
        }
    }
    
    public func fadeOutOverlay(withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.blackOverlayView.alpha = 0
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.nudgeView.isHidden = true
        self.blackOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.blackOverlayView.alpha = 0
        self.setupMenuTap()
        self.setupBackTap()
        self.setupTopBarManager()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !self.topBarTransitionInProgress {
            self.currentTopBarScrollDelegate.refresh()
        }
        self.sideMenu.layoutMenu()
        self.view.bringSubview(toFront: sideMenu.view)
        
        
        if UIScreen.IS_5_8_INCHES(), #available(iOS 11, *) {
            UIApplication.shared.statusBarStyle = .lightContent
            statusBarHeightConstraint.constant = 0
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        self.currentTopBarScrollDelegate.refresh()
        
    }
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == VFGRootViewController.embedSegue {
            
            guard let destinationViewController : VFGNavigationController = segue.destination as? VFGNavigationController else {
                VFGLogger.log("Cannon unwrap segue.destination")
                return
            }
            
            self.containerNavigationController = destinationViewController
        }
    }
    
    private func setupMenuTap() {
        self.topBar.rightButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
    }
    
    private func setupBackTap() {
        self.topBar.leftButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    public var backTapClosure : (() -> Void)? = nil
    
    private func setupTopBarManager() {
        self.statusBarManager.statusBarBackgroundView = self.statusBarBackgroundView
    }
    
    @objc private func menuTapped() {
        
        self.currentTopBarScrollDelegate.refresh()
        VFGLogger.log("Menu tapped");
        hideNudgeViewTemp()

        self.sideMenu.showMenu(withAnimation: true)
        print("self.navigationControllerCounter: ")
        print(self.navigationControllerCounter)
        self.sideMenu.hideMenu()
        self.sideMenu.hideMenuBackground = { [weak self]  in
            guard let strongSelf = self else{
                return
            }
            if strongSelf.shouldNudgeView ?? false{
                strongSelf.showNudge()
            }
            strongSelf.currentTopBarScrollDelegate.refresh()
        }
    }
    
    @objc private func backTapped() {
        
       // check navigation controller counter to determine if still using same sidemenuitem
        if self.containerNavigationController.viewControllers.count <= 2 {
            VFGRootViewController.shared.sideMenu.clearLastSelectedMenuItem()
        }
        //
        VFGLogger.log("Back tapped")
        hideNudgeView()
        DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuarationTime) {
            if let backTapClosure : () -> Void = self.backTapClosure {
                VFGLogger.log("Calling backTapClousure")
                backTapClosure()
            } else {
                self.popViewController(animated: true)
            }
            VFGRootViewController.shared.sideMenu.changeCurrentViewController()
        }
        
    }
    
    private func clearTopBarDelegate() {
        self.topBar.opaqueBackgroundAlpha = 0
        self.currentTopBarScrollDelegate.topBar = nil
    }
    
    private func topBarTransition(fromDelegate: VFGTopBarScrollDelegate?) {
        let fromIsNoOffset : Bool = fromDelegate?.isNoOffset ?? true
        
        let shouldAnimateTansition = fromIsNoOffset != self.currentTopBarScrollDelegate.isNoOffset
        
        let hideTopBarBlock : (() -> Void) = { () -> Void in
            self.topBar.frame = CGRect(x: 0, y: -VFGTopBar.topBarHeight, width: UIScreen.main.bounds.width, height: VFGTopBar.topBarHeight)
            self.topBar.opaqueBackgroundAlpha = 0
        }
        
        let showTopBarBlock : (() -> Void) = { () -> Void in
            self.currentTopBarScrollDelegate.refresh()
            self.topBarTransitionInProgress = false
        }
        
        let hideTopBarCompletion : ((Bool) -> Void) = { (Bool) -> Void in
            self.animate(animations: showTopBarBlock, completion: nil)
        }
        
        self.topBarTransitionInProgress = true
        if shouldAnimateTansition {
            self.animate(animations: hideTopBarBlock, completion: hideTopBarCompletion)
        } else {
            showTopBarBlock()
        }
    }
    
    private func animate(animations: @escaping  () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: VFGRootViewController.animationDuration, delay: 0, options: .curveEaseIn, animations: animations, completion: completion)
    }
    
    private func setNewTopBarDelegate(_ viewController: UIViewController?) {
        if let controller : VFGRootViewControllerContent = viewController as? VFGRootViewControllerContent {
            VFGLogger.log("Setting new topBarDelegate")
            self.contentTopBarScrollDelegate = controller.rootViewControllerContentTopBarScrollDelegate
        } else {
            VFGLogger.log("New topBarDelegate is nil")
            self.contentTopBarScrollDelegate = nil
        }
        self.currentTopBarScrollDelegate.topBar = self.topBar
    }
    
    private func updateTopBar(_ viewController: UIViewController?) {
        self.setNewTopBarDelegate(viewController)
        self.updateStatusBar(viewController)
        self.updateTopBarBackButton()
        self.updateTopBarTitle(viewController)
        self.updateRightBarButton(viewController)
        self.updateBubble()
    }
    
    private func updateStatusBar(_ viewController: UIViewController?) {
        let statusBarState : VFGRootViewControllerStatusBarState = (viewController as? VFGRootViewControllerContent)?.rootViewControllerContentStatusBarState ?? .black
        self.statusBarManager.statusBarState = statusBarState
    }
    
    private func updateRightBarButton(_ viewController: UIViewController?) {
        if let rootContentViewController = viewController as? VFGRootViewControllerContent {
            self.topBar.rightButton.isHidden = rootContentViewController.topBarRightButtonHidden
        }
    }
    
    private func updateTopBarBackButton() {
        self.topBar.leftButton.isHidden = self.containerNavigationController.viewControllers.count <= 1
    }
    
    private func updateBubble() {
        
        switch floatingBubbleColor {
        case .white:
            floatingBubble?.setSecondLevel(false)
        case .red:
            floatingBubble?.setSecondLevel(true)
        }
        
        if let isFloatingBubbleInNotificationState = floatingBubble?.isFloatingBubbleInNotificationState() {
            floatingBubble?.setHasNewNotification(isFloatingBubbleInNotificationState)
            
        }
        
    }
    
    private func updateTopBarTitle(_ viewController: UIViewController?) {
        self.topBar.title = (viewController as? VFGRootViewControllerContent)?.rootViewControllerContentTopBarTitle ?? ""
    }
}

