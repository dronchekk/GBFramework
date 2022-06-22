//
//  Styles.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 19.06.2022.
//

import Foundation
import UIKit

struct MFont {

    let size: CGFloat
    let name: String
    let color: UIColor
    let ha: NSTextAlignment
    let adj: Bool
    let a: CGFloat

    init(_ size: CGFloat, _ name: String, _ color: UIColor, _ ha: NSTextAlignment, _ adj: Bool = false, _ a: CGFloat = 1.0) {
        self.size = size
        self.name = name
        self.color = color
        self.ha = ha
        self.adj = adj
        self.a = a
    }
}

class Styles {

    static let shared = Styles()

    let c = Colors()
    let fs = FontSizes()

    let button = ButtonStyles()
    let label = LabelStyles()
    let tf = TextfieldStyles()
    let view = ViewStyles()

    private let fontR = "SourceSansPro-Regular"
    private let fontB = "SourceSansPro-SemiBold"

    private var fonts = [String:MFont]()
    private var uiFonts = [String: UIFont]()

    init() {
        fonts = [String:MFont]()
        fonts[button.bevelDfPr] = MFont(fs.fs26, fontB, c.cWhite, .left)
        fonts[button.quietDfPr] = MFont(fs.fs26, fontB, c.fcPr, .left)
        fonts[button.roundSmPr] = MFont(fs.fs20, fontB, c.cWhite, .left)
        fonts[button.roundDfPr] = MFont(fs.fs26, fontB, c.cWhite, .left)

        fonts[label.toast] = MFont(fs.fs18, fontR, c.cWhite, .center)

        fonts[tf.dfPr] = MFont(fs.fs22, fontB, c.fcTfPr, .left)
        fonts[tf.dfPh] = MFont(fs.fs22, fontB, c.fcTfPh, .left)

        fonts[view.navbarPrC] = MFont(fs.fs26, fontB, c.fcMain, .center)
    }

    func getFontStyle(_ style: String) -> MFont {
        return fonts[style]!
    }

    func getFont(_ style: String) -> UIFont {
        let fontStyle = getFontStyle(style)
        let fontName = "\(fontStyle.name)\(fontStyle.size)"
        if uiFonts[fontName] == nil {
            uiFonts[fontName] = UIFont(name: fontStyle.name, size: fontStyle.size)
        }
        return uiFonts[fontName]!
    }

    func getFontColor(_ style: String) -> UIColor {
        let fontStyle = getFontStyle(style)
        return fontStyle.color
    }

    func getAttributedString(for string: String, with style: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: self.getAttributes(style))
    }

    func getAttributes(_ style: String) -> [NSAttributedString.Key:Any] {
        let fontStyle = fonts[style]!
        return [
            NSAttributedString.Key.foregroundColor: fontStyle.color.withAlphaComponent(CGFloat(fontStyle.a)),
            NSAttributedString.Key.font: UIFont(name: fontStyle.name, size: CGFloat(fontStyle.size))!
        ]
    }

    func applyStyle(_ style: String, _ button: UIButton) {
        self.button.applyStyle(style, button)
    }

    func applyStyle(_ style: String, _ barButtonItem: UIBarButtonItem) {
        self.button.applyStyle(style, barButtonItem)
    }

    func applyStyle(_ style: String, _ button: UISegmentedControl) {
        self.button.applyStyle(style, button)
    }

    func applyStyle(_ style: String, _ swtch: UISwitch) {
        self.button.applyStyle(style, swtch)
    }

    func applyStyle(_ style: String, _ label: UILabel) {
        self.label.applyStyle(style, label)
    }

    func applyStyle(_ style: String, _ textfield: UITextField) {
        self.tf.applyStyle(style, textfield)
    }

    func applyStyle(_ style: String, _ textview: UITextView) {
        self.tf.applyStyle(style, textview)
    }

    func applyStyle(_ style: String, _ view: UIView) {
        if view.isKind(of: UILabel.self) {
            self.applyStyle(style, view as! UILabel)
        }
        else if view.isKind(of: UIButton.self) {
            self.applyStyle(style, view as! UIButton)
        }
        else if view.isKind(of: UISwitch.self) {
            self.applyStyle(style, view as! UISwitch)
        }
        else if view.isKind(of: UITextField.self) {
            self.applyStyle(style, view as! UITextField)
        }
        else if view.isKind(of: UITextView.self) {
            self.applyStyle(style, view as! UITextView)
        }
        else if view.isKind(of: UISegmentedControl.self) {
            self.applyStyle(style, view as! UISegmentedControl)
        }
        else {
            self.view.applySytle(style, view)
        }
    }

    private func addShadow(layer: CALayer, path: UIBezierPath, offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shadowPath = path.cgPath
    }

    func addShadow(_ view: UIView, x: CGFloat, y: CGFloat, a: CGFloat, blur: CGFloat = 10, cornerRadius: CGFloat = 0) {
        if cornerRadius == 0 {
            addShadow(layer: view.layer, path: UIBezierPath(rect: view.bounds), offset: CGSize(width: x, height: y), color: .black, opacity: Float(a), radius: CGFloat(blur))
        }
        else {
            addShadow(layer: view.layer, path: UIBezierPath(roundedRect: view.bounds, cornerRadius: CGFloat(cornerRadius)), offset: CGSize(width: x, height: y), color: .black, opacity: Float(a), radius: CGFloat(blur))
        }
    }
}

// MARK: - Colors
class Colors {

    let dialogDark = UIColor(hex: "#000000", alpha: 0.3)
    let mapRoute = UIColor(hex: "#3498db")
    let switchBgOn = UIColor(hex: "#007aff")
    let switchBgOff = UIColor(hex: "#dcdcdc")
    let switchThumb = UIColor(hex: "#ffffff")
    let toast = UIColor(hex: "#333333")
    let vc = UIColor(hex: "#ffffff")

    let cWhite = UIColor(hex: "#ffffff")

    let fcMain = UIColor(hex: "#000000")
    let fcPr = UIColor(hex: "#3d3c49")
    let fcTfPr = UIColor(hex: "#000000")
    let fcTfPh = UIColor(hex: "#808080")

    let buttonPrUp = UIColor(hex: "#3d3c49")
    let buttonPrDown: UIColor

    let sep = UIColor(hex: "#ececec")

    let tfBorderUp = UIColor(hex: "#d2d2d2")
    let tfBorderFocused = UIColor(hex: "#bebebd")
    let tfBorderError = UIColor(hex: "#f9b290")
    let tfBgUp = UIColor(hex: "#ffffff", alpha: 0)
    let tfBgFocused = UIColor(hex: "#abab49", alpha: 0.05)
    let tfBgError = UIColor(hex: "#f9b290")

    init() {
        buttonPrDown = buttonPrUp.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: -0.1)
    }
}

// MARK: - Font Size
class FontSizes {

    let fs18 = 18.0
    let fs20 = 20.0
    let fs22 = 22.0
    let fs24 = 24.0
    let fs26 = 26.0
    let fs28 = 28.0
}

// MARK: - Button
class ButtonStyles {

    let bevelDfPr = "buttonBevelDfPr"
    let quietDfPr = "buttonQuietDfPr"
    let roundSmPr = "buttonRoundSmPr"
    let roundDfPr = "buttonRoundDfPr"

    let sizeSm: CGFloat = 34.0
    let sizeDf: CGFloat = 50.0
    let sizeLg: CGFloat = 60.0

    let cornerSm: CGFloat = 6
    let cornerDf: CGFloat = 10

    private let fcHighlightedRatio = 0.5

    func applyStyle(_ style: String, _ button: UIButton) {
        switch style {
        case bevelDfPr: setStyleBevelDfPr(style, button)
        case quietDfPr: setStyleQuietDfPr(style, button)
        case roundSmPr: setStyleRoundSmPr(style, button)
        case roundDfPr: setStyleRoundDfPr(style, button)
        default:
            print("no button style \(style)")
        }
    }

    func applyStyle(_ style: String, _ button: UIBarButtonItem) {
        print("no barbutton style \(style)")
    }

    func applyStyle(_ style: String, _ button: UISegmentedControl) {
        print("no barbutton style \(style)")
    }

    func applyStyle(_ style: String, _ button: UISwitch) {
        print("no switch style \(style)")
    }

    private func setTextFont(_ style: String, _ button: UIButton) {
        let fontStyle = Styles.shared.getFontStyle(style)
        button.titleLabel?.font = Styles.shared.getFont(style)
        button.setTitleColor(fontStyle.color.withAlphaComponent(fontStyle.a), for: .normal)
    }

    private func setStyleCommon(button: UIButton, upColor: UIColor, downColor: UIColor, height: CGFloat, cornerRadius: CGFloat, fontStyle: String) {
        button.backgroundColor = upColor
        button.setHighlightedBackgroundColor(downColor)
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        if cornerRadius > 0 {
            button.clipsToBounds = true
            button.layer.cornerRadius = cornerRadius
        }
        if !fontStyle.isEmpty {
            setTextFont(fontStyle, button)
        }
    }

    private func setStyleBevelDfPr(_ style: String, _ button: UIButton) {
        setStyleCommon(button: button,
                       upColor: Styles.shared.c.buttonPrUp,
                       downColor: Styles.shared.c.buttonPrDown,
                       height: sizeDf,
                       cornerRadius: cornerDf,
                       fontStyle: style)
        button.contentEdgeInsets = UIEdgeInsets(top: -2, left: 20, bottom: 0, right: 20)
    }

    private func setStyleQuietDfPr(_ style: String, _ button: UIButton) {
        button.heightAnchor.constraint(equalToConstant: sizeDf).isActive = true
        button.contentEdgeInsets = UIEdgeInsets(top: -2, left: 20, bottom: 0, right: 20)
        setTextFont(style, button)
        let fontStyle = Styles.shared.getFontStyle(style)
        button.setTitleColor(fontStyle.color.withAlphaComponent(fontStyle.a * fcHighlightedRatio), for: .highlighted)
    }

    private func setStyleRoundSmPr(_ style: String, _ button: UIButton) {
        setStyleCommon(button: button,
                       upColor: Styles.shared.c.buttonPrUp,
                       downColor: Styles.shared.c.buttonPrDown,
                       height: sizeSm,
                       cornerRadius: sizeSm / 2,
                       fontStyle: style)
        button.contentEdgeInsets = UIEdgeInsets(top: -2, left: 20, bottom: 0, right: 20)
    }

    private func setStyleRoundDfPr(_ style: String, _ button: UIButton) {
        setStyleCommon(button: button,
                       upColor: Styles.shared.c.buttonPrUp,
                       downColor: Styles.shared.c.buttonPrDown,
                       height: sizeDf,
                       cornerRadius: sizeDf / 2,
                       fontStyle: style)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 3, right: 20)
    }
}

// MARK: - Label
class LabelStyles {

    let toast = "toast"
    //let r20main = "r20main"

    func applyStyle(_ style: String, _ label: UILabel) {
        let fontStyle = Styles.shared.getFontStyle(style)
        label.font = Styles.shared.getFont(style)
        label.textColor = fontStyle.color.withAlphaComponent(fontStyle.a)
        label.textAlignment = fontStyle.ha
    }
}

// MARK: - Textfield
class TextfieldStyles {

    let dfPh = "textfieldDfPh"
    let dfPr = "textfieldDfPr"
    let dfPrB = "textfieldDfPrB"
    let dfPrM = "textfieldDfPrM"
    let dfPrT = "textfieldDfPrT"

    let sizeDf: CGFloat = 50
    let sizeLg: CGFloat = 60

    let cornerDf: CGFloat = 10
    let paddingDf: CGFloat = 10

    private func setTextFont(_ style: String, _ textfield: UITextField) {
        let fontStyle = Styles.shared.getFontStyle(style)
        textfield.font = Styles.shared.getFont(style)
        textfield.textColor = fontStyle.color.withAlphaComponent(fontStyle.a)
        textfield.textAlignment = fontStyle.ha
    }

    private func setTextFont(_ style: String, _ textfield: UITextView) {
        let fontStyle = Styles.shared.getFontStyle(style)
        textfield.font = Styles.shared.getFont(style)
        textfield.textColor = fontStyle.color.withAlphaComponent(fontStyle.a)
        textfield.textAlignment = fontStyle.ha
    }

    func applyStyle(_ style: String, _ textfield: UITextField) {
        switch style {
        case dfPr: setStyleDfPr(style, textfield)
        case dfPrB: setStyleDfPrB(style, textfield)
        case dfPrM: setStyleDfPrM(style, textfield)
        case dfPrT: setStyleDfPrT(style, textfield)
        default:
            print("no textfield style \(style)")
        }
    }

    func applyStyle(_ style: String, _ textview: UITextView) {
        print("no textview style \(style)")
    }

    private func setStyleDfPrCommon(_ style: String, _ textfield: UITextField) {
        textfield.borderStyle = .none
        textfield.clipsToBounds = true
        textfield.layer.masksToBounds = true
        textfield.layer.borderWidth = 1
        textfield.layer.cornerRadius = cornerDf
        textfield.setHorizontalTextPadding(paddingDf)
        textfield.tintColor = Styles.shared.getFontColor(dfPr)
        textfield.setPlaceholder(textfield.placeholder ?? "", with: dfPh)
        setTextFont(dfPr, textfield)
        textfield.showTfUp()
    }

    private func setStyleDfPr(_ style: String, _ textfield: UITextField) {
        setStyleDfPrCommon(style, textfield)
    }

    private func setStyleDfPrB(_ style: String, _ textfield: UITextField) {
        setStyleDfPrCommon(style, textfield)
        textfield.setBottomCornerRadius(value: cornerDf)
    }

    private func setStyleDfPrM(_ style: String, _ textfield: UITextField) {
        setStyleDfPrCommon(style, textfield)
        textfield.layer.cornerRadius = 0
    }

    private func setStyleDfPrT(_ style: String, _ textfield: UITextField) {
        setStyleDfPrCommon(style, textfield)
        textfield.setTopCornerRadius(value: cornerDf)
    }

    private func setStyleDfPr(_ style: String, _ textview: UITextView) {
        setTextFont(style, textview)
    }
}

// MARK: - View
class ViewStyles {

    let navbarPrC = "navbarPrC"

    let navbarDf: CGFloat = 44
    let cornerDf: CGFloat = 15

    func applySytle(_ style: String, _ view: UIView) {
        print("no view style \(style)")
    }
}
