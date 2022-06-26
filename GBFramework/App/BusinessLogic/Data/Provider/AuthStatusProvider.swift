//
//  AuthStatusProvider.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

protocol AuthStatusProvider: AnyObject {

    var isAuthed: Bool { get }
}

class AuthStatusProviderImpl: AuthStatusProvider {

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    var isAuthed: Bool { authService.isAuthed }
}
