//
//  ClockNumberProvider.swift
//  CircleControl
//
//  Created by Grigory G. on 06.07.22.
//

import UIKit

protocol ClockNumberProvider {
    func createClockNumber(for index: Int, size: CGFloat) -> NSAttributedString
}

final class DefaultClockNumberProvider: ClockNumberProvider {
    func createClockNumber(for index: Int, size: CGFloat) -> NSAttributedString {
        let isQuarterHour = (index % 3 == 0)
        let textColor = isQuarterHour ? ThemeManager.Color.whiteColor : ThemeManager.Color.cloudWhiteColor
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: isQuarterHour ? ThemeManager.Font.bold() : ThemeManager.Font.regular()
        ]
        return NSAttributedString(string: String(index * 2), attributes: attributes)
    }
}
