//
//  ThemeManager.swift
//  CircleControl
//
//  Created by Grigory G. on 30.06.22.
//

import UIKit

struct ThemeManager {
    // MARK: - Shared Instance
    static let shared = ThemeManager()
    
    // MARK: - Fonts
    enum Font {
        static func regular() -> UIFont {
            return UIFont.systemFont(ofSize: 12, weight: .regular)
        }
        
        static func bold() -> UIFont {
            return UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        
        static func monospaced(size: CGFloat) -> UIFont {
            return UIFont.monospacedDigitSystemFont(ofSize: size, weight: .bold)
        }
    }
    
    // MARK: - Colors
    enum Color {
        static let midnightGrayColor: UIColor = .midnightGray
        static let silverMistColor: UIColor = .silverMist
        static let slateGrayColor: UIColor = .slateGray
        static let cloudGrayColor: UIColor = .cloudGray
        static let cloudWhiteColor: UIColor = .cloudWhite
        static let frostGrayColor: UIColor = .frostGray
        static let whiteColor: UIColor = .white
    }
    
    // MARK: - Images
    enum Image {
        //"sparkles", , "sun.max.fill",

        static let moonIcon: UIImage = UIImage(systemName: "moon.fill") ?? UIImage()
        //ImageUtils.emojiToImage(emoji: "🌙", size: 24)
        static let alarmClockIcon: UIImage = UIImage(systemName: "alarm") ?? UIImage()
        //ImageUtils.emojiToImage(emoji: "⏰", size: 24)
        static let bedIcon: UIImage = UIImage(systemName: "bed.double") ?? UIImage()
        //ImageUtils.emojiToImage(emoji: "🛌", size: 24)
        //static let sunIcon: UIImage = ImageUtils.emojiToImage(emoji: "☀️", size: 24)
    }
}
