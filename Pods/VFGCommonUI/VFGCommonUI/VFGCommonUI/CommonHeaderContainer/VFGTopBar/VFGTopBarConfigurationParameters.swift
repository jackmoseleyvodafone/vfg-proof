//
//  VFGTopBarParameters.swift
//  VFGCommonUI
//
//  Created by Michał Kłoczko on 28/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

struct VFGTopBarConfigurationParameters {

    static let topBarOpaqueOpacity : CGFloat = 0.85

    var initialY : CGFloat
    var lastOffset : CGFloat
    var alphaChangeStartOffset : CGFloat

    init(initialY: CGFloat, lastOffset: CGFloat, alphaChangeStartOffset: CGFloat) {
        self.initialY = initialY
        self.lastOffset = lastOffset
        self.alphaChangeStartOffset = alphaChangeStartOffset
    }

    func isScrollingUp(_ offset: CGFloat) -> Bool {
        return self.lastOffset - offset < 0
    }

    func isScrollingDown(_ offset: CGFloat) -> Bool {
        return self.lastOffset - offset > 0
    }

    func shouldStartAlphaChange(offset: CGFloat) -> Bool {
        return offset < self.alphaChangeStartOffset
    }

    func initalFrame(frame: CGRect) -> CGRect {
        return frameAtOriginY(frame, y: self.initialY)
    }

    func offscreenFrame(frame: CGRect) -> CGRect {
        return frameAtOriginY(frame, y: -frame.size.height)
    }

    func offsetFrame(frame: CGRect, offset: CGFloat) -> CGRect {
        return frameAtOriginY(frame, y: self.initialY - offset)
    }

    func alphaForOffset(_ offset: CGFloat) -> CGFloat {
        let alphaRange : CGFloat = min(VFGTopBar.topBarHeight, max((self.alphaChangeStartOffset - offset), 0))
        let minusAlpha = VFGTopBarConfigurationParameters.topBarOpaqueOpacity * alphaRange / VFGTopBar.topBarHeight
        return VFGTopBarConfigurationParameters.topBarOpaqueOpacity - minusAlpha
    }

    private func frameAtOriginY(_ frame: CGRect, y: CGFloat) -> CGRect {
        var newFrame = frame;
        newFrame.origin.y = y
        return newFrame
    }
}
