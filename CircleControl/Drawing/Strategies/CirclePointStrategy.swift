//
//  CirclePointStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 08.07.22.
//

import UIKit

//MARK: -
protocol CirclePointStrategy {
    func getCirclePoint(from touchPoint: CGPoint, relativeTo center: CGPoint, arcRadius: CGFloat) -> CGPoint
    func pointOnCircle(at radian: CGFloat, withRadius radius: CGFloat, relativeTo center: CGPoint) -> CGPoint
}

class DefaultCirclePointStrategy: CirclePointStrategy {
    /// Calculates the closest point on the circle's perimeter from a given touch point.
    func getCirclePoint(from touchPoint: CGPoint, relativeTo center: CGPoint, arcRadius: CGFloat) -> CGPoint {
        let offsetPoint = CGPoint(x: touchPoint.x - center.x, y: touchPoint.y - center.y)
        let touchRadian = atan2(offsetPoint.y, offsetPoint.x)
        return pointOnCircle(at: touchRadian, withRadius: arcRadius, relativeTo: center)
    }
    /// Computes a point on the circle given an angle in radians.
    func pointOnCircle(at radian: CGFloat, withRadius radius: CGFloat, relativeTo center: CGPoint) -> CGPoint {
        let x = radius * cos(radian)
        let y = radius * sin(radian)
        return CGPoint(x: x + center.x, y: y + center.y)
    }
}
