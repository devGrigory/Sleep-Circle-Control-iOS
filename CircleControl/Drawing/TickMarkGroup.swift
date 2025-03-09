//
//  TickMarkGroup.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

// MARK: - Composite for Managing Tick Marks
final class TickMarkGroup: CALayer {
    func addTickMark(_ tickMark: CAShapeLayer) {
            addSublayer(tickMark)
        }
    
    func removeAllTickMarks() {
        sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}
