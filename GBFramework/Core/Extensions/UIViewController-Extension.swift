//
//  UIViewController-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension UIViewController {

    static var identifier: String {
        get { return String(describing: self) }
    }

    func canPerformSegue(withIdentifier id: String) -> Bool {
        guard let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        return segues.firstIndex { $0.value(forKey: "identifier") as? String == id } != nil
    }

    // Performs segue with passed identifier, if self can perform it.
    func performSegueIfPossible(withIdentifier id: String, sender: AnyObject? = nil) {
        guard canPerformSegue(withIdentifier: id) else { return }
        self.performSegue(withIdentifier: id, sender: sender)
    }

    static func loadFromNib(presentationStyle: UIModalPresentationStyle = .fullScreen, transitionStyle: UIModalTransitionStyle = .crossDissolve) -> Self {
        func instantiateFromNib<T: UIViewController>(presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle) -> T {
            let viewController = T.init(nibName: String(describing: T.self), bundle: nil)
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalTransitionStyle = transitionStyle
            return viewController
        }
        return instantiateFromNib(presentationStyle: presentationStyle, transitionStyle: transitionStyle)
    }

    func showToast(message : String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = Styles.shared.c.toast
        toastLabel.style = Styles.shared.label.toast
        toastLabel.text = message
        toastLabel.alpha = 1.0
        let size = message.getTextSize(width: self.view.frame.width - 80, font: toastLabel.font)
        let left = (UIScreen.main.bounds.width - size.width) / 2 - 20
        let height = size.height + 30
        let cornerRadius = height / 2 > 30 ? 30 : height / 2
        toastLabel.frame = CGRect(x: left, y: self.view.frame.height, width: size.width + 40, height: height)
        toastLabel.layer.cornerRadius = cornerRadius
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            var frame = toastLabel.frame
            frame.origin.y = self.view.frame.height - 100
            toastLabel.frame = frame
        } completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 3, options: .curveEaseIn) {
                var frame = toastLabel.frame
                frame.origin.y = self.view.frame.height
                toastLabel.frame = frame
            } completion: { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}

protocol Presentable: AnyObject {

    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {

    func toPresent() -> UIViewController? {
        return self
    }
}
