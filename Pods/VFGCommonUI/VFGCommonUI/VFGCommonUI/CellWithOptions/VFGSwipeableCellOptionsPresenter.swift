//
//  VFGSwipeableCellOptionsPresenter.swift
//  VFGCommon
//
//  Created by Michał Kłoczko on 09/11/16.
//  Copyright © 2016 Mich. All rights reserved.
//

import UIKit

class VFGSwipeableCellOptionsPresenter: NSObject {

    static let standardAnimationDuration : TimeInterval = 0.2

    private unowned var content : UIView
    private unowned var options : UIView

    var panOffset : CGFloat = 0
    var areOptionsShown : Bool = false

    var standardContentFrame : CGRect {
        get {
            return self.contentFrame(forOffset: 0)
        }
    }

    var standardOptionsFrame : CGRect {
        get {
            return self.optionsFrame(forOffset: 0)
        }
    }

    var movedContentFrame : CGRect {
        get {
            return self.contentFrame(forOffset: self.panOffset)
        }
    }

    var movedOptionsFrame : CGRect {
        get {
            return self.optionsFrame(forOffset: self.panOffset)
        }
    }

    init(content: UIView, options: UIView) {
        self.content = content
        self.options = options
    }

    func moveViewsBy(offset: CGFloat) {
        self.content.frame = self.contentFrame(forOffset: offset)
        self.options.frame = self.optionsFrame(forOffset: offset)
    }

    func showOptions(animating: Bool = false) {
        self.areOptionsShown = true
        let duration = animating ? self.animationDuration() : 0
        self.animate(duration: duration) {
            self.content.frame = self.movedContentFrame
            self.options.frame = self.movedOptionsFrame
        }
    }

    func hideOptions(animating: Bool = false) {
        self.areOptionsShown = false
        let duration = animating ? self.animationDuration() : 0
        self.animate(duration: duration) {
            self.content.frame = self.standardContentFrame
            self.options.frame = self.standardOptionsFrame
        }
    }

    private func animate(duration: TimeInterval, withAnimations animations: @escaping (() -> Void)) {
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: animations, completion: nil)
    }

    func layoutViews() {
        self.content.frame = self.areOptionsShown ? self.movedContentFrame : self.standardContentFrame
        self.options.frame = self.areOptionsShown ? self.movedOptionsFrame : self.standardOptionsFrame
    }

    private func animationDuration() -> TimeInterval {
        return VFGSwipeableCellOptionsPresenter.standardAnimationDuration;
    }

    private func optionsFrame(forOffset offset: CGFloat) -> CGRect {
        var frame = self.options.frame
        frame.origin.x = self.content.frame.width - offset

        return frame;
    }

    private func contentFrame(forOffset offset: CGFloat) -> CGRect {
        var frame = self.content.frame
        frame.origin.x = -offset

        return frame;
    }
}
