//
//  VFGSideMenuTableController.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 14/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

class VFGSideMenuTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    static let cellIdentifier : String = "SideMenuCell"
    static let rowHeightProportion : CGFloat = 52.0/740.0
    static let expandButtonWidth: CGFloat = isIPad() ? 16.0 : 22.0
    static let rowHeight : CGFloat = ceil(max(VFGCommonUISizes.minClickableAreaSize, rowHeightProportion * UIScreen.main.bounds.size.height))
    static let headerView : UIView = UIView()
    
    var tableView : UITableView? {
        didSet {
            tableView?.rowHeight = VFGSideMenuTableModel.rowHeight
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    var model : VFGSideMenuAbstractModel? {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    var itemAtRowClickedCallback : ((_ row: Int, _ item: VFGSideMenuItem) -> Void)?
    
    func collapseAll() {
        self.model?.collapseAll()
        self.tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return VFGSideMenuTableModel.headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let item : VFGSideMenuItem = self.model?.item(atRow: indexPath.row) else {
            VFGLogger.log("Cannot unwrap item content")
            return 0.0
        }
        
        if item.visible == false {
            return 0.0
        } else {
            return VFGSideMenuTableModel.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row : Int = indexPath.row
        

        guard let cell : VFGSideMenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: VFGSideMenuTableModel.cellIdentifier) as? VFGSideMenuTableViewCell else {
            VFGLogger.log("Cannot cast data to VFGSideMenuTableViewCell")
            return UITableViewCell()
        }

        guard let item : VFGSideMenuItem = self.model?.item(atRow: row) else {
            VFGLogger.log("Cannot unwrap side menu item data")
            return cell
        }
        if item.isItemSelected {
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            cell.selecedCellWhiteView.isHidden = false
        }
        else {
            cell.backgroundColor = .clear
            cell.selecedCellWhiteView.isHidden = true
        }
        cell.isHidden = !item.visible
        self.updateCell(cell, withItem: item, atRow: row)
        
        return cell
    }
    
    internal var lastSelectedItem : VFGSideMenuItem?
    internal var currentViewController : UIViewController?
    internal var nextItem : VFGSideMenuItem?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row : Int = indexPath.row
        print(row)
       
        guard let model : VFGSideMenuAbstractModel = self.model else {
            VFGLogger.log("Cannot unwrap model data")
            return
        }
        
        if model.isExpandable(atRow: row) {
            self.expandCollapse(atRow: row)
            guard let cell : VFGSideMenuTableViewCell = tableView.cellForRow(at: indexPath) as? VFGSideMenuTableViewCell else {
                VFGLogger.log("Cannot cast data to VFGSideMenuTableViewCell")
                return
            }
            cell.setExpanded(expanded: model.isExpanded(atRow: row))
        } else if let callback : ((_ row: Int, _ item: VFGSideMenuItem) -> Void) = self.itemAtRowClickedCallback {
            if let item : VFGSideMenuItem = model.item(atRow: indexPath.row)
            {
                var size = VFGRootViewController.shared.containerNavigationController.viewControllers.count - 1
                if size < 0 {
                    callback(row, item)
                    lastSelectedItem?.isItemSelected = false
                    item.isItemSelected = true
                    lastSelectedItem = item
                    return
                }
                currentViewController = VFGRootViewController.shared.containerNavigationController.viewControllers[size]
                callback(row, item)
                size = VFGRootViewController.shared.containerNavigationController.viewControllers.count - 1
                nextItem = item
                let nextViewController = VFGRootViewController.shared.containerNavigationController.viewControllers[size]
                if nextViewController == VFGRootViewController.shared.containerNavigationController.viewControllers[0]
                {
                    lastSelectedItem?.isItemSelected = false
                    item.isItemSelected = false
                    lastSelectedItem =  item
                }
                else if currentViewController != nextViewController {
                    lastSelectedItem?.isItemSelected = false
                    item.isItemSelected = true
                    lastSelectedItem = item
                }
            }
        }
    }

    
    

    
    func updateCell(atRow row: Int) {
        guard let cell : VFGSideMenuTableViewCell = self.tableView?.cellForRow(at: IndexPath(row: row, section: 0)) as? VFGSideMenuTableViewCell else {
            VFGLogger.log("Skipping updateCell for row " + String(row))
            return
        }
        
        guard let item : VFGSideMenuItem = self.model?.item(atRow: row) else {
            VFGLogger.log("Skipping updateCell for row " + String(row))
            return
        }
        
        self.updateCell(cell, withItem: item, atRow: row)
    }
    
    private func updateCell(_ cell: VFGSideMenuTableViewCell, withItem item: VFGSideMenuItem, atRow row: Int) {
        
        guard let model : VFGSideMenuAbstractModel = self.model else {
            VFGLogger.log("Cannot unwrap model data")
            return
        }
        
        cell.titleLabel.textColor = self.textColor(atRow: row)
        cell.rightImage.tintColor = self.textColor(atRow: row)
        cell.expandButton?.isHidden = !item.isExpandable
        cell.setExpanded(expanded: model.isExpanded(atRow: row))
        if cell.expandButton.isHidden {
            cell.expandButtonWidthConstraint.constant = 0
        } else {
            cell.expandButtonWidthConstraint.constant = VFGSideMenuTableModel.expandButtonWidth
        }
        
        cell.titleLabel.text = item.title
        cell.leftImage.image = item.image
        cell.rightImage.image = item.rightImage
        cell.separator.isHidden = !item.separator
        
        cell.badge.text = model.badgeTextForItem(item)
        cell.badge.isHidden = (cell.badge.text == nil || cell.badge.text == "")
    }
    
    private func expandCollapse(atRow row: Int) {
        
        let showAndHideSeparator = {[weak self] in
            guard let strongSelf = self else {
                VFGLogger.log("Cannot unwrap self")
                return
            }
            
            guard let indexToFirstCell : IndexPath = strongSelf.indexPaths(fromRow: row, count: 1).first else {
                VFGLogger.log("Cannot unwrap data for indexToFirstCell")
                return
            }
            
            guard let cell : VFGSideMenuTableViewCell = strongSelf.tableView?.cellForRow(at: indexToFirstCell) as? VFGSideMenuTableViewCell else {
                VFGLogger.log("Cannot cast data to VFGSideMenuTableViewCell")
                return
            }
            cell.separator.isHidden = !(strongSelf.model?.item(atRow: row)?.separator ?? false)
            
        }
        
        guard let model : VFGSideMenuAbstractModel = self.model else {
            VFGLogger.log("Cannot unwrap model data")
            return
        }
        
        if (model.isExpanded(atRow: row)) {
            let count : Int = model.collapseItem(atRow: row, hasSeparator: model.item(atRow: row)?.separator)
            CATransaction.begin()
            tableView?.beginUpdates()
            
            self.tableView?.deleteRows(at: self.indexPaths(fromRow: row+1, count: count), with: .bottom)
            
            CATransaction.setCompletionBlock {
                showAndHideSeparator()
            }
            tableView?.endUpdates()
            CATransaction.commit()
            
            
        } else {
            let count : Int = model.expandItem(atRow: row, hasSeparator: model.item(atRow: row)?.separator)
            self.tableView?.insertRows(at: self.indexPaths(fromRow: row+1, count: count), with: .top)
            showAndHideSeparator()
        }
        
        
    }
    
    private func textColor(atRow row: Int) -> UIColor {
        if (self.model!.is1stLevelItem(atRow: row)) {
            return UIColor.VFGTopBarTitleColor
        }
        
        return UIColor.VFGInfrastructureColor2
    }
    
    private func indexPaths(fromRow row: Int, count: Int) -> [IndexPath] {
        var indexes : [IndexPath] = []
        
        for i in 0..<count {
            indexes.append(IndexPath(row: row + i, section: 0))
        }
        
        return indexes
    }
    
}


