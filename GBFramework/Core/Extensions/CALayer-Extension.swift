//
//  CALayer-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension CALayer {
    
    func animateBorderColor(to endColor: UIColor, withDuration duration: Double = 0.2) {
        let colorAnimation = CABasicAnimation(keyPath: "borderColor")
        colorAnimation.fromValue = self.borderColor
        colorAnimation.toValue = endColor.cgColor
        colorAnimation.duration = duration
        self.borderColor = endColor.cgColor
        self.add(colorAnimation, forKey: "borderColor")
    }
    
    func animateBgColor(to endColor: UIColor, withDuration duration: Double = 0.2) {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = self.backgroundColor
        colorAnimation.toValue = endColor.cgColor
        colorAnimation.duration = duration
        self.backgroundColor = endColor.cgColor
        self.add(colorAnimation, forKey: "backgroundColor")
    }
}
