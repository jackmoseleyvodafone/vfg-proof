//
//  VFGTopBarStateManager.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 28/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

class VFGTopBarStateManager {

    var topBar : VFGTopBar? {
        didSet {
            self.state.topBar = self.topBar
        }
    }
    private(set) var state : VFGTopBarState
    private lazy var stateFinishedCallback : (_ nextState: VFGTopBarState.State, _ parameters: VFGTopBarConfigurationParameters) -> Void = {
        return { [unowned self] (nextState: VFGTopBarState.State, parameters: VFGTopBarConfigurationParameters) -> Void in
            self.state = self.makeState(forState: nextState, parameters: parameters)
            self.state.stateFinishedCallback = self.stateFinishedCallback
            self.state.start()
        }
    }()

    required init(parameters: VFGTopBarConfigurationParameters) {
        self.state = VFGTopBarScrollingState(parameters: parameters)
        self.state.stateFinishedCallback = self.stateFinishedCallback
    }

    func didScroll(withOffset offset: CGFloat) {
        self.state.didScroll(withOffset: offset)
    }

    private func makeScrollingState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarScrollingState {
        let state : VFGTopBarScrollingState = VFGTopBarScrollingState(parameters: parameters)
        state.topBar = self.topBar

        return state
    }

    private func makeOffscreenState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarOffscreenState {
        let state : VFGTopBarOffscreenState = VFGTopBarOffscreenState(parameters: parameters)
        state.topBar = self.topBar

        return state
    }

    private func makeOpaqueState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarOpaqueState {
        let state : VFGTopBarOpaqueState = VFGTopBarOpaqueState(parameters: parameters)
        state.topBar = self.topBar

        return state
    }

    private func makeAlphaState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarAlphaState {
        let state : VFGTopBarAlphaState = VFGTopBarAlphaState(parameters: parameters)
        state.topBar = self.topBar

        return state
    }

    private func makeAnimateShowingBarState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarAnimateShowingState {
        let state : VFGTopBarAnimateShowingState = VFGTopBarAnimateShowingState(parameters: parameters)
        state.topBar = self.topBar

        return state
    }

    private func makeHideAnimatingTopBarState(parameters: VFGTopBarConfigurationParameters) -> VFGTopBarAnimateHiddingState {
        let state : VFGTopBarAnimateHiddingState = VFGTopBarAnimateHiddingState(parameters: parameters)
        state.topBar = self.topBar

        return state
    }

    func makeState(forState state: VFGTopBarState.State, parameters: VFGTopBarConfigurationParameters) -> VFGTopBarState {
        switch state {
        case .alpha:
            return self.makeAlphaState(parameters: parameters)
        case .offscreen:
            return self.makeOffscreenState(parameters: parameters)
        case .opaque:
            return self.makeOpaqueState(parameters: parameters)
        case .showing:
            return self.makeAnimateShowingBarState(parameters: parameters)
        case .hiding:
            return self.makeHideAnimatingTopBarState(parameters: parameters)
        default:
            return self.makeScrollingState(parameters: parameters)
        }
    }
}
