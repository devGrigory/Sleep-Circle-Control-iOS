//
//  ImageViewBuilder.swift
//  CircleControl
//
//  Created by Grigory G. on 03.07.22.
//

import UIKit

final class ImageViewBuilder {
    private var imageViewConfig: ImageViewConfiguration?
    
    init() {
        self.imageViewConfig = ImageViewConfiguration()
    }
    
    func setImage(_ image: UIImage) -> Self {
        self.imageViewConfig?.image = image
        return self
    }
    
    func setTintColor(_ color: UIColor) -> Self {
        self.imageViewConfig?.tintColor = color
        return self
    }
    
    func setFrameSize(_ size: CGSize) -> Self {
        self.imageViewConfig?.frameSize = size
        return self
    }
    
    func build() -> UIImageView {
        guard let config = imageViewConfig else {
            fatalError("ImageView configuration must be set before building.")
        }
        
        let imageView = UIImageView(image: config.image)
        imageView.frame.size = config.frameSize
        imageView.tintColor = config.tintColor
        return imageView
    }
}
