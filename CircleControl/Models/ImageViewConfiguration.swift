//
//  ImageViewConfiguration.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

struct ImageViewConfiguration {
    var image: UIImage
    var tintColor: UIColor
    var frameSize: CGSize
    
    init() {
        self.image = UIImage()
        self.tintColor = .black
        self.frameSize = .zero
    }
}
