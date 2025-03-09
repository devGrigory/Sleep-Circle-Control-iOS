//
//  RadianRangeStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 08.07.22.
//

import UIKit

//MARK: -
protocol RadianRangeStrategy {
    func isRadianInRange(_ radian: CGFloat, from start: CGFloat, to end: CGFloat) -> Bool
}

class DefaultRadianRangeStrategy: RadianRangeStrategy {
    func isRadianInRange(_ radian: CGFloat, from start: CGFloat, to end: CGFloat) -> Bool {
        let twoPi: CGFloat = 2 * CGFloat.pi
        let tickSpacing = twoPi / CGFloat(96)
        let adjustedStart = start + tickSpacing
        let adjustedEnd = end - tickSpacing
        
        if adjustedStart < adjustedEnd {
            return radian >= adjustedStart && radian <= adjustedEnd
        } else {
            return radian >= adjustedStart || radian <= adjustedEnd
        }
    }
}
