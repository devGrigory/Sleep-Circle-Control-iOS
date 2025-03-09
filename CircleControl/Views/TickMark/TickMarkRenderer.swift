//
//  TickMarkRenderer.swift
//  CircleControl
//
//  Created by Grigory G. on 04.07.22.
//

import UIKit

// MARK: - TickMark Rendering Protocol
protocol TickMarkRenderingProtocol {
    func updateTickMarkVisibility(from startRadian: CGFloat, to endRadian: CGFloat, isCircularMode: Bool)
}

// MARK: - TickMark Renderer Class
final class TickMarkRenderer: CAShapeLayer, TickMarkRenderingProtocol {
    private var tickMarkGroup = TickMarkGroup()
    private var strategy: TickMarkRenderingStrategy
    private var isCircularMode: Bool
    
    init(displayFrom startRadian: CGFloat,
         to endRadian: CGFloat,
         arcRadius: CGFloat,
         arcCenter: CGPoint,
         isCircularMode: Bool) {
        self.strategy = isCircularMode ? CircularTickMarkStrategy() : DefaultTickMarkStrategy()
        self.isCircularMode = isCircularMode
        super.init()
        self.frame = CGRect(x: 0, y: 0, width: arcRadius * 2, height: arcRadius * 2)
        drawTicks(arcRadius: arcRadius, arcCenter: arcCenter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawTicks(arcRadius: CGFloat, arcCenter: CGPoint) {
        tickMarkGroup.removeAllTickMarks()
        let (outerRadius, innerRadius) = strategy.calculateTickRadius(arcDiameter: arcRadius, tickMarkLength: TickMarkConstants.markLength)
        
        let tickConfig = TickMarkConfiguration(
            arcCenter: arcCenter,
            outerTickRadius: outerRadius,
            innerTickRadius: innerRadius,
            tickMarkLength: TickMarkConstants.markLength,
            tickMarkThickness: isCircularMode ? 1.5 : TickMarkConstants.markThickness,
            useCircle: isCircularMode
        )
        
        let tickMarks = TickMarkBuilder(config: tickConfig).build()
        tickMarks.forEach { tickMarkGroup.addTickMark($0) }
        
        addSublayer(tickMarkGroup)
        setNeedsDisplay()
    }
    
    func updateTickMarkVisibility(from startRadian: CGFloat, to endRadian: CGFloat, isCircularMode: Bool = false) {
        let twoPi = 2 * CGFloat.pi
        guard let tickLayers = tickMarkGroup.sublayers as? [CAShapeLayer] else { return }
        
        for (index, layer) in tickLayers.enumerated() {
            let angle = CGFloat(index) * twoPi / CGFloat(tickLayers.count)
            let normalizedStart = MathUtils.shared.normalizeAngle(startRadian)
            let normalizedEnd = MathUtils.shared.normalizeAngle(endRadian)
            let isVisible = MathUtils.shared.isRadianInRange(angle, from: normalizedStart, to: normalizedEnd)
            
            layer.isHidden = !isVisible
        }
        setNeedsDisplay()
    }
}

