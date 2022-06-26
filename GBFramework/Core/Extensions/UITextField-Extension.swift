//
//  UITextField-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension UITextField {

    func setHorizontalTextPadding(_ value: CGFloat) {
        let rect = CGRect(x: 0, y: 0, width: value, height: 0)
        let paddingView = UIView(frame: rect)
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }

    func setLeftPadding(_ value: CGFloat) {
        let rect = CGRect(x: 0, y: 0, width: value, height: 0)
        let paddingView = UIView(frame: rect)
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setPlaceholder(_ string: String, with style: String) {
        self.attributedPlaceholder = Styles.shared.getAttributedString(for: string, with: style)
    }
}
