//
//  LoginProvider.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

protocol LoginProvider {

    var isAuthed: Bool { get }

    func signIn(with credentials: AuthCredentials, completion: @escaping ((Bool, String?) -> Void))
    func signOut(completion: @escaping BoolClosure)
}

class LoginProviderImpl: LoginProvider {

    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    var isAuthed: Bool { authService.isAuthed }

    func signIn(with credentials: AuthCredentials, completion: @escaping ((Bool, String?) -> Void)) {
        authService.signIn(withCredentials: credentials, completion: completion)
    }

    func signOut(completion: @escaping BoolClosure) {
        authService.signOut(completion: completion)
    }
}
