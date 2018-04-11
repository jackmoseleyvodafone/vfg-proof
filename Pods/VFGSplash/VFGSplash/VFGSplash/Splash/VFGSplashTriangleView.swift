//
//  VFGSplashTriangleView.swift
//  VFGSplash
//
//  Created by Ahmed Naguib on 11/14/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

/**
 * Custom View for Vodafone Rhombus
 */
open class VFGSplashTriangleView: UIView {

    // MARK: Properties

    /** The Triangle Layer */
    open let triangleShapeLayer = CAShapeLayer()

    /** The Triangle Direction */
    open var arcDirection: SplashTriangleDirection = .SplashTriangleDirectionLeft

    /** The Triangle Color */
    @IBInspectable open var fillColor: UIColor = redTriangleColor

    /** The Logo Radius in The Triangle */
    @IBInspectable open var radius: CGFloat = splashTraingleRadius

    /** The Triangle Start Degrees */
    @IBInspectable open var startDegrees: CGFloat = splashTraingleStartDegrees

    /** The Triangle End Degrees */
    @IBInspectable open var endDegrees: CGFloat = splashTraingleEndDegrees

    // MARK: UIView

    override open func layoutSubviews() {
        super.layoutSubviews()
        drawTriangleShapeLayer()
    }

    // MARK: Init

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawTriangleShapeLayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        drawTriangleShapeLayer()
    }

    // MARK: Private methods

    fileprivate func pointOnCircleWith(origin: CGPoint,
                                       withRadius radius: CGFloat,
                                       atDegrees degrees: CGFloat) -> CGPoint {

        let radians = CGFloat(degrees) * (CGFloat(M_PI) / PIRadiansInDegrees)

        // Calculate the points
        let x = origin.x + radius * cos(radians)
        let y = origin.y + radius * sin(radians)

        return CGPoint(x: x, y: y)
    }

    fileprivate func drawTriangleShapeLayer() {

        triangleShapeLayer.removeFromSuperlayer()

        let center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)

        // Calculate the bottom point of the circle
        let bottomCirclePoint = self.pointOnCircleWith(origin: center,
                                                       withRadius: radius,
                                                       atDegrees: startDegrees)

        // Create the path that is a essentially a triangle with a rounder corner.
        let trianglePath = UIBezierPath()
        trianglePath.move(to:bottomCirclePoint)
        trianglePath.addArc(withCenter: center,
                            radius: radius,
                            startAngle: (startDegrees) * (CGFloat(M_PI) / PIRadiansInDegrees),
                            endAngle: (endDegrees) * (CGFloat(M_PI) / PIRadiansInDegrees),
                            clockwise: true)

        let isIPadDevice = self.traitCollection.verticalSizeClass == .regular && self.traitCollection.horizontalSizeClass == .regular

        if (arcDirection == .SplashTriangleDirectionLeft) {

            let minYPosition: CGFloat = isIPadDevice ? leftDirectionTriangleMinYPositionIPad : leftDirectionTriangleMinYPositionIPhone

            trianglePath.addLine(to: CGPoint(x: leftDirectionTriangleMaxXPosition,
                                             y: minYPosition))
            trianglePath.addLine(to: CGPoint(x: leftDirectionTriangleMaxXPosition,
                                             y: leftDirectionTriangleMaxYPosition))
        } else {

            let maxYPosition: CGFloat = isIPadDevice ? rightDirectionTriangleMaxYPositionIPad : rightDirectionTriangleMaxYPositionIPhone

            trianglePath.addLine(to: CGPoint(x: rightDirectionTriangleMaxXPosition,
                                             y: maxYPosition))
            trianglePath.addLine(to: CGPoint(x: rightDirectionTriangleMaxXPosition,
                                             y: rightDirectionTriangleMinYPosition))
        }
        trianglePath.close()

        triangleShapeLayer.path = trianglePath.cgPath
        triangleShapeLayer.fillColor = self.fillColor.cgColor
        triangleShapeLayer.shouldRasterize = true
        layer.addSublayer(triangleShapeLayer)
    }
}
