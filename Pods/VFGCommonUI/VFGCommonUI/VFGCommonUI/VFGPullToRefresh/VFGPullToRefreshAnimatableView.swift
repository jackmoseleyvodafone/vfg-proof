//
//  VFGPullToRefreshAnimatableView.swift
//  VFGCommonUI
//
//  Created by Emilio Alberto Ojeda Mendoza on 1/24/18.
//  Copyright © 2018 Vodafone. All rights reserved.
//

import UIKit
import Lottie

/*
 *  A RefreshControl has a height of 60pts, the rest is taken from design specifications
 */
fileprivate enum Constants {
    enum RefreshControlView {
        static let width = UIScreen.main.bounds.width
        static let height = 60
        
        enum Container {
            static let width = 29
            static let height = 37
        }
        
        enum Animation {
            enum ExpandableCircle {
                static let width = 29
                static let height = 30
                static let duration = 0.5
                static let scaleX_transformation: CGFloat = 20.0
                static let scaleY_transformation: CGFloat = 20.0
                static let returnCallbackTimer = 1.0
            }
            enum SuccessTick {
                static let width = 29
                static let height = 30
            }
            enum LoadingView {
                static let width = 29
                static let height = 37
            }
        }
    }
}


internal protocol VFGPullToRefreshAnimatableViewProtocol {
    func setInitialAnimationState()
    func performDraggingUpdates(with progress: CGFloat)
    func performLoadingAnimation()
    func performFinishedAnimation(_ completion: @escaping (Bool) -> Void)
}

internal class VFGPullToRefreshAnimatableView: UIView {
    enum Animation: String {
        case dragging = "pull_vf_speechmark_p1.json"
        case loading = "pull_vf_speechmark_p2.json"
        case loading2 = "pull_vf_speechmark_p3_loop.json"
        case successTickOffline = "offline_success_tick_green.json"
        case successTickOnline = "pull_success_tick_white.json"
        
        static func composition(for animation: Animation) -> LOTComposition? {
            guard let bundle = VFGCommonUIBundle.bundle() else {
                return .none
            }
            return LOTComposition(name: animation.rawValue, bundle: bundle)
        }
    }
    
    fileprivate(set) lazy var animationView: LOTAnimationView = {
        return LOTAnimationView()
    }()
    
    
    var animationContainer: UIView
    var expandableCircle: UIView
    var refreshControlBgColor: UIColor
    var expandableCircleBgColor: UIColor
    var offlineRibbonView: VFGOfflineRibbonView
    fileprivate var scrollViewDefaultInsets: UIEdgeInsets = .zero
    
    required init() {
        
        offlineRibbonView = VFGOfflineRibbonView.init()
        
        animationContainer = UIView.init(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: Constants.RefreshControlView.Container.width,
                                                       height: Constants.RefreshControlView.Container.height))
        expandableCircle = UIView.init(frame: CGRect(x: 0,
                                                        y: 0,
                                                        width: Constants.RefreshControlView.Animation.ExpandableCircle.width,
                                                        height: Constants.RefreshControlView.Animation.ExpandableCircle.height))
        
        refreshControlBgColor = UIColor.VFGRefreshableViewColor
        expandableCircleBgColor = UIColor.VFGExpandableCircleColor
        
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: Int(Constants.RefreshControlView.width),
                                 height: Constants.RefreshControlView.height))
        tintColor = UIColor.clear
        backgroundColor = refreshControlBgColor
        clipsToBounds = true
        
        animationContainer.center = center
        animationContainer.backgroundColor = UIColor.clear
        
        animationView = LOTAnimationView.init(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: Constants.RefreshControlView.Animation.LoadingView.width,
                                                            height: Constants.RefreshControlView.Animation.LoadingView.height))
        
        animationView.sceneModel = Animation.composition(for: .dragging)
        animationView.contentMode = .scaleAspectFit
        animationContainer.addSubview(animationView)
        
        expandableCircle.backgroundColor = UIColor.clear
        expandableCircle.layer.cornerRadius = expandableCircle.frame.size.height/2
        expandableCircle.center = center
        
        addSubview(expandableCircle)
        addSubview(animationContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) is not implemented.")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let grandparent = superview?.superview else { return }
        
        self.autoPinEdge(.top, to: .top, of: grandparent)
        self.autoPinEdge(.leading, to: .leading, of: grandparent)
        self.autoPinEdge(.trailing, to: .trailing, of: grandparent)
        
        animationContainer.autoPinEdge(.top, to: .top, of: self)
        animationContainer.autoPinEdge(.bottom, to: .bottom, of: self)
        animationContainer.autoPinEdge(.leading, to: .leading, of: self)
        animationContainer.autoPinEdge(.trailing, to: .trailing, of: self)
        
        animationView.autoPinEdge(.top, to: .top, of: animationContainer)
        animationView.autoPinEdge(.bottom, to: .bottom, of: animationContainer)
        
        animationView.autoCenterInSuperview()
    }
}

extension VFGPullToRefreshAnimatableView: VFGPullToRefreshAnimatableViewProtocol {
    func setInitialAnimationState() {
        animationView.sceneModel = Animation.composition(for: .dragging)
        animationView.loopAnimation = false
    }
    
    func performDraggingUpdates(with progress: CGFloat) {
        animationView.animationProgress = progress
    }
    
    func performLoadingAnimation() {
        animationView.sceneModel = Animation.composition(for: .loading)
        animationView.loopAnimation = false
        animationView.play { (finished) in
            self.animationView.sceneModel = Animation.composition(for: .loading2)
            self.animationView.loopAnimation = true
            self.animationView.play()
        }
    }
    
    func performFinishedAnimation(_ completion: @escaping (Bool) -> Void) {
        
        animationView.sceneModel = Animation.composition(for: .successTickOnline)
        animationView.loopAnimation = false
        
        self.expandableCircle.backgroundColor = expandableCircleBgColor
        UIView.animate(withDuration: Constants.RefreshControlView.Animation.ExpandableCircle.duration, animations: {
            self.expandableCircle.transform = CGAffineTransform(scaleX: Constants.RefreshControlView.Animation.ExpandableCircle.scaleX_transformation,
                                                                y: Constants.RefreshControlView.Animation.ExpandableCircle.scaleY_transformation)
            self.expandableCircle.backgroundColor = UIColor.clear
        }) { (finished) in
            self.expandableCircle.transform = CGAffineTransform.identity
        }
        animationView.play()
        
        let delayTime = DispatchTime.now() + Double(Int64(Constants.RefreshControlView.Animation.ExpandableCircle.returnCallbackTimer * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            completion(true)
        }
    }
}

