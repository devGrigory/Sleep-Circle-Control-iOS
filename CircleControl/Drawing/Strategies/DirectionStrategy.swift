//
//  DirectionStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 08.07.22.
//

import UIKit

//MARK: -
protocol DirectionStrategy {
    func isClockwise(from previous: CGFloat, to current: CGFloat) -> Bool
    func clockwiseDifference(from start: CGFloat, to end: CGFloat) -> CGFloat
}

class DefaultDirectionStrategy: DirectionStrategy {
    func isClockwise(from previous: CGFloat, to current: CGFloat) -> Bool {
        let normalizedPrevious = DefaultAngleCalculationStrategy().normalizeAngle(previous)
        let normalizedCurrent = DefaultAngleCalculationStrategy().normalizeAngle(current)
        
        let difference = normalizedCurrent - normalizedPrevious
        let isClockwiseMovement = (difference > 0 && difference <= .pi) || (difference < 0 && abs(difference) > .pi)
        return isClockwiseMovement
    }
    
    func clockwiseDifference(from start: CGFloat, to end: CGFloat) -> CGFloat {
        let twoPi = CGFloat.pi * 2
        let diff = (end - start).truncatingRemainder(dividingBy: twoPi)
        return diff >= 0 ? diff : diff + twoPi
    }
}
