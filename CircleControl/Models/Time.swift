//
//  Time.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import Foundation

struct Time {
    let hour: Int
    let minute: Int
    
    /// Returns the time as a float, where the minutes are converted into a fraction of an hour.
    var floatValue: Float {
        Float(hour) + Float(minute) / 60.0
    }
    
    /// Operator Overloading for Subtraction
    static func -(lhs: Time, rhs: Time) -> Time {
        let lhsTotalMinutes = (lhs.hour * 60) + lhs.minute
        let rhsTotalMinutes = (rhs.hour * 60) + rhs.minute
        
        let diffMinutes = lhsTotalMinutes - rhsTotalMinutes
        
        let resultHours = abs(diffMinutes) / 60
        let resultMinutes = abs(diffMinutes) % 60
        
        return Time(hour: resultHours, minute: resultMinutes)
    }
    
    /// Operator Overloading for Addition
    static func +(lhs: Time, rhs: Time) -> Time {
        let lhsTotalMinutes = (lhs.hour * 60) + lhs.minute
        let rhsTotalMinutes = (rhs.hour * 60) + rhs.minute
        
        let totalMinutes = lhsTotalMinutes + rhsTotalMinutes
        
        let resultHours = totalMinutes / 60
        let resultMinutes = totalMinutes % 60
        return Time(hour: resultHours, minute: resultMinutes)
    }
}

extension Time {
    func formattedTime() -> String {
        let hour = String(format: "%02d", self.hour)
        let minute = String(format: "%02d", self.minute)
        return "\(hour):\(minute)"
    }
    
    func formattedDuration() -> String {
        return "\(String(format: "%02d", self.hour)) hour \(String(format: "%02d", self.minute)) min"
    }
}
