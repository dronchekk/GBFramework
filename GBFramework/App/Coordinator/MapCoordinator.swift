//
//  MapCoordinator.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

class MapCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    
    init(router: Router, screenFactory: ScreenFactory) {
        self.router = router
        self.screenFactory = screenFactory
    }
    
    override func start() {
        showMap()
    }
    
    private func showMap() {
        let screen = screenFactory.makeMapScreen()
        screen.onSignOut = { [weak self] in
            self?.finishFlow?()
        }
        router.setRootModule(screen, hideBar: true)
    }
}
