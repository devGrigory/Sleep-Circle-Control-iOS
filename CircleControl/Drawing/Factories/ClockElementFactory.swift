//
//  ClockElementFactory.swift
//  CircleControl
//
//  Created by Grigory G. on 10.07.22.
//

import UIKit

final class ClockElementFactory {
    static func createClockNumber(_ number: NSAttributedString, at position: CGPoint) -> CATextLayer {
        let numberLayer = CATextLayer()
        numberLayer.string = number
        numberLayer.frame = CGRect(
            x: position.x - number.size().width / 2,
            y: position.y - number.size().height / 2,
            width: number.size().width,
            height: number.size().height
        )
        numberLayer.foregroundColor = ThemeManager.Color.whiteColor.cgColor
        numberLayer.alignmentMode = .center
        numberLayer.contentsScale = UIScreen.main.scale
        return numberLayer
    }
}
