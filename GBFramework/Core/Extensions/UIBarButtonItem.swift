//
//  UIBarButtonItem.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension UIBarButtonItem {

    var style: String {
        get { return "" }
        set { Styles.shared.applyStyle(newValue, self) }
    }
}
