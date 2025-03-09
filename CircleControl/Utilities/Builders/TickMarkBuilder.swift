//
//  TickMarkBuilder.swift
//  CircleControl
//
//  Created by Grigory G. on 02.07.22.
//

import UIKit

// MARK: - Builder for Tick Mark Configuration
final class TickMarkBuilder {
    private let config: TickMarkConfiguration
    private var tickMarks: [CAShapeLayer] = []
    
    init(config: TickMarkConfiguration) {
        self.config = config
    }
    
    func build() -> [CAShapeLayer] {
        let twoPi = 2 * CGFloat.pi
        for tickIndex in 0..<TickMarkConstants.countForFullCircle {
            let tickRadian = CGFloat(tickIndex) * twoPi / CGFloat(TickMarkConstants.countForFullCircle)
            let isMajorMark = tickIndex % 4 == 0
            
            let startTickPoint = calculatePoint(for: tickRadian, radius: (isMajorMark && config.useCircle) ? config.outerTickRadius + 1.5 : config.outerTickRadius)
            let endTickPoint = calculatePoint(for: tickRadian, radius: isMajorMark ? config.innerTickRadius : config.useCircle ? config.innerTickRadius + 5 : config.innerTickRadius)
            let tickMarkLayer = TickMarkLayerFactory.createTickMarkLayer(from: startTickPoint, to: endTickPoint, thickness: isMajorMark ? 2.5 : config.tickMarkThickness)
            tickMarks.append(tickMarkLayer)
            
            ///Add small circles on both sides of the tick
            if config.useCircle && !isMajorMark {
                let startCircle = TickMarkLayerFactory.createCircleLayer(at: startTickPoint, radius: 1.1, color: .gray)
                let endCircle = TickMarkLayerFactory.createCircleLayer(at: endTickPoint, radius: 1.1, color: .gray)
                
                tickMarks.append(startCircle)
                tickMarks.append(endCircle)
            }
        }
        return tickMarks
    }
    
    private func calculatePoint(for radian: CGFloat, radius: CGFloat) -> CGPoint {
        return CGPoint(
            x: config.arcCenter.x + radius * cos(radian),
            y: config.arcCenter.y + radius * sin(radian)
        )
    }
}
