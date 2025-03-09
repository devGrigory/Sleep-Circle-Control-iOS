//
//  PositionCalculator.swift
//  CircleControl
//
//  Created by Grigory G. on 07.07.22.
//

import UIKit

protocol PositionCalculator {
    func calculatePosition(for index: Int, radius: CGFloat, center: CGPoint) -> CGPoint
}

final class CircularPositionCalculator: PositionCalculator {
    func calculatePosition(for index: Int, radius: CGFloat, center: CGPoint) -> CGPoint {
        let angle = ((Double(index) * 30.0) - 90.0) * .pi / 180.0
        let x = center.x + cos(angle) * radius
        let y = center.y + sin(angle) * radius
        return CGPoint(x: x, y: y)
    }
}
