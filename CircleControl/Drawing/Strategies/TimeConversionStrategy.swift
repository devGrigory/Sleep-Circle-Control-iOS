//
//  TimeConversionStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 06.07.22.
//

import UIKit

protocol TimeConversionStrategy {
    associatedtype Input
    associatedtype Output
    func convert(_ input: Input) -> Output
}

class RadiansForTimeStrategy: TimeConversionStrategy {
    func convert(_ time: (hour: Int, minute: Int)) -> CGFloat {
        let totalMinutes = CGFloat(time.hour * 60 + time.minute)
        return totalMinutes * TimeConstants.radiansPerMinute
    }
}

class RadianFromTimeFloatStrategy: TimeConversionStrategy {
    func convert(_ timeFloatValue: Float) -> CGFloat {
        let morningStartTime: Float = 6.0
        let adjustedTime = timeFloatValue >= morningStartTime ? timeFloatValue - morningStartTime : (24.0 + timeFloatValue) - morningStartTime
        return TimeConstants.radiansPerHour * CGFloat(adjustedTime)
    }
}

class ExtractTimeStrategy: TimeConversionStrategy {
    func convert(_ timeString: String) -> Time? {
        let components = timeString.split(separator: ":").compactMap { Int($0) }
        guard components.count == 2 else { return nil }
        return Time(hour: components[0], minute: components[1])
    }
}

class TotalMinutesFromRadiansStrategy: TimeConversionStrategy {
    func convert(_ radians: CGFloat) -> CGFloat {
        let normalizedRadians = (radians + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi)
        var totalMinutes = normalizedRadians / TimeConstants.radiansPerMinute - TimeConstants.offsetMinutes
        
        if totalMinutes < 0 {
            totalMinutes += TimeConstants.minutesPerDay
        }
        return round(totalMinutes)
    }
}

class TimeFromRadiansStrategy: TimeConversionStrategy {
    func convert(_ radians: CGFloat) -> String {
        let totalMinutes = TotalMinutesFromRadiansStrategy().convert(radians)
        let hour = Int(totalMinutes) / 60
        let minute = Int(totalMinutes) % 60
        return String(format: "%02d:%02d", hour, minute)
    }
}

