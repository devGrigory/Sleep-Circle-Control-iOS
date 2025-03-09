//
//  MathUtils.swift
//  CircleControl
//
//  Created by Grigory G. on 08.07.22.
//

import UIKit

class MathUtils {
    
    static let shared = MathUtils()
    
    private let circlePointStrategy: CirclePointStrategy
    private let angleCalculationStrategy: AngleCalculationStrategy
    private let radianAdjustmentStrategy: RadianAdjustmentStrategy
    private let touchRadianCalculationStrategy: TouchRadianCalculationStrategy
    private let timeToRadianStrategy: TimeToRadianStrategy
    private let directionStrategy: DirectionStrategy
    private let radianRangeStrategy: RadianRangeStrategy
    
    init(circlePointStrategy: CirclePointStrategy = DefaultCirclePointStrategy(),
         angleCalculationStrategy: AngleCalculationStrategy = DefaultAngleCalculationStrategy(),
         radianAdjustmentStrategy: RadianAdjustmentStrategy = DefaultRadianAdjustmentStrategy(),
         touchRadianCalculationStrategy: TouchRadianCalculationStrategy = DefaultTouchRadianCalculationStrategy(),
         radianRangeStrategy: RadianRangeStrategy = DefaultRadianRangeStrategy(),
         timeToRadianStrategy: TimeToRadianStrategy = DefaultTimeToRadianStrategy(),
         directionStrategy: DirectionStrategy = DefaultDirectionStrategy()) {
        self.circlePointStrategy = circlePointStrategy
        self.angleCalculationStrategy = angleCalculationStrategy
        self.radianAdjustmentStrategy = radianAdjustmentStrategy
        self.touchRadianCalculationStrategy = touchRadianCalculationStrategy
        self.radianRangeStrategy = radianRangeStrategy
        self.timeToRadianStrategy = timeToRadianStrategy
        self.directionStrategy = directionStrategy
    }
    
    func getCirclePoint(from touchPoint: CGPoint, relativeTo center: CGPoint, arcRadius: CGFloat) -> CGPoint {
        return circlePointStrategy.getCirclePoint(from: touchPoint, relativeTo: center, arcRadius: arcRadius)
    }
    
    func angularDifference(from startAngle: CGFloat, to endAngle: CGFloat) -> CGFloat {
        return angleCalculationStrategy.angularDifference(from: startAngle, to: endAngle)
    }
    
    func calculateRadianRange(from bedTime: Time, to wakeUpTime: Time) -> CGFloat {
        return timeToRadianStrategy.calculateRadianRange(from: bedTime, to: wakeUpTime)
    }
    
    func isClockwise(from previous: CGFloat, to current: CGFloat) -> Bool {
        return directionStrategy.isClockwise(from: previous, to: current)
    }
    
    func clockwiseDifference(from start: CGFloat, to end: CGFloat) -> CGFloat {
        return directionStrategy.clockwiseDifference(from: start, to: end)
    }
    
    func isRadianRangeValid(_ radianRange: CGFloat) -> Bool {
        return radianRange >= AlarmConstants.minAllowedSleepAngle &&
        radianRange <= AlarmConstants.maxSleepAngle
    }
    
    func isRadianInRange(_ radian: CGFloat, from start: CGFloat, to end: CGFloat) -> Bool {
        return radianRangeStrategy.isRadianInRange(radian, from: start, to: end)
    }
    
    func pointOnCircle(at radian: CGFloat, withRadius radius: CGFloat, relativeTo center: CGPoint) -> CGPoint {
        return circlePointStrategy.pointOnCircle(at: radian, withRadius: radius, relativeTo: center)
    }
    
    func calculateNewStartRadian(from radian: CGFloat, with minDuration: CGFloat, lastHandleRadian: CGFloat) -> CGFloat {
        return radianAdjustmentStrategy.calculateNewStartRadian(from: radian, with: minDuration, lastHandleRadian: lastHandleRadian)
    }
    
    func calculateTouchRadian(from point: CGPoint, relativeTo center: CGPoint) -> CGFloat {
        return touchRadianCalculationStrategy.calculateTouchRadian(from: point, relativeTo: center)
    }
    
    func normalizeAngle(_ angle: CGFloat) -> CGFloat {
        angleCalculationStrategy.normalizeAngle(angle)
    }
}
