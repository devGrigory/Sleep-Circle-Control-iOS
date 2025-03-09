//
//  AlarmConstants.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

public struct AlarmConstants {
    //MARK: - Set restrictions from min 0-1 hours and max 0-18 hours
    public static let minAllowedSleepAngle: CGFloat = (.pi * 2) / 24 /// Initial min value (1 hours)
    public static let maxSleepAngle: CGFloat = (3 * .pi) / 2  /// Initial max value (18 hours)
    public static let maxAllowedSleepAngle: CGFloat = .pi / 2 /// Initial max value (18 hours)
}
