//
//  RadianAdjustmentStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 09.07.22.
//

import UIKit

//MARK: -
protocol RadianAdjustmentStrategy {
    func calculateNewStartRadian(from radian: CGFloat, with minDuration: CGFloat, lastHandleRadian: CGFloat) -> CGFloat
}

class DefaultRadianAdjustmentStrategy: RadianAdjustmentStrategy {
    func calculateNewStartRadian(from radian: CGFloat, with minDuration: CGFloat, lastHandleRadian: CGFloat) -> CGFloat {
        let directionStrategy = DefaultDirectionStrategy()
        let duration = directionStrategy.isClockwise(from: lastHandleRadian, to: radian) ? minDuration : -minDuration
        return radian + duration
    }
}
