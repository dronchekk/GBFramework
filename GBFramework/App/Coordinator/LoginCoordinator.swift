//
//  LoginCoordinator.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

class LoginCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    
    private let coordinatorFactory: CoordinatorFactory
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory, coordinatroFactory: CoordinatorFactory) {
        self.router = router
        self.screenFactory = screenFactory
        self.coordinatorFactory = coordinatroFactory
    }
    
    override func start() {
        showLogin()
    }
    
    private func showLogin() {
        let screen = screenFactory.makeLoginScreen()
        screen.onSignIn = { [weak self] in
            self?.finishFlow?()
        }
        screen.onRegister = { [weak self] in
            self?.runRegisterFlow()
        }
        router.setRootModule(screen, hideBar: true)
    }
    
    private func runRegisterFlow() {
        let coordinator = coordinatorFactory.makeRegisterCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.start()
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
}
