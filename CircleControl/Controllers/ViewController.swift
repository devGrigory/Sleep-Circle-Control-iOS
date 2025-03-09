//
//  ViewController.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: - Layout Constants
    private struct UIStylingConstants {
        static let cornerRadius: CGFloat = 16
    }
    
    private struct TimeConstants {
        static let defaultBedTime = Time(hour: 23, minute: 29)
        static let defaultWakeUpTime = Time(hour: 08, minute: 29)
    }
    
    // MARK: - Properties
    private let theme: ThemeManager
    private var sleepSchedule: SleepSchedule {
        SleepSchedule(bedtime: TimeConstants.defaultBedTime, wakeUpTime: TimeConstants.defaultWakeUpTime)
    }
    
    // MARK: - UI Components
    private let sleepControlView: SleepControlView = {
        let view = SleepControlView(frame: .zero,
                                    outerRadius: UIConstants.sleepControlViewSize / 2 - 10
        )
        return view
    }()
    
    // MARK: - Initialization
    init(theme: ThemeManager = .shared) {
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUIElements()
        applyLayoutConstraints()
        setupBackground()
        sleepControlView.configureSleepControlView(for: sleepSchedule)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayers()
    }
    
    // MARK: - Layout & Constraints
    private func addUIElements() {
        view.addSubview(sleepControlView)
    }
    
    private func applyLayoutConstraints() {
        sleepControlView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(UIConstants.sleepControlViewSize)
            make.height.equalTo(UIConstants.sleepControlViewSize * 1.5)
        }
    }
    
    // MARK: - UI Setup
    private func setupBackground() {
        view.backgroundColor = ThemeManager.Color.frostGrayColor
    }
    
    // MARK: - Layer Setup
    private func setupLayers() {
        sleepControlView.layer.cornerRadius = UIStylingConstants.cornerRadius
        sleepControlView.layer.masksToBounds = true
    }
}
