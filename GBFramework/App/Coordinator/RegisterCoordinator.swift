//
//  RegisterCoordinator.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

class RegisterCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showRegister()
    }
    
    private func showRegister() {
        let screen = screenFactory.makeRegisterScreen()
        screen.onSignUp = { [weak self] in
            self?.finishFlow?()
        }
        router.push(screen, animated: true, hideBar: false, completion: nil)
    }
}
