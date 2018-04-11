//
//  VFGSideMenuAbstractLayoutDelegate.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 09/12/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit
import VFGCommonUtils

class VFGSideMenuFrameGenerator : NSObject {

    weak var parentView : UIView?
    weak var sideMenuView : UIView!

    enum State {
        case hidden
        case shown
    }

    var state : State = .hidden
    static private let iPhoneXoffset: CGFloat = 24.0
    
    func setParent(_ view : UIView?) {
        parentView = view
    }

    func setSideMenu(_ view : UIView) {
        sideMenuView = view
    }

    func currentMenuFrame() -> CGRect {
        return self.menuFrame(forState: self.state)
    }

    func currentMenuPosition() -> CGPoint {
        return self.menuPosition(forState: self.state)
    }

    func menuFrame(forState state: State) -> CGRect {
        switch self.state {
        case .hidden:
            return self.hiddenMenuFrame()
        case .shown:
            return self.shownMenuFrame()
        }
    }

    func menuPosition(forState state: State) -> CGPoint {
        return self.menuFrame(forState: state).center
    }

    /**
     Method returns frame for side menu presented on screen.
     */
    private func shownMenuFrame() -> CGRect {
        return self.parentBounds()
    }

    private func hiddenMenuFrame() -> CGRect {
        var frame : CGRect = self.shownMenuFrame()
        frame.origin.x = self.parentBounds().width
        return frame
    }

    private func parentBounds() -> CGRect {
        guard let parentBounds = self.parentView?.bounds else { return CGRect.zero }
        
        if UIScreen.IS_5_8_INCHES() {
            return CGRect(x: 0, y: VFGSideMenuFrameGenerator.iPhoneXoffset, width: parentBounds.size.width, height: parentBounds.size.height - VFGSideMenuFrameGenerator.iPhoneXoffset)
        }
        else {
            return parentBounds
        }
    }
}
