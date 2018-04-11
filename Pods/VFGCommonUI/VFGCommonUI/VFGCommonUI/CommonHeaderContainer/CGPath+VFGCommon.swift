//
//  CGPath+VFGCommon.swift
//  VFGReferenceApp
//
//  Created by Michał Kłoczko on 18/11/16.
//  Copyright © 2016 Vodafone. All rights reserved.
//

import UIKit

public extension CGPath {

    static func chipped(chipHeight: CGFloat, shapeRect: CGRect) -> CGPath {
        let path = UIBezierPath()
        path.move(to: shapeRect.origin)
        path.addLine(to: CGPoint(x: shapeRect.width/2.0 - chipHeight, y: shapeRect.origin.y))
        path.addLine(to: CGPoint(x: shapeRect.width/2.0 , y: chipHeight))
        path.addLine(to: CGPoint(x: shapeRect.width/2.0 + chipHeight, y: shapeRect.origin.y))
        path.addLine(to: CGPoint(x: shapeRect.width, y: shapeRect.origin.y))
        path.addLine(to: CGPoint(x: shapeRect.width, y: shapeRect.height))
        path.addLine(to: CGPoint(x: shapeRect.origin.x, y: shapeRect.height))
        path.close()
        let cgPath = path.cgPath

        return cgPath;
    }

}
