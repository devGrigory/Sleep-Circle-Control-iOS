//
//  AlarmTimeRoundSliderView.swift
//  CircleControl
//
//  Created by Grigory G. on 03.07.22.
//

import UIKit

final class AlarmCircularSliderView: UIView {
    // MARK: - Constants
    private struct Constants {
        static let arcWidthFactor: CGFloat = 3.8
        static let imageSize: CGSize = CGSize(width: 17, height: 17)
        static let handleOffset: CGFloat = 8.5
        static let slidingArcWidthOffset: CGFloat = 5
    }
    
    // MARK: - Properties
    /// Total diameter of the circular track and the selected portion.
    private var arcRadius: CGFloat
    /// Represents the width of both the base and active arcs, which defines the circular track
    private var arcWidth: CGFloat
    /// Represents the center point of both the base and active arcs.
    private var arcCenter: CGPoint
    /// Represents the diameter of the touchable circles (handles) at the start and end of the slider.
    private var handleDiameter: CGFloat
    /// Represents the arc path for the active (selected) portion of the circle.
    private var slidingArcLayer: CAShapeLayer?
    /// Represents the touchable circle at the start of the selected slider.
    private var bedtimeHandlePath: UIBezierPath?
    /// Represents the touchable circle at the end of the selected slider.
    private var wakeUpHandlePath: UIBezierPath?
    /// The radian value of the start circle (sleep state) on the slider.
    private var bedtimeHandleRadian: CGFloat?
    /// The radian value of the end circle (wake-up state) on the slider.
    private var wakeUpHandleRadian: CGFloat?
    private var timeUtils: TimeUtils
    /// Service responsible for rendering arc.
    private let sliderDrawingBuilder: ArcDrawingServiceProtocol
    /// Manages the positioning and rendering of tick marks on the clock face.
    private var tickMarkLayer: TickMarkRenderer?
    /// Stores the last recorded radian value of the clock handle to track its position changes.
    private var lastHandleRadian: CGFloat?
    /// Flag to ensure the view is initialized only once to prevent redundant setup.
    private var isInitialized = false
    /// Image view displayed at the start of the slider, representing the sleep portion.
    private lazy var bedtimeHandleImageView: UIImageView = {
        let imageView = UIImageView(image: ThemeManager.Image.bedIcon)
        imageView.frame.size = Constants.imageSize
        imageView.tintColor = .vividSky
        return imageView
    }()
    /// Image view displayed at the end of the slider, representing the wake-up portion.
    private lazy var wakeUpHandleImageView: UIImageView = {
        let imageView = UIImageView(image: ThemeManager.Image.alarmClockIcon)
        imageView.frame.size = Constants.imageSize
        imageView.tintColor = .mustardYellow
        return imageView
    }()
    /// Update Labes
    weak var delegate: AlarmTimeSliderDelegate?
    /// Defines a typealias for handle information, associating a `UIBezierPath` with its corresponding `HandleType`.
    private typealias HandleInfo = (path: UIBezierPath, type: HandleType)
    
    // MARK: - Initializers
    init(radius: CGFloat,
         drawingBuilder: ArcDrawingServiceProtocol = ArcLayerBuilder(),
         timeUtils: TimeUtils = TimeUtils()) {
        self.arcRadius = radius
        self.arcWidth = radius/Constants.arcWidthFactor
        self.handleDiameter = self.arcWidth - 1.0
        self.sliderDrawingBuilder = drawingBuilder
        self.arcCenter = .zero  ///updated in `initializeArcPath()`
        self.timeUtils = timeUtils
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.arcRadius = 150
        self.arcWidth = arcRadius / Constants.arcWidthFactor
        self.handleDiameter = self.arcWidth - 1.0
        self.sliderDrawingBuilder = ArcLayerBuilder()
        self.arcCenter = .zero  /// updated in `initializeArcPath()`
        self.timeUtils = TimeUtils()
        super.init(coder: coder)
    }
    
    //MARK: - Օverride Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        initializeIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        sliderDrawingBuilder.clearContext(context, in: bounds)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first?.location(in: self) else { return }
        /// Calculates the touch position relative to the arc center
        /// and determines which handle (bedtime or wake-up) was touched.
        updateSliderWithTouch(at: touch)
    }
    
    // MARK: - Initialization Method
    private func initializeIfNeeded() {
        if arcCenter == .zero { initializeArcPath() }  /// Prevents re-initialization
        ///Method helps maintain the correct visual representation
        ///   of the slider when the view's layout is updated.
        delegate?.alarmTimeSliderDidLayoutSubviews()
        isInitialized = true
    }
    
    // MARK: - Arc Path Setup
    private func initializeArcPath() {
        configureView()
        /// Updates the center point of the arc based on the view’s bounds.
        updateArcCenter()
        
        let pathBuilder = ArcLayerBuilder()
        guard let baseArcPath = pathBuilder
            .createPath(center: arcCenter, radius: arcRadius)
            .build().path else { return }
        
        let baseArcLayer = CAShapeLayer(
            path: baseArcPath,
            lineWidth: arcWidth + Constants.slidingArcWidthOffset,
            strokeColor: ThemeManager.Color.slateGrayColor.cgColor
        )
        layer.addSublayer(baseArcLayer)
    }
    
    // MARK: - Helper Methods
    private func configureView() {
        backgroundColor = .clear
    }
    
    private func updateArcCenter() {
        arcCenter = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    let mathUtils = MathUtils()
    // MARK: - Public Method
    public func updateActiveRange(from startRadian: CGFloat, to endRadian: CGFloat) {
        let startPoint = mathUtils.pointOnCircle(
            at: startRadian,
            withRadius: arcRadius,
            relativeTo: arcCenter
        )
        let endPoint = mathUtils.pointOnCircle(
            at: endRadian,
            withRadius: arcRadius,
            relativeTo: arcCenter
        )
        
        ensureSlidingArcLayerExists()
        /// Updates the active arc layer by redrawing it with a new arc path.
        updateArcLayer(from: startRadian, to: endRadian)
        /// Configures the touch circle for a given handle (bedtime or wake-up).
        configureStartTouchCircle(at: startPoint)
        configureEndTouchCircle(at: endPoint)
        
        /// Create and configure the tick mark layer with the given arc properties
        tickMarkLayer = TickMarkRenderer(
            displayFrom: startRadian,
            to: endRadian,
            arcRadius: arcRadius,
            arcCenter: arcCenter,
            isCircularMode: false
        )
        tickMarkLayer?.updateTickMarkVisibility(from: startRadian, to: endRadian)
        guard let tickMarkLayer = tickMarkLayer else { return }
        layer.addSublayer(tickMarkLayer)
        /// Updates the radian values for `bedtime` and `wake-up` time handles.
        updateHandleRadians(startFrom: startRadian, to: endRadian)
    }
    
    // MARK: - Arc Layer Management
    private func ensureSlidingArcLayerExists() {
        guard slidingArcLayer == nil else { return }
        slidingArcLayer = CAShapeLayer()
        guard let slidingArcLayer = slidingArcLayer else { return }
        layer.addSublayer(slidingArcLayer)
    }
    
    private func updateArcLayer(
        from startRadian: CGFloat,
        to endRadian: CGFloat,
        clockwise: Bool = true
    ) {
        guard let slidingArcLayer else { return }
        let center = CGPoint(x: arcRadius, y: arcRadius)
        
        let pathBuilder = ArcLayerBuilder()
        guard let slidingArcPath = pathBuilder
            .createPath(center: center, radius: arcRadius, startAngle: startRadian, endAngle: endRadian, clockwise: clockwise)
            .build().path else { return }
        /// Sets up the arc layer by applying the given path, colors, width, and frame.
        /// It ensures the arc is properly positioned and visible.
        let arcConfig = ArcConfiguration(
            path: slidingArcPath,
            center: arcCenter,
            radius: arcRadius,
            width: arcWidth
        )
        sliderDrawingBuilder.configureArcLayer(slidingArcLayer, with: arcConfig)
    }
    
    // MARK: - Handle Updates
    private func updateHandleRadians(startFrom startRadian: CGFloat, to endRadian: CGFloat) {
        bedtimeHandleRadian = startRadian
        wakeUpHandleRadian = endRadian
        
        let bedTimeString = timeUtils.timeFromRadians(startRadian)
        let wakeUpTimeString = timeUtils.timeFromRadians(endRadian)
        
        guard let bedTime = timeUtils.extractTime(from: bedTimeString),
              let wakeUpTime = timeUtils.extractTime(from: wakeUpTimeString) else { return }
        
        delegate?.alarmTimeSlider(didUpdateBedtime: bedTime, andWakeUpTime: wakeUpTime)
    }
    
    // MARK: - Handle User Interaction
    private func updateSliderWithTouch(at touchPoint: CGPoint) {
        let touchCirclePoint = mathUtils.getCirclePoint(from: touchPoint, relativeTo: arcCenter, arcRadius: arcRadius)
        /// Determines which handle` (bedtime or wake-up)` was touched.
        guard let touchedHandle = getTouchedHandle(at: touchCirclePoint) else { return }
        let touchRadian = mathUtils.calculateTouchRadian(from: touchCirclePoint, relativeTo: arcCenter)
        
        processHandleTouch(touchedHandle, radian: touchRadian, touchPoint: touchCirclePoint)
    }
    
    // MARK: - Touch Handling
    private func processHandleTouch(_ handle: HandleType, radian: CGFloat, touchPoint: CGPoint) {
        switch handle {
        case .bedtime:
            handleStartCircleTouch(for: radian, touchPoint: touchPoint)
        case .wakeUp:
            handleEndCircleTouch(for: radian, touchPoint: touchPoint)
        }
    }
    
    // MARK: - Handle Start Circle Touch
    private func handleStartCircleTouch(for currentRadian: CGFloat, touchPoint: CGPoint) {
        guard let bedtimeRadian = bedtimeHandleRadian,
              let wakeUpRadian = wakeUpHandleRadian else { return }
        
        lastHandleRadian = bedtimeRadian
        guard let lastHandleRadian = lastHandleRadian else { return }
        
        let minAngleDifference = mathUtils.angularDifference(from: wakeUpRadian, to: currentRadian)
        let maxAngleDifference = mathUtils.clockwiseDifference(from: bedtimeRadian, to: wakeUpRadian)
        let isClockwise = mathUtils.isClockwise(from: lastHandleRadian, to: currentRadian)
        
        if  minAngleDifference < AlarmConstants.minAllowedSleepAngle {
            /// Adjusts the position of the specified handle (bedtime or wake-up) while ensuring minimum allowed distance.
            adjustHandlePosition(
                handle: .wakeUp,
                currentRadian: currentRadian,
                touchPoint: touchPoint,
                minAllowedDistance: AlarmConstants.minAllowedSleepAngle
            )
            return
        }
        
        if maxAngleDifference >= AlarmConstants.maxSleepAngle && !isClockwise {
            /// Adjusts the position of the specified handle (bedtime or wake-up) while ensuring minimum allowed distance.
            adjustHandlePosition(
                handle: .wakeUp,
                currentRadian: currentRadian,
                touchPoint: touchPoint,
                minAllowedDistance: AlarmConstants.maxAllowedSleepAngle
            )
            return
        }
        updateTouchCirclePosition(using: configureStartTouchCircle, fallbackTo: touchPoint)
        moveTouchCircle(for: .bedtime, to: currentRadian, clockwise: true)
    }
    
    // MARK: - Handle End Circle Touch
    private func handleEndCircleTouch(for currentRadian: CGFloat, touchPoint: CGPoint) {
        guard let bedtimeRadian = bedtimeHandleRadian,
              let wakeUpRadian = wakeUpHandleRadian else { return }
        
        lastHandleRadian = wakeUpRadian
        guard let lastHandleRadian = lastHandleRadian else { return }
        
        let minAngleDifference = mathUtils.angularDifference(from: bedtimeRadian, to: currentRadian)
        let maxAngleDifference = mathUtils.clockwiseDifference(from: bedtimeRadian, to: wakeUpRadian)
        let isClockwise = mathUtils.isClockwise(from: lastHandleRadian, to: currentRadian)
        
        if minAngleDifference < AlarmConstants.minAllowedSleepAngle {
            /// Adjusts the position of the specified handle (bedtime or wake-up) while ensuring minimum allowed distance.
            adjustHandlePosition(
                handle: .bedtime,
                currentRadian: currentRadian,
                touchPoint: touchPoint,
                minAllowedDistance: AlarmConstants.minAllowedSleepAngle
            )
            return
        }
        
        if maxAngleDifference >= AlarmConstants.maxSleepAngle && isClockwise {
            /// Adjusts the position of the specified handle (bedtime or wake-up) while ensuring minimum allowed distance.
            adjustHandlePosition(
                handle: .bedtime,
                currentRadian: currentRadian,
                touchPoint: touchPoint,
                minAllowedDistance: AlarmConstants.maxAllowedSleepAngle
            )
            return
        }
        updateTouchCirclePosition(using: configureEndTouchCircle, fallbackTo: touchPoint)
        moveTouchCircle(for: .wakeUp, to: currentRadian, clockwise: true)
    }
    
    // MARK: - Handle Adjustments
    private func adjustHandlePosition(
        handle: HandleType,
        currentRadian: CGFloat,
        touchPoint: CGPoint,
        minAllowedDistance: CGFloat
    ) {
        guard let lastHandleRadian = lastHandleRadian else { return }
        let adjustedRadian = mathUtils.calculateNewStartRadian(from: currentRadian, with: minAllowedDistance, lastHandleRadian: lastHandleRadian)
        
        switch handle {
        case .bedtime:
            bedtimeHandleRadian = adjustedRadian
            /// Updates the position of a touch circle, either based on a given radian or a fallback point.
            updateTouchCirclePosition(using: configureStartTouchCircle, for: adjustedRadian, fallbackTo: touchPoint)
            /// Updates the position of a touch circle, either based on a given radian or a fallback point.
            updateTouchCirclePosition(using: configureEndTouchCircle, fallbackTo: touchPoint)
            moveTouchCircle(for: .wakeUp, from: adjustedRadian, to: currentRadian, clockwise: false)
            
        case .wakeUp:
            wakeUpHandleRadian = adjustedRadian
            /// Updates the position of a touch circle, either based on a given radian or a fallback point.
            updateTouchCirclePosition(using: configureStartTouchCircle, fallbackTo: touchPoint)
            /// Updates the position of a touch circle, either based on a given radian or a fallback point.
            updateTouchCirclePosition(using: configureEndTouchCircle, for: adjustedRadian, fallbackTo: touchPoint)
            moveTouchCircle(for: .bedtime, from: adjustedRadian, to: currentRadian, clockwise: false)
        }
    }
    
    // MARK: - Touch Circle Updates
    private func updateTouchCirclePosition(
        using configureTouchCircle: (CGPoint) -> Void,
        for radian: CGFloat? = nil,
        fallbackTo fallbackPoint: CGPoint
    ) {
        /// Determines the target point on the circle based on the given radian.
        let targetPoint = radian.map { mathUtils.pointOnCircle(at: $0, withRadius: arcRadius, relativeTo: arcCenter) } ?? fallbackPoint
        /// Configures the touch circle for the specified handle at a given point.
        configureTouchCircle(targetPoint)
    }
    
    // MARK: - Configure Touch Circles
    private func configureStartTouchCircle(at point: CGPoint) {
        /// Configures start touch circle for the specified handle at a given point.
        configureTouchCircle(for: .bedtime, at: point)
    }
    
    private func configureEndTouchCircle(at point: CGPoint) {
        /// Configures end touch circle for the specified handle at a given point.
        configureTouchCircle(for: .wakeUp, at: point)
    }
    
    /// Configures end touch circle for the specified handle at a given point.
    private func configureTouchCircle(for handle: HandleType, at point: CGPoint) {
        let twoPi = CGFloat.pi * 2
        let pathBuilder = ArcLayerBuilder()
        guard let newPath = pathBuilder
            .createPath(center: point, radius: handleDiameter / 2, startAngle: 0, endAngle: twoPi, clockwise: true)
            .build().path else { return }
        
        switch handle {
        case .bedtime:
            bedtimeHandlePath = newPath
        case .wakeUp:
            wakeUpHandlePath = newPath
        }
        /// Updates the position of the handle image view for the specified handle.
        updateHandleImageView(for: handle, at: point)
    }
    
    /// Updates the position of the handle image view for the specified handle.
    private func updateHandleImageView(for handle: HandleType, at point: CGPoint) {
        let offset: CGFloat = Constants.handleOffset
        let imageView: UIImageView
        
        switch handle {
        case .bedtime:
            imageView = bedtimeHandleImageView
            if !subviews.contains(imageView) { addSubview(imageView) }
            
        case .wakeUp:
            imageView = wakeUpHandleImageView
            if !subviews.contains(imageView) { addSubview(imageView) }
        }
        /// - Moves the frame's origin left and up by the specified `offset` value.
        imageView.frame.origin = point.offsetBy(dx: -offset, dy: -offset)
    }
    
    private func moveTouchCircle(
        for handle: HandleType,
        from startRadian: CGFloat = 0.0,
        to endRadian: CGFloat,
        clockwise: Bool
    ) {
        guard let startAngle = calculateStartAngle(for: handle, from: startRadian, clockwise: clockwise) else { return }
        let pathClockwise = (handle == .wakeUp)
        
        ensureSlidingArcLayerExists()
        updateArcLayer(from: startAngle, to: endRadian, clockwise: pathClockwise)
        
        updateTickMarkVisibility(for: handle, startAngle: startAngle, endAngle: endRadian)
        updateHandleRadian(for: handle, with: endRadian)
        
        let startAngleForDelegate = (handle == .bedtime && clockwise) ? wakeUpHandleRadian ?? startRadian : startAngle
        
        let fromAngle = (handle == .bedtime) ? endRadian : startAngleForDelegate
        let toAngle = (handle == .bedtime) ? startAngleForDelegate : endRadian
        /// Notifies the delegate with the updated bedtime and wake-up time.
        notifyDelegateWithTimes(from: fromAngle, to: toAngle)
    }
    
    /// Notifies the delegate with the updated bedtime and wake-up time.
    private func notifyDelegateWithTimes(from fromAngle: CGFloat, to toAngle: CGFloat) {
        let bedTimeString = timeUtils.timeFromRadians(fromAngle)
        let wakeUpTimeString = timeUtils.timeFromRadians(toAngle)
        
        guard let bedTime = timeUtils.extractTime(from: bedTimeString),
              let wakeUpTime = timeUtils.extractTime(from: wakeUpTimeString) else { return }
        
        delegate?.alarmTimeSlider(didUpdateBedtime: bedTime, andWakeUpTime: wakeUpTime)
    }
    
    /// Calculates the start angle for a given handle.
    private func calculateStartAngle(
        for handle: HandleType,
        from startRadian: CGFloat,
        clockwise: Bool
    ) -> CGFloat? {
        switch handle {
        case .bedtime:
            return clockwise ? (wakeUpHandleRadian ?? startRadian) - 2 * .pi : startRadian
        case .wakeUp:
            return clockwise ? (bedtimeHandleRadian ?? startRadian) : startRadian
        }
    }
    
    private func updateTickMarkVisibility(
        for handle: HandleType,
        startAngle: CGFloat,
        endAngle: CGFloat
    ) {
        let hideFrom = (handle == .bedtime) ? endAngle : startAngle
        let hideTo = (handle == .bedtime) ? startAngle : endAngle
        tickMarkLayer?.updateTickMarkVisibility(from: hideFrom, to: hideTo)
    }
    
    private func updateHandleRadian(for handle: HandleType, with radian: CGFloat) {
        lastHandleRadian = radian
        if handle == .bedtime {
            bedtimeHandleRadian = radian
        } else {
            wakeUpHandleRadian = radian
        }
    }
    
    /// Determines which handle (bedtime or wake-up) was touched.
    private func getTouchedHandle(at point: CGPoint) -> HandleType? {
        let handles: [HandleInfo] = [(bedtimeHandlePath, .bedtime), (wakeUpHandlePath, .wakeUp)].compactMap { handle, type -> HandleInfo? in
            guard let handle = handle else { return nil }
            return (handle, type)
        }
        return handles.first { $0.0.contains(point) }?.1
    }
}
