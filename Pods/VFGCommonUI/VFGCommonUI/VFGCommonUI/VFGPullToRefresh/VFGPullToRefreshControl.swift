//
//  VFGPullToRefreshControl.swift
//  VFGCommonUI
//
//  Created by Emilio Alberto Ojeda Mendoza on 1/24/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import Foundation
import VFGCommonUtils

public typealias VFGPullToRefreshAction = () -> Void

internal protocol VFGPullToRefreshAnimatable {
    func animate(state: VFGPullToRefreshControl.State)
}

open class VFGPullToRefreshControl: NSObject {
    /// Namespaces all the notifications related to **pull to refresh** control.
    public enum Notification {
        /// Notification sent once the **pull to refresh** control ends refreshing.
        public static let didEndRefreshing: NSNotification.Name = NSNotification.Name(rawValue: "com.vodafone.VFGCommonUI.VFGPullToRefreshControl.Notification.didEndRefreshing")
    }

    internal let reachability: Reachability = Reachability()!

    /// **State pattern** which represents the different states are part of the **pull to refresh** component.
    ///
    /// - initial: Represents the `no event` state, when scrollable view offset is `0`.
    /// - dragging: Dragging event representation of the scrollable view (any offset lower than `0`).
    /// - offline: Representation of the `offline` state (when the user stopped dragging and has not a network connection).
    /// - loading: Representation of the `loading` state (when the user stopped dragging and has a network connection).
    /// - finished: Representation of the `finished` state.
    /// - failedWithMessage: Representation of the `failedWithMessage` state.
    internal enum State: Equatable {
        case initial
        case dragging(progress: CGFloat)
        case offline
        case loading
        case finished
        case failedWithErrorMessage(message : String)
        
        public static func ==(left: State, right: State) -> Bool {
            switch (left, right) {
            case (.initial, .initial), (.dragging, .dragging), (.loading, .loading), (.finished, .finished), (.failedWithErrorMessage, .failedWithErrorMessage):
                return true
            default:
                return false
            }
        }
    }

    fileprivate enum Constants {
        enum Animation {
            enum LoadingState {
                static let duration: TimeInterval = 0.3
            }
            enum ShakeAnimation {
                static let duration: Double = 0.05
            }
            enum FinishedState {
                static let duration: TimeInterval = 0.3
                static let delay: TimeInterval = 0
                static let animationOptions: UIViewAnimationOptions = [.curveEaseInOut]
            }
        }
        enum RefreshableView {
            static let height: CGFloat = 60
            
            enum Animation {
                enum SuccessTick {
                    static let duration: Double = 0.69
                }
            }
        }
        enum OfflineRibbonView {
            static let height: CGFloat = 51
            static let heightZero:CGFloat = 0.0
        }
    }
    
    let refreshableView: VFGPullToRefreshAnimatableView
    let offlineRibbonView: VFGOfflineRibbonView
    
    fileprivate var hasConnection:Bool = true

    var action: (VFGPullToRefreshAction)?
    
    weak var scrollView: UIScrollView? {
        willSet {
            removeScrollViewObserving()
        }
        didSet {
            if let scrollView = scrollView {
                scrollViewDefaultInsets = scrollView.contentInset
                addScrollViewObserving()
            }
        }
    }
    
    fileprivate var isObserving = false

    // MARK: - Timeframe Control (and Offline Ribbon message configuration)

    /// Used to configure the *last update* info displayed by the *off line ribbon*.
    public lazy var timeframeControl: VFGTimeframeControl = {
        VFGTimeframeControl(timeframes: [])
    }()

    /// Used to properly display the **last update** message in the *offline ribbon*.
    /// Probably it should be set from any *persistence system* (such as `UserDefaults`, `CoreDarta`, etc.) implemented by the local markets.
    open var lastUpdate: Date?

    /// The message to display when data *has never been updated*. The default value is **Never**.
    public var nerverUpdatedMessage: String = "Never"

    /// Builds the message to be displayed by the offline ribbon.
    /// The message is built based on `lastUpdate`, `nerverUpdatedMessage` and `timeframeControl` values.
    ///
    /// If there is no value available for `lastUpdate`, it will return the value set for `nerverUpdatedMessage`,
    /// otherwise, it will return the string resolved by the `timeframeControl` configuration.
    open var lastUpdateMessage: String {
        guard let lastUpdate = lastUpdate else {
            return nerverUpdatedMessage
        }
        return timeframeControl.string(forDate: lastUpdate)
    }
    
    // MARK: - ScrollView
    
    fileprivate var scrollViewDefaultInsets: UIEdgeInsets = .zero
    fileprivate var previousScrollViewOffset: CGPoint = .zero
    
    // MARK: - State
    
    internal fileprivate(set) var state: State = .initial {
        
        didSet {
            animate(state: state)
            switch state {
            case .offline:
                self.offlineRibbonView.shake()
            case .loading:
                if (oldValue != .loading) {
                    animateLoadingState()
                }
            case .finished:
                NotificationCenter.default.post(name: Notification.didEndRefreshing, object: self)
            default:
                break
            }
        }
    }
    
    // MARK: - Life Cycle
    
    public override init() {
        let refreshableView = VFGPullToRefreshAnimatableView()
        refreshableView.translatesAutoresizingMaskIntoConstraints = false
        refreshableView.autoresizingMask = [.flexibleHeight]
        self.refreshableView = refreshableView

        offlineRibbonView = VFGOfflineRibbonView()
        
        super.init()
        
        offlineRibbonView.setErrorIcon()
        offlineRibbonView.setOfflineMessage()
        offlineRibbonView.setRefreshIcon()
        offlineRibbonView.setLastUpdateMessage()
        
        offlineRibbonView.delegate = self
    }
    
    deinit {
        scrollView?.removePullToRefreshControl()
        removeScrollViewObserving()
    }
}

// MARK: - VFGPullToRefreshAnimatable

extension VFGPullToRefreshControl: VFGPullToRefreshAnimatable {
    func animate(state: VFGPullToRefreshControl.State) {
        switch state {
        case .initial:
            refreshableView.setInitialAnimationState()
        case .dragging(let progress):
            refreshableView.performDraggingUpdates(with: progress)
        case .offline:
            self.offlineRibbonView.showOfflineRibbon(withMessage: lastUpdateMessage)
        case .loading:
            if self.offlineRibbonView.isVisible {
                offlineRibbonView.showOnlineRibbon()
            }
            refreshableView.performLoadingAnimation()
        case .finished:
            refreshableView.performFinishedAnimation({ [weak self] (didFinish) in
                guard let `self` = self else { return }

                if UIApplication.shared.applicationState != .active{
                    self.scrollView?.contentInset = self.scrollViewDefaultInsets
                    self.state = .initial
                }
                else if didFinish{
                    self.state = .initial
                    self.animateFinishedState()
                }
            })
        case .failedWithErrorMessage(let message):
            self.offlineRibbonView.showOfflineRibbon(withMessage: lastUpdateMessage, failureMessage: message)
        }
    }
}

// MARK: - Key-Value Observing (Scroll View)

extension VFGPullToRefreshControl {
    fileprivate enum KVO {
        static var context = "VFGPullToRefreshControlContext"
        enum ScrollView {
            static let contentOffset    = #keyPath(UIScrollView.contentOffset)
            static let contentInset     = #keyPath(UIScrollView.contentInset)
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        defer {
            previousScrollViewOffset.y = scrollView?.normalizedContentOffset.y ?? 0
        }
        
        guard (context == &KVO.context), let keyPath = keyPath, let scrollView = object as? UIScrollView, (scrollView == self.scrollView) else { return }
        
        switch keyPath {
        case KVO.ScrollView.contentOffset:
            let offset: CGFloat = previousScrollViewOffset.y + scrollViewDefaultInsets.top
            switch offset {
            case 0 where (state != .loading):
                state = .initial
            case -pullableHeight() ... 0 where (state != .loading) && (state != .finished):
                state = .dragging(progress: -offset / pullableHeight())
            case -CGFloat.greatestFiniteMagnitude ... -pullableHeight():
                if (state == .dragging(progress: 1)) && (scrollView.isDragging == false) {
                    hasConnection = reachability.isReachable
                    state = hasConnection ? .loading : .offline
                } else if (state != .loading) && (state != .finished) {
                    state = .dragging(progress: 1)
                }
            default:
                break
            }
        case KVO.ScrollView.contentInset:
            if (state == .initial) {
                scrollViewDefaultInsets = scrollView.contentInset
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func pullableHeight() -> CGFloat {
        return Constants.RefreshableView.height + (reachability.isReachable ? Constants.OfflineRibbonView.heightZero : Constants.OfflineRibbonView.height)
    }
    
    fileprivate func currentSubViewsHeight() -> CGFloat {
        return self.refreshableView.frame.height + self.offlineRibbonView.frame.height
    }
    
    fileprivate func addScrollViewObserving() {
        guard let scrollView = scrollView, !isObserving else { return }
        
        scrollView.addObserver(self, forKeyPath: KVO.ScrollView.contentOffset, options: .initial, context: &KVO.context)
        scrollView.addObserver(self, forKeyPath: KVO.ScrollView.contentInset, options: .new, context: &KVO.context)
        
        isObserving = true
    }
    
    fileprivate func removeScrollViewObserving() {
        guard let scrollView = scrollView, isObserving else { return }
        
        scrollView.removeObserver(self, forKeyPath: KVO.ScrollView.contentOffset, context: &KVO.context)
        scrollView.removeObserver(self, forKeyPath: KVO.ScrollView.contentInset, context: &KVO.context)
        
        isObserving = false
    }
    
}

// MARK: - VFGOfflineRibbon Delegate
extension VFGPullToRefreshControl: VFGOfflineRibbonDelegate {
    
    func offlineRibbonWillAppear() {
        
        guard let scrollView = scrollView else {
            return
        }
        
        var offsetY: CGFloat = -Constants.OfflineRibbonView.height - self.scrollViewDefaultInsets.top
        
        if #available(iOS 11, *) {
            offsetY -= scrollView.safeAreaInsets.top
        }
        
        self.previousScrollViewOffset.y = offsetY
        scrollView.contentOffset.y = offsetY
        scrollView.contentInset.top = -offsetY
    }
    
    func offlineRibbonWillDisappear() {
        
        guard let scrollView = scrollView else {
            return
        }
        
        var offsetY: CGFloat =  scrollView.contentOffset.y + Constants.OfflineRibbonView.height + self.scrollViewDefaultInsets.top
        
        if #available(iOS 11, *) {
            offsetY -= scrollView.safeAreaInsets.top
        }
        
        switch state {
        case .finished:
            offsetY = scrollView.contentOffset.y + Constants.OfflineRibbonView.height + self.scrollViewDefaultInsets.top + Constants.RefreshableView.height
           
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.RefreshableView.Animation.SuccessTick.duration, execute: {
                scrollView.contentOffset.y = offsetY
                scrollView.contentInset.top = -offsetY
                self.offlineRibbonView.heightConstraint.constant = Constants.OfflineRibbonView.heightZero
            })
        case .initial:
            scrollView.contentOffset.y = self.scrollViewDefaultInsets.top
            scrollView.contentInset.top = self.scrollViewDefaultInsets.top
            self.offlineRibbonView.heightConstraint.constant = Constants.OfflineRibbonView.heightZero
        default:
            scrollView.contentOffset.y = offsetY
            scrollView.contentInset.top = -offsetY
            self.offlineRibbonView.heightConstraint.constant = Constants.OfflineRibbonView.heightZero
        }
    }
}

// MARK: - Refreshing

extension VFGPullToRefreshControl {
    func startRefreshing() {
        guard (state == .initial), let scrollView = scrollView else { return }

        var offsetY: CGFloat = -Constants.RefreshableView.height - scrollViewDefaultInsets.top
        
        if self.offlineRibbonView.isVisible {
            offsetY = -Constants.RefreshableView.height - scrollViewDefaultInsets.top - Constants.OfflineRibbonView.height
        }

        if #available(iOS 11, *) {
            offsetY -= scrollView.safeAreaInsets.top
        }

        state = .loading
        scrollView.contentInset.top = -offsetY
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: offsetY),
                                    animated: true)
    }

    func stopRefreshing(failureMessage: String? = nil) {
        if (state == .loading) {
            if let message = failureMessage {
                state = .failedWithErrorMessage(message: message)
            } else {
                state = .finished
            }
            
        }
    }
}

// MARK: - Scrolling animations

private extension VFGPullToRefreshControl {
    func animateLoadingState() {
        guard let scrollView = scrollView else {
            return
        }
        
        scrollView.bounces = false
        
        UIView.animate(withDuration: Constants.Animation.LoadingState.duration,
            animations: { [weak self] in
                guard let `self` = self else { return }
            
                let insetY = Constants.RefreshableView.height + self.scrollViewDefaultInsets.top + (!self.offlineRibbonView.isVisible ? 0.0 : Constants.OfflineRibbonView.height)
                
                scrollView.contentInset.top = insetY
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insetY)
                
                self.refreshableView.layoutIfNeeded()
                self.refreshableView.superview?.layoutIfNeeded()
                self.refreshableView.animationView.layoutIfNeeded()
                self.refreshableView.animationContainer.layoutIfNeeded()
            },
            completion: { _ in
                scrollView.bounces = true
            }
        )
        
        action?()
    }
    
    func animateFinishedState() {
        removeScrollViewObserving()
        guard let scrollView = self.scrollView else {
            return
        }

        scrollView.bounces = false

        UIView.animate(
            withDuration: Constants.Animation.FinishedState.duration,
            delay: Constants.Animation.FinishedState.delay,
            options: Constants.Animation.FinishedState.animationOptions,
            animations: { [weak self] in
                guard let `self` = self else { return }

                self.scrollView?.contentInset.top = 0
                self.scrollView?.contentInset = self.scrollViewDefaultInsets

                self.refreshableView.layoutIfNeeded()
                self.refreshableView.superview?.layoutIfNeeded()
                self.refreshableView.animationView.layoutIfNeeded()
                self.refreshableView.animationContainer.layoutIfNeeded()
            },
            completion: { [weak self] finished in
                guard let `self` = self else { return }

                if finished {
                    self.addScrollViewObserving()
                    self.state = .initial
                }
                self.scrollView?.bounces = true
            }
        )
    }
}

// MARK: - Helpers

private extension VFGPullToRefreshControl {
    var isVisible: Bool {
        guard let scrollView = scrollView else { return false }
        return (scrollView.normalizedContentOffset.y <= -scrollViewDefaultInsets.top)
    }
}
