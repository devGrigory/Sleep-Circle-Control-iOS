//
//  TimeUtils.swift
//  CircleControl
//
//  Created by Grigory G. on 06.07.22.
//

import UIKit
    
final class TimeUtils {
    
    static let shared = TimeUtils()
    
    // Pre-initialized strategy instances
    private let timeFromRadiansStrategy: TimeFromRadiansStrategy
    private let totalMinutesFromRadiansStrategy: TotalMinutesFromRadiansStrategy
    private let extractTimeStrategy: ExtractTimeStrategy
    private let radianFromTimeFloatStrategy: RadianFromTimeFloatStrategy
    private let radiansForTimeStrategy: RadiansForTimeStrategy
    
    init(timeFromRadiansStrategy: TimeFromRadiansStrategy = TimeFromRadiansStrategy(),
         totalMinutesFromRadiansStrategy: TotalMinutesFromRadiansStrategy = TotalMinutesFromRadiansStrategy(),
         extractTimeStrategy: ExtractTimeStrategy = ExtractTimeStrategy(),
         radianFromTimeFloatStrategy: RadianFromTimeFloatStrategy = RadianFromTimeFloatStrategy(),
         radiansForTimeStrategy: RadiansForTimeStrategy = RadiansForTimeStrategy()) {
        self.timeFromRadiansStrategy = timeFromRadiansStrategy
        self.totalMinutesFromRadiansStrategy = totalMinutesFromRadiansStrategy
        self.extractTimeStrategy = extractTimeStrategy
        self.radianFromTimeFloatStrategy = radianFromTimeFloatStrategy
        self.radiansForTimeStrategy = radiansForTimeStrategy
    }
    
    func timeFromRadians(_ radians: CGFloat) -> String {
        return timeFromRadiansStrategy.convert(radians)
    }
    
    func calculateTotalMinutes(from radians: CGFloat) -> CGFloat {
        return totalMinutesFromRadiansStrategy.convert(radians)
    }
    
    func extractTime(from timeString: String) -> Time? {
        return extractTimeStrategy.convert(timeString)
    }
    
    func calculateRadian(for timeFloatValue: Float) -> CGFloat {
        return radianFromTimeFloatStrategy.convert(timeFloatValue)
    }
    
    func radiansForTime(hour: Int, minute: Int) -> CGFloat {
        return radiansForTimeStrategy.convert((hour, minute))
    }
}
