//
//  Int-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 27.06.2022.
//

// MARK: - Convert
extension Int {

    init(_ value: Any?, defaultValue: Double = 0) {
        self = Int(Double(value, defaultValue: defaultValue))
    }
}
