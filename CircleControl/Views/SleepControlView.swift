//
//  SleepControlView.swift
//  CircleControl
//
//  Created by Grigory G. on 03.07.22.
//

import SnapKit
import UIKit

protocol SleepControlLayerConfigurable {
    /// Adds a image view to the sleep control view.
    func setupIconStackViews()
    /// Adds a text layer to the sleep control view.
    func setupTextLayers()
    /// Configures sleep control layers within the given view.
    func configureSleepControlView(for schedule: SleepSchedule)
    /// Updates the content of an existing text layer.
    func animateTextUpdate(_ layer: CATextLayer?, with text: String)
    /// Update labels via the delegate
    func updateLabels(with sleepSchedule: SleepSchedule)
}

protocol AlarmTimeSliderDelegate: AnyObject {
    func alarmTimeSliderDidLayoutSubviews()
    func alarmTimeSlider(didUpdateBedtime newBedtime: Time, andWakeUpTime newWakeUpTime: Time)
}

final class SleepControlView: UIView {
    struct SleepControlLayout {
        ///Margins & Offsets
        struct Margins {
            static let bottomOffset: CGFloat = 30
            static let scheduleIconTopMargin: CGFloat = 20
            static let timeTableTextTopMargin: CGFloat = 50
        }
        ///Icon & Text Sizes
        struct Sizes {
            static let imageSize: CGSize = CGSize(width: 24, height: 24)
            static let fontSize: CGFloat = 16
            static let textLayerSize: CGSize = CGSize(width: 64, height: 24)
            static let titleSize: CGSize = CGSize(width: 115, height: 24)
            static let durationSize: CGSize = CGSize(width: 154, height: 24)
        }
        
        static let origin: CGPoint = .zero
    }
    
    // MARK: - Public Properties
    /// The outer radius of the SleepControlView.
    let outerRadius: CGFloat
    /// Represents the selected bedtime in the alarm slider.
    var bedTime: Time?
    /// Represents the selected wake-up time in the alarm slider.
    var wakeUpTime: Time?
    
    // MARK: - Private Properties
    /// Current sleep schedule, including bedtime and wake-up time.
    private var schedule: SleepSchedule?
    
    // MARK: - UI Components
    private lazy var clockFace: AnalogClockFaceView = {
        let view = AnalogClockFaceView(frame: .zero,
                                       radius: outerRadius - outerRadius/7.6)
        return view
    }()
    
    private lazy var alarmSliderView: AlarmCircularSliderView = {
        let view = AlarmCircularSliderView(radius: outerRadius - outerRadius/7.6)
        return view
    }()
    
    private let timeTableIconsStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = UIConstants.sleepControlViewSize * 0.35
        
        return $0
    }(UIStackView())
    
    private let timeTableTextStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = UIConstants.sleepControlViewSize * 0.4
        
        return $0
    }(UIStackView())
    
    private let scheduleIconsStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = UIConstants.sleepControlViewSize * 0.5
        
        return $0
    }(UIStackView())
    
    private let sleepDurationTextStackView: UIStackView = {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillEqually
        
        return $0
    }(UIStackView())
    
    private var bedTimeLayer: TextLayer?
    private var wakeUpTimeLayer: TextLayer?
    private var sleepDurationLayer: TextLayer?
    private var sleepDurationTitleLayer: TextLayer?
    
    // MARK: - Initializers
    init(frame: CGRect, outerRadius: CGFloat) {
        self.outerRadius = outerRadius
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        setupTextLayers()
    }
    
    private func setupView() {
        setupDelegates()
        addUIElements()
        setupIconStackViews()
        applyLayoutConstraints()
        configureUIElements()
    }
    
    // MARK: - Private Methods
    private func setupDelegates() {
        alarmSliderView.delegate = self
    }
    
    private func addUIElements() {
        self.addSubview(clockFace)
        self.addSubview(alarmSliderView)
        self.addSubview(scheduleIconsStackView)
        self.addSubview(timeTableTextStackView)
        self.addSubview(timeTableIconsStackView)
        self.addSubview(sleepDurationTextStackView)
    }
    
    private func applyLayoutConstraints() {
        clockFace.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        alarmSliderView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        scheduleIconsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SleepControlLayout.Margins.scheduleIconTopMargin)
        }
        
        timeTableTextStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SleepControlLayout.Margins.timeTableTextTopMargin)
        }
        
        timeTableIconsStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        sleepDurationTextStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-SleepControlLayout.Margins.bottomOffset)
        }
    }
    
    private func configureUIElements() {
        clockFace.backgroundColor = ThemeManager.Color.midnightGrayColor
    }
    
    /// Helper function to create a container view for a text layer and add it to the specified stack view.
    private func createTextLayerContainer(size: CGSize, color: CGColor? = nil, fontSize: CGFloat? = nil, in stackView: UIStackView) -> TextLayer {
        let textLayer = fontSize != nil ? TextLayer(frame: CGRect(origin: SleepControlLayout.origin, size: size), fontSize: fontSize ?? 0) : TextLayer(frame: CGRect(origin: SleepControlLayout.origin, size: size), color: color ?? UIColor.white.cgColor)
        
        let containerView = UIView()
        containerView.layer.addSublayer(textLayer)
        stackView.addArrangedSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(size.height)
            make.width.greaterThanOrEqualTo(size.width)
        }
        
        return textLayer
    }
    
    private func setupSlider(from bedTime: Time?, to wakeUpTime: Time?) {
        guard let bedTime = bedTime,
              let wakeUpTime = wakeUpTime else { return }
        let radianRange = MathUtils.shared.calculateRadianRange(from: bedTime, to: wakeUpTime)
        if MathUtils.shared.isRadianRangeValid(radianRange) {
            layoutSlider(from: bedTime, to: wakeUpTime)
        }
    }
    
    //MARK: - Set initial date
    private func layoutSlider(from bedTime: Time, to wakeUpTime: Time) {
        /// Calculate radians for bedTime and wakeUpTime
        let bedTimeRadian = TimeUtils.shared.calculateRadian(for: bedTime.floatValue)
        let wakeUpTimeRadian = TimeUtils.shared.calculateRadian(for: wakeUpTime.floatValue)
        /// Update the slider's active range with the calculated radians
        alarmSliderView.updateActiveRange(from: bedTimeRadian, to: wakeUpTimeRadian)
    }
    
    private func updateTimeData(from bedTime: Time, to wakeUpTime: Time) {
        schedule = SleepSchedule(bedtime: bedTime, wakeUpTime: wakeUpTime)
        /// Update labels via the delegate
        guard let schedule = schedule else { return }
        updateLabels(with: schedule)
    }
}

//MARK: - LayerConfigurable Methods
extension SleepControlView: SleepControlLayerConfigurable {
    func setupIconStackViews() {
        let scheduleBedImageView = ImageViewBuilder()
            .setImage(ThemeManager.Image.bedIcon)
            .setTintColor(.vividSky)
            .setFrameSize(SleepControlLayout.Sizes.imageSize)
            .build()
        let scheduleWakeupImageView = ImageViewBuilder()
            .setImage(ThemeManager.Image.alarmClockIcon)
            .setTintColor(.mustardYellow)
            .setFrameSize(SleepControlLayout.Sizes.imageSize)
            .build()
        scheduleIconsStackView.addArrangedSubview(scheduleBedImageView)
        scheduleIconsStackView.addArrangedSubview(scheduleWakeupImageView)
        
        let timeTableBedImageView = ImageViewBuilder()
            .setImage(ThemeManager.Image.sparkles)
            .setTintColor(.vividSky)
            .setFrameSize(SleepControlLayout.Sizes.imageSize)
            .build()
        let timeTableWakeupImageView = ImageViewBuilder()
            .setImage(ThemeManager.Image.alarmClockIcon)
            .setTintColor(.mustardYellow)
            .setFrameSize(SleepControlLayout.Sizes.imageSize)
            .build()
        timeTableIconsStackView.addArrangedSubview(timeTableBedImageView)
        timeTableIconsStackView.addArrangedSubview(timeTableWakeupImageView)
    }
    
    func setupTextLayers() {
        bedTimeLayer = bedTimeLayer ?? createTextLayerContainer(size: SleepControlLayout.Sizes.textLayerSize, color: ThemeManager.Color.whiteColor.cgColor, in: timeTableTextStackView)
        
        wakeUpTimeLayer = wakeUpTimeLayer ?? createTextLayerContainer(size: SleepControlLayout.Sizes.textLayerSize, color: ThemeManager.Color.whiteColor.cgColor, in: timeTableTextStackView)
        
        sleepDurationTitleLayer = sleepDurationTitleLayer ?? createTextLayerContainer(size: SleepControlLayout.Sizes.titleSize, fontSize: SleepControlLayout.Sizes.fontSize, in: sleepDurationTextStackView)
        
        sleepDurationLayer = sleepDurationLayer ?? createTextLayerContainer(size: SleepControlLayout.Sizes.durationSize, color: ThemeManager.Color.whiteColor.cgColor, in: sleepDurationTextStackView)
    }
    
    func configureSleepControlView(for schedule: SleepSchedule) {
        bedTime = schedule.getBedtime()
        wakeUpTime = schedule.getWakeUpTime()
    }
    
    // MARK: - Helper Methods
    internal func animateTextUpdate(_ layer: CATextLayer?, with text: String) {
        guard let layer = layer else { return }
        
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(transition, forKey: "fadeTransition")
        layer.string = text
    }
    
    func updateLabels(with sleepSchedule: SleepSchedule) {
        animateTextUpdate(bedTimeLayer, with: sleepSchedule.getBedtime().formattedTime())
        animateTextUpdate(wakeUpTimeLayer, with: sleepSchedule.getWakeUpTime().formattedTime())
        animateTextUpdate(sleepDurationLayer, with: sleepSchedule.getSleepDuration().formattedDuration())
    }
}

// MARK: - AlarmTimeRoundSliderViewDelegate
extension SleepControlView: AlarmTimeSliderDelegate {
    func alarmTimeSliderDidLayoutSubviews() {
        setupSlider(from: bedTime, to: wakeUpTime)
    }
    
    func alarmTimeSlider(didUpdateBedtime newBedtime: Time, andWakeUpTime newWakeUpTime: Time) {
        updateTimeData(from: newBedtime, to: newWakeUpTime)
    }
}
