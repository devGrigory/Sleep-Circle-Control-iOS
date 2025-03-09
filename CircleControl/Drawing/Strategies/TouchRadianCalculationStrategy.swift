//
//  TouchRadianCalculationStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 09.07.22.
//

import UIKit

//MARK: -
protocol TouchRadianCalculationStrategy {
    func calculateTouchRadian(from point: CGPoint, relativeTo center: CGPoint) -> CGFloat
}

class DefaultTouchRadianCalculationStrategy: TouchRadianCalculationStrategy {
    func calculateTouchRadian(from point: CGPoint, relativeTo center: CGPoint) -> CGFloat {
        return atan2(point.y - center.y, point.x - center.x)
    }
}
