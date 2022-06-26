//
//  UIButton-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension UIButton {

    func setDisabledBackgroundColor(_ color: UIColor) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image(actions: { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        })
        self.setBackgroundImage(colorImage, for: .disabled)
    }

    func setHighlightedBackgroundColor(_ color: UIColor) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image(actions: { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        })
        self.setBackgroundImage(colorImage, for: .highlighted)
    }
}
