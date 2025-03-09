//
//  ArcLayerBuilder.swift
//  CircleControl
//
//  Created by Grigory G. on 02.07.22.
//

import UIKit

protocol ArcDrawingServiceProtocol {
    func clearContext(_ context: CGContext, in rect: CGRect)
    func configureArcLayer(_ layer: CAShapeLayer, with config: ArcConfiguration)
}

/// Builder Class for Arc Layer
final class ArcLayerBuilder: ArcDrawingServiceProtocol {
    private var path: UIBezierPath?
    private var layer: CAShapeLayer?
    private var config: ArcConfiguration?
    
    /// Step 1: Create the Arc Path
    func createPath(center: CGPoint, radius: CGFloat, startAngle: CGFloat = 0, endAngle: CGFloat = .pi * 2, clockwise: Bool = true) -> ArcLayerBuilder {
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        return self
    }
    
    /// Step 2: Create the Arc Layer (without configuration)
    func createLayer(lineWidth: CGFloat = 1.0, strokeColor: CGColor = ThemeManager.Color.cloudGrayColor.cgColor) -> ArcLayerBuilder {
        guard let path = self.path else {
            return self /// Prevent crash instead of using fatalError
        }
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.lineWidth = lineWidth
        layer.strokeColor = strokeColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        self.layer = layer
        return self
    }
    
    /// Step 3: Apply Configuration
    func applyConfig(_ config: ArcConfiguration) -> ArcLayerBuilder {
        self.config = config
        return self
    }
    
    /// Finalize and get the Result
    func build() -> (path: UIBezierPath?, layer: CAShapeLayer?) {
        return (self.path, self.layer)
    }
    
    /// Clears a drawing context
    func clearContext(_ context: CGContext, in rect: CGRect) {
        context.clear(rect)
    }
    
    /// Configures an existing CAShapeLayer
    func configureArcLayer(_ layer: CAShapeLayer, with config: ArcConfiguration) {
        self.config = config
        layer.path = config.path.cgPath
        layer.strokeColor = config.strokeColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = config.width
        layer.lineCap = .round
        layer.frame = CGRect(
            x: config.center.x - config.radius,
            y: config.center.y - config.radius,
            width: config.radius * 2,
            height: config.radius * 2
        )
        layer.isHidden = false
    }
}

