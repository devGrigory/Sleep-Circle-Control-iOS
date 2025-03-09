//
//  AnalogClockFaceView.swift
//  CircleControl
//
//  Created by Grigory G. on 04.07.22.
//

import UIKit

final class AnalogClockFaceView: UIView {
    private struct LayoutConstants {
        static let padding: CGFloat = 15
        static let dimensionFactor: CGFloat = 3.5
    }
    
    // MARK: - Properties
    private var clockRadius: CGFloat?
    private var clockCenter: CGPoint = .zero
    
    // MARK: - Dependencies
    private let clockRenderer: ClockFaceRenderer
    
    // MARK: - Initialization
    init(
        frame: CGRect,
        radius: CGFloat? = nil,
        renderer: ClockFaceRenderer = DefaultClockFaceRenderer()
    ) {
        self.clockRadius = radius
        self.clockRenderer = renderer
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func draw(_ rect: CGRect) {
        guard let clockRadius else { return }
        clockRenderer.drawClockFace(in: layer, radius: clockRadius, center: clockCenter)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateClockCenter()
    }
    
    // MARK: - Private Methods
    private func updateClockCenter() {
        clockCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let halfWidth = bounds.width / 2
        clockRadius = ((bounds.width - LayoutConstants.padding) / 2) - (halfWidth / LayoutConstants.dimensionFactor)
    }
}
