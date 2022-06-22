//
//  Factory.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

class Factory {

    // Api
    private let requestFactory: RequestFactory

    // Coordinator

    // Storage
    private let keychainWrapper: KeychainWrapper

    // Provider
    private var authStatusProvider: AuthStatusProvider {
        return AuthStatusProviderImpl(authService: authService)
    }

    private var loginProvider: LoginProvider {
        return LoginProviderImpl(authService: authService)
    }

    // Repository
    private let authRepository: AuthRepository

    // Screen

    // Service
    private let authService: AuthService

    init() {
        // Api
        requestFactory = RequestFactory()

        // Storage
        keychainWrapper = KeychainWrapperImpl.standard

        // Repository
        authRepository = AuthRepositoryImpl(keychainWrapper: keychainWrapper)

        // Service
        authService = AuthServiceImpl(authrepository: authRepository)
    }
}

// MARK: - Coordinator
protocol CoordinatorFactory {

    func makeAppCoordinator(router: Router) -> AppCoordinator
    func makeLaunchCoordinator(router: Router) -> LaunchCoordinator
    func makeLoginCoordinator(router: Router) -> LoginCoordinator
    func makeMapCoordinator(router: Router) -> MapCoordinator
    func makeRegisterCoordinator(router: Router) -> RegisterCoordinator
}

extension Factory: CoordinatorFactory {

    func makeAppCoordinator(router: Router) -> AppCoordinator {
        return AppCoordinator(router: router, coordinatorFactory: self)
    }

    func makeLaunchCoordinator(router: Router) -> LaunchCoordinator {
        return LaunchCoordinator(router: router, screenFactory: self)
    }

    func makeLoginCoordinator(router: Router) -> LoginCoordinator {
        return LoginCoordinator(router: router, screenFactory: self, coordinatroFactory: self)
    }

    func makeMapCoordinator(router: Router) -> MapCoordinator {
        return MapCoordinator(router: router, screenFactory: self)
    }

    func makeRegisterCoordinator(router: Router) -> RegisterCoordinator {
        return RegisterCoordinator(router: router, screenFactory: self)
    }
}

// MARK: - Screen
protocol ScreenFactory {

    func makeLaunchScreen() -> LaunchVC
    func makeLoginScreen() -> LoginVC
    func makeMapScreen() -> MapVC
    func makeRegisterScreen() -> RegisterVC
}

extension Factory: ScreenFactory {

    func makeLaunchScreen() -> LaunchVC {
        let screen = LaunchVC.loadFromNib()
        screen.provider = authStatusProvider
        return screen
    }

    func makeLoginScreen() -> LoginVC {
        let screen = LoginVC.loadFromNib()
        screen.provider = loginProvider
        return screen
    }

    func makeMapScreen() -> MapVC {
        let screen = MapVC.loadFromNib()
        screen.provider = loginProvider
        return screen
    }

    func makeRegisterScreen() -> RegisterVC {
        let screen = RegisterVC.loadFromNib()
        screen.provider = loginProvider
        return screen
    }
}
