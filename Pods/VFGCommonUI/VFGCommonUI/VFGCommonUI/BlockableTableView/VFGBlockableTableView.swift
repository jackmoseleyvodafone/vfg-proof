//
//  VFGBlockableTableView.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 09/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

/**
 Your table view class should subclass VFGBlockableTableView. If the screen is created using Storyboards your table view UI custom class should be set to your own. At this point you can start using VFGSwipeableTableViewCells in your table view.
 */
open class VFGBlockableTableView: UITableView {

    var gestureHandler : VFGLeftPanGestureHandler!
    var panRecognizer : UIPanGestureRecognizer!
    weak var swipedCell : VFGSwipeableTableViewCell?

    /**
     Informs if any table view cell displays options.
     */
    public var isCellOptionsVisible : Bool {
        get {
            return self.cellsWithVisibleOption().count != 0
        }
    }

    lazy var blockingTouchHandler : VFGBlockingGestureRecognizerHandler = {
        return VFGBlockingGestureRecognizerHandler(view: self)
    }()

    /**
     Hide options of cells.

     - Parameter withAnimation: animate hiding of options, defaults to false.

     */
    public func hideCellOptions(withAnimation animation: Bool = false) {
        for cell in self.cellsWithVisibleOption() {
            cell.presentOptions(present: false, withAnimation: animation)
        }
        self.blockingTouchHandler.removeBlockingGesture()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupGestureHandler()
    }

    override public init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.setupGestureHandler()
    }

    private func cellsWithVisibleOption() -> [VFGSwipeableTableViewCell] {
        guard let result : [VFGSwipeableTableViewCell] = self.visibleCells.filter({ (cell) -> Bool in
            
            guard let cell : VFGSwipeableTableViewCell = cell as? VFGSwipeableTableViewCell else {
                return false
            }
            
            return cell.areOptionsPresented
        }) as? [VFGSwipeableTableViewCell] else {
            VFGLogger.log("Cannot cast data to [VFGSwipeableTableViewCell]")
            return [VFGSwipeableTableViewCell]()
        }
        
        return result
    }

    private func swipeableCells() -> [VFGSwipeableTableViewCell] {
        guard let result : [VFGSwipeableTableViewCell] = self.visibleCells.filter({ (cell) -> Bool in
            return cell is VFGSwipeableTableViewCell
        }) as? [VFGSwipeableTableViewCell] else {
            VFGLogger.log("Cannot cast data to [VFGSwipeableTableViewCell]")
            return [VFGSwipeableTableViewCell]()
        }
        
        return result
    }

    private func setupGestureHandler() {
        self.gestureHandler = VFGLeftPanGestureHandler()
        
        guard let gestureRecognizer : VFGLeftPanGestureHandler = self.gestureHandler else {
            VFGLogger.log("Cannot unwrap self.gestureHandler")
            return
        }
        
        self.panRecognizer = gestureRecognizer.makeGestureRecognizer()
        self.addGestureRecognizer(panRecognizer)

        self.gestureHandler.maxOffsetForPointCallback = { [unowned self] (startPoint) -> CGFloat in
            if let cell = self.cellContaining(point: startPoint), let optionsPresenter = cell.optionsPresenter {
                return optionsPresenter.panOffset
            }
            return 0;
        }

        self.gestureHandler.gestureStartedCallback = { [unowned self] (startPoint) -> Void in
            self.swipedCell = self.cellContaining(point: startPoint)
        }

        self.gestureHandler.offsetChangedCallback = { [unowned self] (offset) -> Void in
            self.swipedCell?.optionsPresenter?.moveViewsBy(offset: offset)
        }

        self.gestureHandler.gestureFinishedCallback = { [unowned self] (shouldShowOptions) -> Void in
            if (shouldShowOptions) {
                self.swipedCell?.showOptionsAnimating()
                self.blockingTouchHandler.blockViewWithGestureRecognizer(clickableView: self.swipedCell?.optionsView)
            } else {
                self.swipedCell?.hideOptionsAnimating()
            }
            self.swipedCell = nil
        }
    }

    private func cellContaining(point : CGPoint) -> VFGSwipeableTableViewCell? {
        for cell : VFGSwipeableTableViewCell in self.swipeableCells() {
            let point = self.convert(point, to: cell)
            if (cell.bounds.contains(point)) {
                return cell
            }
        }
        
        VFGLogger.log("VFGBlockableTableView cellContating(point) returns nil")
        
        return nil;
    }
    
}
