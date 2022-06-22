//
//  AbstractErrorParser.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 21.06.2022.
//

import Foundation

protocol AbstractErrorParser {

    func parse(_ result: Error) -> Error
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error?
}
