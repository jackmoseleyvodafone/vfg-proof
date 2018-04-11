//
//  UIScrollView.swift
//  VFGCommonUI
//
//  Created by Emilio Alberto Ojeda Mendoza on 1/24/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import ObjectiveC

public extension UIScrollView {
    private enum AssociatedKeys {
        static var VFGPullToRefreshControl: UInt8 = 0
    }

    /// `VFGPullToRefreshControl` instance added when calling `add(pullToRefreshControl:action:)`.
    ///
    /// > This property is only available when importing the `VFGCommonUI` module.
    fileprivate(set) var pullToRefreshControl: VFGPullToRefreshControl? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.VFGPullToRefreshControl) as? VFGPullToRefreshControl
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.VFGPullToRefreshControl, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - Public API

public extension UIScrollView {
    /// When calling this method, the **pull to refresh** feature is enabled to every `UIScrollView`
    /// instance or subclass (such as `UITableView`).
    ///
    /// Because of this feature is enabled via **runtime**, please remove it once it is no used.
    /// It can be done by calling `removePullToRefresh()`.
    ///
    /// > **Important:** In order to provide the expected "look-and-feel" to the "pull-to-refresh" component, **Bounces on Scroll** and **Clip to Bounds** need to be set to `true`.
    ///
    /// - Parameters:
    ///   - pullToRefreshControl: `VFGPullToRefreshControl` instance.
    ///   - action: The action to be performed as part the refreshable feature.
    func add(pullToRefreshControl: VFGPullToRefreshControl, action: @escaping () -> Void) {
        pullToRefreshControl.scrollView = self
        pullToRefreshControl.action = action

        removePullToRefreshControl()

        addSubview(pullToRefreshControl.refreshableView)
        sendSubview(toBack: pullToRefreshControl.refreshableView)
        
        addSubview(pullToRefreshControl.offlineRibbonView)
        sendSubview(toBack: pullToRefreshControl.offlineRibbonView)
        
        pullToRefreshControl.refreshableView.autoPinEdge(.bottom, to: .top, of: pullToRefreshControl.offlineRibbonView)
        
        self.pullToRefreshControl = pullToRefreshControl
    }

    /// Removes the `VFGPullToRefreshControl` added by `add(pullToRefreshControl:action:)`.
    func removePullToRefreshControl() {
        pullToRefreshControl?.refreshableView.removeFromSuperview()
        pullToRefreshControl = .none
    }

    /// Starts refreshing the **pull to refresh** control (added by `add(pullToRefreshControl:action:)`).
    func startRefreshing() {
        pullToRefreshControl?.startRefreshing()
    }

    /// Stops refreshing the **pull to refresh** control (added by `add(pullToRefreshControl:action:)`).
    func stopRefreshing(failureMessage: String? = nil) {
        pullToRefreshControl?.stopRefreshing(failureMessage: failureMessage)
    }
}

// MARK: - Helpers (internal)

internal extension UIScrollView {
    var normalizedContentOffset: CGPoint {
        return CGPoint(
            x: contentOffset.x + effectiveContentInset.left,
            y: contentOffset.y + effectiveContentInset.top
        )
    }

    var effectiveContentInset: UIEdgeInsets {
        get {
            if #available(iOS 11, *) {
                return adjustedContentInset
            } else {
                return contentInset
            }
        }
        set {
            if #available(iOS 11.0, *), (contentInsetAdjustmentBehavior != .never) {
                contentInset = (newValue - safeAreaInsets)
            } else {
                contentInset = newValue
            }
        }
    }
}
