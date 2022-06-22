//
//  AppCoordinator.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

class AppCoordinator: BaseCoordinator {

    private let coordinatorFactory: CoordinatorFactory
    private let router: Router

    private var isFirstLaunch = true
    private var isAuthed = false

    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        if isFirstLaunch {
            runLaunchFlow()
            isFirstLaunch = false
            return
        }

        if isAuthed {
            runMapFlow()
        }
        else {
            runLoginFlow()
        }
    }

    private func runLaunchFlow() {
        let coordinator = coordinatorFactory.makeLaunchCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] isAuthed in
            self?.isAuthed = isAuthed
            self?.start()
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    private func runLoginFlow() {
        let coordinator = coordinatorFactory.makeLoginCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.isAuthed = true
            self?.start()
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }

    private func runMapFlow() {
        let coordinator = coordinatorFactory.makeMapCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.isAuthed = false
            self?.start()
            self?.removeDependency(coordinator)
        }
        self.addDependency(coordinator)
        coordinator.start()
    }
}
