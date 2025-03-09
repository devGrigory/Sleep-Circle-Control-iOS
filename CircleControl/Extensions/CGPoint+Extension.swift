//
//  CGPoint+Extension.swift
//  CircleControl
//
//  Created by Grigory G. on 03.07.22.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}
