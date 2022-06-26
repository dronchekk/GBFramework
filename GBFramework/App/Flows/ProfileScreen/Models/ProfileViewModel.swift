//
//  ProfileViewModel.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

struct ProfileViewModel {

    weak var coordinator: Coordinator?

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func goToLogin() {
//        let loginVC = LoginVC.loadFromNib()
//        loginVC.viewModel = LoginViewModel(coordinator: self)
//        navigationController.setViewControllers([loginVC], animated: true)
    }
}
