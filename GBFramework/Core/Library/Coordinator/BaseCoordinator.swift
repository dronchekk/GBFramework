//
//  BaseCoordinator.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 21.06.2022.
//

protocol Coordinator: AnyObject {
    
    func start()
}

class BaseCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    
    func start() {}
    
    func addDependency(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinator?) {
        guard !childCoordinators.isEmpty, let coordinator = coordinator else { return }
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators.filter({ $0 !== coordinator })
                .forEach({ coordinator.removeDependency($0) })
        }
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
