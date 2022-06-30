//
//  LaunchCoordinator.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

class LaunchCoordinator: BaseCoordinator {
    
    var finishFlow: BoolClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
        self.router = router
    }
    
    override func start() {
        showLaunch()
    }
    
    private func showLaunch() {
        let screen = screenFactory.makeLaunchScreen()
        screen.onCheckAuth = { [weak self] isAuthed in
            self?.finishFlow?(isAuthed)
        }
        router.setRootModule(screen, hideBar: true)
    }
}
