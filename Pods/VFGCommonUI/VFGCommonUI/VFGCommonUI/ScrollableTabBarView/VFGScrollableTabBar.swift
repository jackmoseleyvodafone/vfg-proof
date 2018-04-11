//
//  VFGScrollableTabBar.swift
//  VFGCommonUI
//
//  Created by Ahmed Naguib on 3/15/17.
//  Copyright © 2017 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

fileprivate let nibName: String = "VFGScrollableTabBar"
fileprivate let cellNibName: String = "VFGScrollableTabBarItemCell"
fileprivate let cellIdentifier: String = "ScrollableTabBarItemCell"
fileprivate let noSelectionIndex: Int = -1
fileprivate let itemLabelLineSpacing: CGFloat = 0.3
fileprivate let itemLabelLineHeight: CGFloat = 15.1
fileprivate let isRTLLanguage: Bool = Locale.characterDirection(forLanguage: Locale.preferredLanguages.first!) == NSLocale.LanguageDirection.rightToLeft

/**
 The delegate for scrollable tabBar callBack methods
 */
@objc public protocol VFGScrollableTabBarDelegate: NSObjectProtocol {
    
    func scrollableTabBar(_ scrollableTabBar: VFGScrollableTabBar, didSelectItemAt index: Int, didSwitchToViewController: Bool)
}

/**
 Custom view that contains a TabBar that can be scrolled
 */
open class VFGScrollableTabBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var nibView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /** The current selected item index */
    private(set) public var selectedIndex: Int = noSelectionIndex
    
    /** The initial selected item index, default = 0 */
    public var initialSelectedIndex: Int = 0
    
    /** The number of maximum items on screen without scrolling the tabBar, default = 4 */
    public var maxItemsCountWithoutScrolling: Int = 4
    
    /** Enable tabBar scrolling, default = true */
    public var isScrollingEnabled: Bool = true
    
    /** Show half of the next scrolling item , default = true */
    public var shouldShowHalfItemWhenScrolling: Bool = true
    
    /** The items of the tabBar */
    public lazy var tabBarItems: [VFGScrollableTabBarItem] = [VFGScrollableTabBarItem]()
    
    /** The image tint Color for the selected item */
    public var selectedItemTintColor: UIColor? = UIColor.VFGScrollableTabBarSelectedItemTintColor
    
    /** The image tint Color for the enabled items */
    public var enabledItemTintColor: UIColor? = UIColor.VFGScrollableTabBarEnabledItemTintColor
    
    /** The title font of the tabBar items  */
    public var itemTitleFont: UIFont? = UIFont.vodafoneRegularFont(16.0)
    
    /** The view controllers that embedded on the TabBar  */
    public lazy var tabBarViewControllers: [UIViewController?] = []
    
    /** The view which displays the view controllers for the tabBar  */
    public weak var viewControllersContainerView: UIView?
    
    /** The delegate for VFGScrollableTabBar */
    public weak var delegate: VFGScrollableTabBarDelegate?
    
    /** The parent view controller which contains the tabBar */
    public weak var parentViewController: UIViewController?
    
    
    // MARK: Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScrollableTabBar()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollableTabBar()
    }
    
    
    // MARK: Setup
    
    private func setupScrollableTabBar() {
        
        setupNib()
        setupCollectionView()
    }
    
    private func setupNib() {
        
        nibView = VFGCommonUIBundle.bundle()?.loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView!
        nibView.frame = bounds
        nibView.backgroundColor = backgroundColor
        addSubview(nibView)
    }
    
    private func setupCollectionView() {
        
        let cellNib = UINib(nibName: cellNibName, bundle: VFGCommonUIBundle.bundle())
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func setupLocalizedViewForView(view: UIView) {
        
        if #available(iOS 9, *) { } // iOS 9 or above, Do Nothing
        else { // iOS 8 or below
            
            VFGLogger.log("Calling setLocalizedViewForView code for iOS8")
            
            view.transform = .identity
            if isRTLLanguage {
                view.transform = view.transform.scaledBy(x: -1, y: 1)
            }
        }
    }
    
    private func initialSetup() {
        
        guard selectedIndex == noSelectionIndex else { return }
        
        selectedIndex = initialSelectedIndex
        viewControllersContainerView?.subviews.forEach({$0.removeFromSuperview()})
        
        let shouldShowViewController: Bool = self.shouldShowViewController(atIndex: initialSelectedIndex)
        if shouldShowViewController {
            showViewControllerAtIndex(index: initialSelectedIndex)
        }
        delegate?.scrollableTabBar(self, didSelectItemAt: initialSelectedIndex, didSwitchToViewController: shouldShowViewController)
        setupLocalizedViewForView(view: collectionView)
        collectionView.isScrollEnabled = isScrollingEnabled
        
        if initialSelectedIndex < tabBarItems.count {
            tabBarItems[initialSelectedIndex].status = .selected
        }
    }
    
    public func reloadData() {
        
        collectionView.reloadData()
    }
    
    
    
    //public function will be called to manager tabbar items notification status, you will pass the item index and the function will check if that item is being dispalyed in notification mode or not, if not then it will automatically switches it to that mode, otherswise it will switch it on.
    // finally reload the collection view.
    
    public func triggerOrUnTriggerNotificationIconAtTabBarItems(index: Int,triggerOn: Bool){
        guard let item : VFGScrollableTabBarItem = tabBarItems[index] else {
            VFGLogger.log("Item Index is out of items array bounds ")
            return
        }
        item.switchToNewNotificationMode(hasNewNotification: triggerOn)
        reloadData()
    }
    
    // MARK: ViewControllers
    
    private func removeViewControllerAtIndex(index: Int) {
        
        guard  index < tabBarItems.count else { return }
        
        
        if let viewController = tabBarItems[index].viewController {
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
    }
    
    private func shouldShowViewController(atIndex: Int) -> Bool {
        let viewController = tabBarItems[atIndex].viewController == nil ? tabBarViewControllers[atIndex] : tabBarItems[atIndex].viewController
        return (viewController != nil)
    }
    private func showViewControllerAtIndex(index: Int) {
        guard index < tabBarViewControllers.count  || index < tabBarItems.count else { return }
        let viewController = tabBarItems[index].viewController == nil ? tabBarViewControllers[index] : tabBarItems[index].viewController
        
        if (viewController != nil){
            showViewControllerFromTabbarItem(tabBarItemViewController: viewController!)
        }
    }
    func showViewControllerFromTabbarItem(tabBarItemViewController: UIViewController){
        parentViewController?.addChildViewController(tabBarItemViewController)
        if let viewControllersContainerViewBounds = viewControllersContainerView?.bounds {
            tabBarItemViewController.view.frame = viewControllersContainerViewBounds
        }
        viewControllersContainerView?.addSubview(tabBarItemViewController.view)
        tabBarItemViewController.didMove(toParentViewController: parentViewController)
    }
    
    // MARK: UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        initialSetup()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! VFGScrollableTabBarItemCell
        setupLocalizedViewForView(view: cell)
        let item = tabBarItems[indexPath.row]
        cell.alpha = (item.status == .disabled) ? disabledViewAlpha : enabledViewAlpha
        cell.iconImageView.image = item.image
        if !item.ItemIconIsNewNotification() {
            cell.iconImageView.image = cell.iconImageView.image?.withRenderingMode(.alwaysTemplate)
        }
        cell.iconImageView.tintColor = (item.status == .selected) ? selectedItemTintColor : enabledItemTintColor
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = itemLabelLineSpacing
        paragraphStyle.maximumLineHeight = itemLabelLineHeight
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        guard let itemTitleFont : UIFont = itemTitleFont else {
            VFGLogger.log("Cannot unwrap itemTitleFont. Skipping cell text customization")
            return cell
        }
        let attributes: [String : Any] = [NSParagraphStyleAttributeName: paragraphStyle,
                                          NSFontAttributeName: itemTitleFont]
        cell.titleLabel.attributedText = NSAttributedString(string: item.title ?? "",
                                                            attributes: attributes)
        guard let itemTitle : String = item.title else {
            VFGLogger.log("Cannot unwrap itemTitle")
            return cell
        }
        cell.titleLabel.numberOfLines = (itemTitle.contains("\n")) ? 2 : 1
        return cell
    }
    
    
    // MARK: UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if  tabBarItems[indexPath.row].status == .disabled { return }
        
        let shouldShowViewController: Bool = self.shouldShowViewController(atIndex: indexPath.row)
        if selectedIndex == indexPath.row , let nav = self.tabBarViewControllers[indexPath.row] as? UINavigationController{
            nav.popToRootViewController(animated: true)
        }else {
            selectedIndex = indexPath.row
            
            if shouldShowViewController {
                showViewControllerAtIndex(index: selectedIndex)
                tabBarItems.filter({ $0.status != .disabled }).forEach { $0.status = .enabled }
                tabBarItems[indexPath.row].status = .selected
                collectionView.reloadData()
                
            }
        }
        delegate?.scrollableTabBar(self, didSelectItemAt: indexPath.row, didSwitchToViewController: shouldShowViewController)
        if isScrollingEnabled {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    
    // MARK: UICollectionViewDelegateLayoutFlow
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = self.bounds.height
        var cellWidth = self.bounds.width / CGFloat(tabBarItems.count)
        if tabBarItems.count > maxItemsCountWithoutScrolling {
            cellWidth = self.bounds.width / CGFloat(maxItemsCountWithoutScrolling)
            if shouldShowHalfItemWhenScrolling {
                cellWidth = (self.bounds.width - (cellWidth/2)) / CGFloat(maxItemsCountWithoutScrolling)
            }
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

