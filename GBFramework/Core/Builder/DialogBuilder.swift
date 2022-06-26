//
//  DialogBuilder.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class DialogBuilder {

    static let shared = DialogBuilder()

    struct DialogModel {

        var dialog: UIViewController
        var parent: UIWindow
        var isRemoving = false
    }

    private var items = [DialogModel]()

    func show(_ dialog: UIViewController, transition: TTransition = .crossdisolve, needDarkness: Bool = true, vSpace: CGFloat = 0, level: CGFloat = 0) {
        let leading = (UIScreen.main.bounds.width - dialog.view.frame.width) / 2
        var frame: CGRect
        if transition == .showFromTop {
            frame = CGRect(x: leading, y: vSpace, width: dialog.view.frame.width, height: dialog.view.frame.height)
        }
        else if transition == .showFromBottom {
            let y = UIScreen.main.bounds.height - dialog.view.frame.height - vSpace
            frame = CGRect(x: leading, y: y, width: dialog.view.frame.width, height: dialog.view.frame.height)
        }
        else {
            frame = UIScreen.main.bounds
        }

        let vc = DialogRootVC()
        var root: UIWindow
        if #available(iOS 13.0, *), let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            root = UIWindow(windowScene: scene)
            root.frame = frame
        } else {
            root = UIWindow(frame: frame)
        }

        root.rootViewController = vc
        root.windowLevel = UIWindow.Level.alert + 1 + level

        dialog.transitioningDelegate = vc.transition
        dialog.modalPresentationStyle = .custom
        vc.delegate = root
        vc.transition.transition = transition
        vc.transition.vSpace = vSpace
        vc.needDarkness = needDarkness
        root.makeKeyAndVisible()
        vc.present(dialog, animated: true, completion: nil)
        items.append(DialogModel(dialog: dialog, parent: root))
    }

    func remove(_ dialog: UIViewController, animated: Bool = false) {
        if let index = items.firstIndex(where: { $0.dialog == dialog }) {
            remove(at: index, animated: animated)
        }
    }

    private func remove(at index: Int, animated: Bool = false) {
        var dm = items[index]
        if dm.isRemoving { return }
        if let dialog = dm.dialog as? UIAlertController {
            dialog.dismiss(animated: true, completion: nil)
            dialog.actions.first?.isEnabled = false
        }
        dm.isRemoving = true
        dm.dialog.dismiss(animated: animated) {
            dm.dialog.removeFromParent()
            (dm.parent.rootViewController as? DialogRootVC)?.delegate = nil
            dm.parent.rootViewController?.dismiss(animated: false, completion: nil)
            dm.parent.isHidden = true
        }
        self.items.remove(at: index)
    }

    func removeAll() {
        let count = items.count
        if count == 0 { return }
        for index in (0 ..< count).reversed() {
            remove(at: index)
        }
    }
}

// MARK: - Get Dialog
extension DialogBuilder {

    private func getDialog(_ viewClass: AnyClass) -> UIViewController? {
        return items.first(where: { $0.dialog.isKind(of: viewClass) })?.dialog
    }
}

// MARK: - Show
extension DialogBuilder {

    func showBlurPopup() {
        let dialog = BlurPopup()
        show(dialog, transition: .crossdisolve, level: 500)
    }
}

// MARK: - Remove
extension DialogBuilder {

    func removeBlurPopup() {
        if let index = items.firstIndex(where: { $0.dialog.isKind(of: BlurPopup.self) }) {
            self.remove(at: index, animated: true)
        }
    }
}
