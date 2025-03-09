//
//  TickMarkLayerFactory.swift
//  CircleControl
//
//  Created by Grigory G. on 10.07.22.
//

import UIKit

// MARK: - Factory for Tick Mark Layer Creation
final class TickMarkLayerFactory {
    static func createTickMarkLayer(from startPoint: CGPoint, to endPoint: CGPoint, thickness: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let tickMarkLayer = CAShapeLayer()
        tickMarkLayer.path = path.cgPath
        tickMarkLayer.lineWidth = thickness
        tickMarkLayer.strokeColor = UIColor.gray.cgColor
        tickMarkLayer.name = "tickMarkLayer"
        
        return tickMarkLayer
    }
    
    static func createCircleLayer(at point: CGPoint, radius: CGFloat, color: UIColor) -> CAShapeLayer {
        let circlePath = UIBezierPath(ovalIn: CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = color.cgColor
        circleLayer.name = "circleLayer"
        
        return circleLayer
    }
}
