//
//  ArcConfiguration.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

struct ArcConfiguration {
    let path: UIBezierPath
    let center: CGPoint
    let radius: CGFloat
    let width: CGFloat
    let strokeColor: CGColor = ThemeManager.Color.midnightGrayColor.cgColor
}
