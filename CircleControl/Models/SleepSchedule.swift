//
//  SleepSchedule.swift
//  CircleControl
//
//  Created by Grigory G. on 01.07.22.
//

import Foundation

final class SleepSchedule {
    private var bedtime: Time?
    private var wakeUpTime: Time?
    
    init(bedtime: Time? = nil, wakeUpTime: Time? = nil) {
        self.bedtime = bedtime
        self.wakeUpTime = wakeUpTime
    }
    
    /// Accessors
    func getBedtime() -> Time? {
        return bedtime
    }
    
    func setBedtime(_ time: Time?) {
        bedtime = time
    }
    
    func getWakeUpTime() -> Time? {
        return wakeUpTime
    }
    
    func setWakeUpTime(_ time: Time?) {
        wakeUpTime = time
    }
    
    func getSleepDuration() -> Time {
        guard let bedtime = bedtime, let wakeUpTime = wakeUpTime else {
            return Time(hour: 0, minute: 0)
        }
        /// Convert to total minutes
        let bedtimeMinutes = (bedtime.hour * 60) + bedtime.minute
        let wakeUpMinutes = (wakeUpTime.hour * 60) + wakeUpTime.minute
        /// Calculates the total sleep duration in minutes.
        let totalMinutes = (wakeUpMinutes >= bedtimeMinutes)
        ? wakeUpMinutes - bedtimeMinutes
        : (1440 - bedtimeMinutes) + wakeUpMinutes
        /// Convert back to hours and minutes
        let durationHours = totalMinutes / 60
        let durationMinutes = totalMinutes % 60
        
        return Time(hour: durationHours, minute: durationMinutes)
    }
}
