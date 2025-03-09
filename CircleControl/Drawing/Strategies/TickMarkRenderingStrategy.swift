//
//  TickMarkRenderingStrategy.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

// MARK: - Strategy for Tick Mark Radius Calculation
protocol TickMarkRenderingStrategy {
    func calculateTickRadius(arcDiameter: CGFloat, tickMarkLength: CGFloat) -> (CGFloat, CGFloat)
}

class CircularTickMarkStrategy: TickMarkRenderingStrategy {
    func calculateTickRadius(arcDiameter: CGFloat, tickMarkLength: CGFloat) -> (CGFloat, CGFloat) {
        return (arcDiameter - tickMarkLength/3, arcDiameter - tickMarkLength)
    }
}

class DefaultTickMarkStrategy: TickMarkRenderingStrategy {
    func calculateTickRadius(arcDiameter: CGFloat, tickMarkLength: CGFloat) -> (CGFloat, CGFloat) {
        return (arcDiameter + tickMarkLength / 2, arcDiameter + tickMarkLength / 2 - tickMarkLength)
    }
}
