//
//  UIColor-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension UIColor {

    convenience init(hex: String, alpha: CGFloat = 1) {
        let scanner = Scanner(string: hex)
        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000ff
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    func modified(withAdditionalHue hue: CGFloat, additionalSaturation: CGFloat, additionalBrightness: CGFloat) -> UIColor {
        var currentHue: CGFloat = 0
        var currentSaturation: CGFloat = 0
        var currentBrigghtness: CGFloat = 0
        var currentAlpha: CGFloat = 0
        if self.getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigghtness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue + hue, saturation: currentSaturation + additionalSaturation, brightness: currentBrigghtness + additionalBrightness, alpha: currentAlpha)
        }
        return self
    }
}
