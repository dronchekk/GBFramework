//
//  ObservableOptions.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import Foundation

struct CustomObservableOptions: OptionSet, CustomStringConvertible {

    static let initial = CustomObservableOptions(rawValue: 1 << 0)
    static let old = CustomObservableOptions(rawValue: 1 << 1)
    static let new = CustomObservableOptions(rawValue: 1 << 2)

    var rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    var description: String {
        switch self {
        case .initial:
            return "initial"
        case .old:
            return "old"
        case .new:
            return "new"
        default:
            return "CustomObservableOptions(rawValue: \(rawValue)"
        }
    }
}
