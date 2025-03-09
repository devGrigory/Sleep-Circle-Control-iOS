//
//  AngleCalculationStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 08.07.22.
//

import UIKit

//MARK: -
protocol AngleCalculationStrategy {
    func angularDifference(from startAngle: CGFloat, to endAngle: CGFloat) -> CGFloat
    func normalizeAngle(_ angle: CGFloat) -> CGFloat
}

class DefaultAngleCalculationStrategy: AngleCalculationStrategy {
    func angularDifference(from startAngle: CGFloat, to endAngle: CGFloat) -> CGFloat {
        let twoPi = 2 * CGFloat.pi
        let normalizedStart = startAngle.truncatingRemainder(dividingBy: twoPi)
        let normalizedEnd = endAngle.truncatingRemainder(dividingBy: twoPi)
        
        let difference = abs(normalizedStart - normalizedEnd)
        return abs(min(difference, twoPi - difference))
    }
    
    func normalizeAngle(_ angle: CGFloat) -> CGFloat {
        let twoPi = CGFloat(2 * CGFloat.pi)
        let normalized = fmod(angle, twoPi)
        return normalized >= 0 ? normalized : normalized + twoPi
    }
}
