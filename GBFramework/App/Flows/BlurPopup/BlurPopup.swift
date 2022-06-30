//
//  BlurPopup.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class BlurPopup: UIViewController {

    // MARK: - Properties
//    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()


    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Private
    private func configure() {
        // fix size
        self.view.frame = UIScreen.main.bounds

//        self.view.backgroundColor = .black.withAlphaComponent(0.5)
//        let blurView = UIVisualEffectView(frame: self.view.frame)
//        blurEffect.setValue(1, forKey: "blurRadius")
//        blurView.effect = blurEffect
//        view.addSubview(blurView)

        self.view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(blurView, at: 0)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
