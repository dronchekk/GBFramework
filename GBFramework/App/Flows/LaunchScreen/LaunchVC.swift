//
//  LaunchVC.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import UIKit

class LaunchVC: UIViewController {

    // MARK: - Coordinator
    var onCheckAuth: BoolClosure?

    // MARK: - Properties
    var provider: AuthStatusProvider?

    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthStatus()
    }

    // MARK: - Private
    private func checkAuthStatus() {
        guard let provider = provider else { return }
        self.onCheckAuth?(provider.isAuthed)
    }
}
