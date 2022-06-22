//
//  String-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 21.06.2022.
//

import UIKit
import CommonCrypto

// MARK: - SHA256
extension String {

    var sha256: String {
        get {
            guard let data = self.data(using: .utf8) else { return "" }
            let dData = digest(input: data as NSData)
            return hexStringFromData(input: dData)
        }
    }

    private func digest(input: NSData) -> NSData {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: length)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: length)
    }

    private func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }
        return hexString
    }
}

// MARK: - Text Size
extension String {

    func getTextSize(width: CGFloat, font: UIFont) -> CGRect {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return size
    }

    func height(width: CGFloat, font: UIFont) -> CGFloat {
        return ceil(getTextSize(width: width, font: font).height)
    }
}
