//
//  TextLayer.swift
//  CircleControl
//
//  Created by Grigory G. on 04.07.22.
//

import UIKit

final class TextLayer: CATextLayer {
    
    init(frame: CGRect = CGRect(origin: .zero, size: CGSize(width: 64, height: 24)),
         text: String = "Sleep Duration",
         fontSize: CGFloat = 22,
         color: CGColor = UIColor.mustardYellow.cgColor,
         alignmentMode: CATextLayerAlignmentMode = .left
    ) {
        super.init()
        
        self.frame = frame
        self.string = text
        self.fontSize = fontSize
        self.font = ThemeManager.Font.monospaced(size: fontSize)
        self.foregroundColor = color
        self.alignmentMode = alignmentMode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
