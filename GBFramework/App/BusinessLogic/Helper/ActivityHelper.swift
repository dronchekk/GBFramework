//
//  ActivityHelper.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import UIKit

class ActivityHelper {

    static let shared = ActivityHelper()

    private var activity: UIActivityIndicatorView?
    private var window: UIWindow?

    private var items = [String]()

    func reinit() {
        hide()
        DispatchQueue.main.async {
            self.window?.removeFromSuperview()
            self.window = nil
            self.activity = nil
        }
    }

    func add(_ id: String) {
        initWindow()
        initActivity()
        items.append(id)
        show()
    }

    func remove(_ requestData: Data?) {
        guard let data = requestData,
              let params = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
              let id = params["id"] as? String
        else { return }
        if items.isEmpty { return }
        items.removeAll(where: { $0 == id })
        hide()
    }

    private func show() {
        window?.isHidden = false
        UIView.animate(withDuration: 0.1) {
            DispatchQueue.main.async {
                self.window?.alpha = 1
            }
        }
    }

    private func hide() {
        if items.isEmpty {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, animations: {
                    self.window?.alpha = 0
                }) { (_) in
                    self.window?.isHidden = true
                }
            }
        }
    }

    private func initWindow() {
        if window == nil {
            if #available(iOS 13.0, *), let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                window = UIWindow(windowScene: windowScene)
            }
            else {
                window = UIWindow(frame: UIScreen.main.bounds)
            }
            window?.rootViewController = UIViewController()
            window?.backgroundColor = .black.withAlphaComponent(0.3)
            window?.windowLevel = UIWindow.Level.alert + 100
            window?.makeKeyAndVisible()
            window?.isHidden = true
            window?.alpha = 1
        }
    }

    private func initActivity() {
        if activity == nil {
            activity = UIActivityIndicatorView(style: .whiteLarge)
            activity!.center = window!.center
            activity!.startAnimating()
            window?.addSubview(activity!)
        }
    }
}
