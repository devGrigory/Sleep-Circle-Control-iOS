//
//  ClockFaceRenderer.swift
//  CircleControl
//
//  Created by Grigory G. on 05.07.22.
//

import UIKit

protocol ClockFaceRenderer {
    func drawClockFace(in layer: CALayer, radius: CGFloat, center: CGPoint)
}

final class DefaultClockFaceRenderer: ClockFaceRenderer {
    private let numberProvider: ClockNumberProvider
    private let positionCalculator: PositionCalculator
    private let size: CGFloat
    
    init(numberProvider: ClockNumberProvider = DefaultClockNumberProvider(),
         positionCalculator: PositionCalculator = CircularPositionCalculator(),
         size: CGFloat = 12.0) {
        self.numberProvider = numberProvider
        self.positionCalculator = positionCalculator
        self.size = size
    }
    
    func drawClockFace(in layer: CALayer, radius: CGFloat, center: CGPoint) {
        let tickMarkGroup = TickMarkRenderer(
            displayFrom: 0, to: 2 * CGFloat.pi,
            arcRadius: radius, arcCenter: center,
            isCircularMode: true
        )
        layer.addSublayer(tickMarkGroup)
        
        let textRadius = radius * 0.8
        for i in 0...11 {
            let number = numberProvider.createClockNumber(for: i, size: size)
            let position = positionCalculator.calculatePosition(for: i, radius: textRadius, center: center)
            let numberLayer = ClockElementFactory.createClockNumber(number, at: position)
            layer.addSublayer(numberLayer)
        }
    }
}
