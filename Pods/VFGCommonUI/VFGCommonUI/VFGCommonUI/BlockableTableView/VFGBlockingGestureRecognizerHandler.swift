//
//  VFGTouchGestureRecognizerHandler.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 09/11/16.
//  Copyright © 2016 Mich. All rights reserved.
//

import UIKit

class VFGBlockingGestureRecognizerHandler: NSObject, UIGestureRecognizerDelegate {

    unowned var view : VFGBlockableTableView
    weak var clickableView : UIView?
    var gestureRecognizer : VFGBlockingGestureRecognizer?

    init(view: VFGBlockableTableView) {
        self.view = view;
    }

    func blockViewWithGestureRecognizer(clickableView: UIView?) {
        self.clickableView = clickableView
        self.view.isScrollEnabled = false
        if self.gestureRecognizer == nil  {
            self.gestureRecognizer = self.blockingGestureRecognizer()
        }
        self.view.addGestureRecognizer(self.gestureRecognizer!)

    }

    private func blockingGestureRecognizer() -> VFGBlockingGestureRecognizer {
        let recognizer = VFGBlockingGestureRecognizer(target: self, action: #selector(rocognizerTouched))
        recognizer.delegate = self
        return recognizer
    }

    func rocognizerTouched(recognizer: UIGestureRecognizer) {
        self.view.hideCellOptions(withAnimation: true)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = clickableView {
            let point = touch.location(in: view)
            return view.bounds.contains(point) == false
        }
        return true
    }

    func removeBlockingGesture() {
        if let recognizer : VFGBlockingGestureRecognizer = self.gestureRecognizer {
            self.clickableView = nil
            recognizer.view?.removeGestureRecognizer(recognizer)
            self.view.isScrollEnabled = true
        }
    }
}
