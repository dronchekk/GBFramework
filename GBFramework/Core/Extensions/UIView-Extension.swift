//
//  UIView-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width:CGFloat, height: CGFloat) {
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    private func animateState(_ borderColor: UIColor, _ bgColor: UIColor) {
        self.layer.animateBorderColor(to: borderColor)
        self.layer.animateBgColor(to: bgColor)
    }

    func showTfUp() {
        self.animateState(Styles.shared.c.tfBorderUp, Styles.shared.c.tfBgUp)
    }

    func showTfFocused() {
        self.animateState(Styles.shared.c.tfBorderFocused, Styles.shared.c.tfBgFocused)
    }

    func showTfError() {
        self.animateState(Styles.shared.c.tfBorderError, Styles.shared.c.tfBgError)
    }

    func setTopCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    func setTopLeftCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMinYCorner]
    }

    func setTopRightCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMaxXMinYCorner]
    }

    func setBottomCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    func setBottomLeftCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMinXMaxYCorner]
    }

    func setBottomRightCornerRadius(value: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = value
        self.layer.maskedCorners = [.layerMaxXMaxYCorner]
    }

    var style: String {
        get { return "" }
        set { Styles.shared.applyStyle(newValue, self) }
    }
}
