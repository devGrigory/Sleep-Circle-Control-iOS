//
//  Untitled.swift
//  CircleControl
//
//  Created by Grigory G. on 09.07.22.
//

import UIKit

//MARK: -
protocol TimeToRadianStrategy {
    func calculateRadianRange(from bedTime: Time, to wakeUpTime: Time) -> CGFloat
}

class DefaultTimeToRadianStrategy: TimeToRadianStrategy {
    func calculateRadianRange(from bedTime: Time, to wakeUpTime: Time) -> CGFloat {
        let totalMinutesInDay: CGFloat = 24 * 60
        let twoPi: CGFloat = 2 * .pi
        
        let startTotalMinutes = CGFloat(bedTime.hour * 60 + bedTime.minute)
        let endTotalMinutes = CGFloat(wakeUpTime.hour * 60 + wakeUpTime.minute)
        
        let timeDifferenceMinutes: CGFloat
        if endTotalMinutes >= startTotalMinutes {
            timeDifferenceMinutes = endTotalMinutes - startTotalMinutes
        } else {
            timeDifferenceMinutes = (totalMinutesInDay - startTotalMinutes) + endTotalMinutes
        }
        
        let radianRange = (timeDifferenceMinutes / totalMinutesInDay) * twoPi
        return radianRange
    }
}
