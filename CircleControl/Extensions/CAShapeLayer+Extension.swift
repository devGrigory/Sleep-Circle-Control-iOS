//
//  CAShapeLayer+Extension.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

extension CAShapeLayer {
    /// Custom initializer for CAShapeLayer
    convenience init(path: UIBezierPath,
                     lineWidth: CGFloat = 1.0,
                     strokeColor: CGColor = ThemeManager.Color.cloudGrayColor.cgColor) {
        self.init()
        self.path = path.cgPath
        self.lineWidth = lineWidth
        self.strokeColor = strokeColor
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
}
