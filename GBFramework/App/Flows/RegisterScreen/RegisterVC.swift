//
//  RegisterVC.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import UIKit

class RegisterVC: UIViewController {

    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        updateData()
    }

    // MARK: - Coordinator
    var onSignUp: VoidClosure?


    // MARK: - Properties
    var provider: LoginProvider?


    // MARK: - Private
    private func configure() {

    }

    func updateData() {
        self.title = Locales.value("vc_register_title")
    }
}
