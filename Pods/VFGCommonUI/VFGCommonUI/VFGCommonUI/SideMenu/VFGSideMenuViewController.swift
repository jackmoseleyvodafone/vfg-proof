//
//  SideMenuViewController.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 09/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import RBBAnimation
import VFGCommonUtils

/**
 View controller containing side menu.
 */
public class VFGSideMenuViewController: UIViewController {
    
    static let storyboardName = "VFGSideMenu"
    static let closeButtonImage : String = "close"
    
    var animationInProgress : Bool = false
    
    public var itemsModel : VFGSideMenuAbstractModel?
    @IBOutlet public weak var tableView: UITableView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var menuBackgroundView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    
    var hideMenuBackground : (()->())?
    /**
     Callback called when item at given row in menu was clicked.
     */
    public var itemAtRowClickedCallback : ((_ row: Int, _ item: VFGSideMenuItem) -> Void)? {
        get {
            return self.tableModel.itemAtRowClickedCallback
        }
        set {
            self.tableModel.itemAtRowClickedCallback = newValue
        }
    }
    
    public func clearLastSelectedMenuItem()
    {
        let selectedItem = self.tableModel.lastSelectedItem
        selectedItem?.isItemSelected = false
    }
    
    public func changeCurrentViewController(){
        let size = VFGRootViewController.shared.containerNavigationController.viewControllers.count - 1
        self.tableModel.currentViewController = VFGRootViewController.shared.containerNavigationController.viewControllers[size]
    }
    
    static var sideMenuFactory : VFGSideMenuFactory = VFGSideMenuFactory()
    private lazy var frameGenerator : VFGSideMenuFrameGenerator = VFGSideMenuViewController.sideMenuFactory.frameGenerator()
    private var positionAnimator : VFGSideMenuPositionAbstractAnimator {
        var animator : VFGSideMenuPositionAbstractAnimator = VFGSideMenuViewController.sideMenuFactory.positionAnimator()
        animator.sideMenu = self.view
        return animator
    }
    private lazy var tableModel : VFGSideMenuTableModel = VFGSideMenuViewController.sideMenuFactory.tableModel()
    
    /**
     Loads and initializes side menu view controller. View controller is added to desired view controller and as a subview of view controller's view
     */
    static public func sideMenuViewController(inViewController controller: UIViewController) -> VFGSideMenuViewController {
        return sideMenuViewController(inViewController: controller, containerView: controller.view)
    }
    
    /**
     Loads and initializes side menu view controller. View controller is added to desired view controller and view is added to containerView.
     */
    static public func sideMenuViewController(inViewController controller: UIViewController, containerView: UIView) -> VFGSideMenuViewController {
        guard let sideMenu : VFGSideMenuViewController =  UIStoryboard(name:storyboardName, bundle:VFGCommonUIBundle.bundle()).instantiateViewController(withIdentifier: String(describing: self)) as? VFGSideMenuViewController else {
            VFGLogger.log("Cannot cast data to VFGSideMenuViewController. Returning empty VFGSideMenuViewController")
            return VFGSideMenuViewController()
        }
        
        controller.addChildViewController(sideMenu)
        containerView.addSubview(sideMenu.view)
        sideMenu.frameGenerator.setParent(containerView)
        sideMenu.frameGenerator.setSideMenu(sideMenu.view)
        sideMenu.didMove(toParentViewController: controller)
        sideMenu.layoutMenu()
        
        return sideMenu
    }
    
    /**
     Show side menu with or without animation.
     
     - Parameter withAnimation: True if showing of side menu should be animated
     
     */
    public func showMenu(withAnimation : Bool = false) {
        if (!self.animationInProgress) {
            self.animationInProgress = true
            UIApplication.shared.keyWindow?.endEditing(true)
            let fromPosition : CGPoint = self.frameGenerator.currentMenuPosition()
            self.frameGenerator.state = .shown
            if withAnimation {
                self.animateToCurrentPosition(fromPosition: fromPosition)
                self.rootViewController?.fadeInOverlay(withDuration: VFGSideMenuPositionAnimator.duration)
            } else {
                self.animationInProgress = false
            }
            self.layoutMenu()
            //sideMenu selection
            let size = VFGRootViewController.shared.containerNavigationController.viewControllers.count - 1
            if size >= 0 && self.tableModel.currentViewController != VFGRootViewController.shared.containerNavigationController.viewControllers[size] {
                self.tableModel.lastSelectedItem?.isItemSelected = false
                self.tableModel.nextItem?.isItemSelected = true
                self.tableModel.lastSelectedItem =  self.tableModel.nextItem
            }
            self.tableModel.tableView?.reloadData()
        }
    }
    
    /**
     Hide side menu with or without animation.
     
     - Parameter withAnimation: True if hidding of side menu should be animated
     
     */
    public func hideMenu(withAnimation : Bool = false) {
        if (!self.animationInProgress) {
            self.animationInProgress = true
            let fromPosition : CGPoint = self.frameGenerator.currentMenuPosition()
            self.frameGenerator.state = .hidden
            if withAnimation {
                self.animateToCurrentPosition(fromPosition: fromPosition)
                self.rootViewController?.fadeOutOverlay(withDuration: VFGSideMenuPositionAnimator.duration)
            } else {
                self.animationInProgress = false
                self.rootViewController?.fadeOutOverlay(withDuration: 0)
            }
            self.layoutMenu()
            //            self.tableModel.collapseAll()
        }
    }
    
    /**
     Layout side menu in its parent view. Menu can be shown or hidden.
     */
    public func layoutMenu() {
        self.view.frame = frameGenerator.currentMenuFrame()
    }
    
    /**
     Sets menu items which are displayed in menu
     
     - Parameter items: Items displayed in menu
     
     */
    public func setMenuItems(_ items : [VFGSideMenuItem]) {
        itemsModel = VFGSideMenuModel(items: items)
        self.tableModel.model = itemsModel
    }
    
    /**
     Set text on badge on given item
     
     - Parameter text: Text displayed on badge
     - Parameter item: Menu item for which text is displayed
     
     */
    public func setBadgeText(_ text : String?, forMenuItem item: VFGSideMenuItem) {
        let oldText : String? = self.tableModel.model?.badgeTextForItem(item)
        
        if (oldText == text) {
            
            VFGLogger.log("Old text is the same as new text. Skipping badge update");
            
            return
        }
        
        self.tableModel.model?.setBadgeText(text, forItem: item)
        
        if let row : Int = self.tableModel.model?.row(forItem: item) {
            self.tableModel.updateCell(atRow: row)
        }
    }
    
    func animateToCurrentPosition(fromPosition: CGPoint) {
        let positionAnimator : VFGSideMenuPositionAbstractAnimator = self.positionAnimator
        let toPosition : CGPoint = self.frameGenerator.currentMenuPosition()
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.animationInProgress = false
        }
        positionAnimator.animatePositionChange(fromPosition: fromPosition, toPosition: toPosition)
        CATransaction.commit()
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.closeButton.imageView?.tintColor = UIColor.white
        self.closeButton.setImage(UIImage(fromCommonUINamed: VFGSideMenuViewController.closeButtonImage)?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.menuBackgroundView.backgroundColor = UIColor.VFGMenuBackground
        self.tableView.backgroundColor = UIColor.clear
        self.tableModel.tableView = self.tableView
        setupGradientView()
    }
    
    func setupGradientView() {
        let gradient = CAGradientLayer()
        gradient.frame = self.gradientView.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 1.0]
        self.gradientView.layer.mask = gradient
        self.gradientView.backgroundColor = .black
    }
    
    @IBAction func closeMenuClicked(_ sender: Any) {
        self.hideMenu(withAnimation: true)
        self.hideMenuBackground?()
    }
    
    @IBAction func menuBackgroundClicked(_ sender: Any) {
        self.hideMenu(withAnimation: true)
        self.hideMenuBackground?()
    }
    
}
