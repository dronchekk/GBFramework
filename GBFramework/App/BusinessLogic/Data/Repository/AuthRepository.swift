//
//  AuthRepository.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import Foundation

protocol AuthRepository {

    var data: AuthCredentials { get set }
}

private enum AuthRepositoryKeys: String {
    case login
    case password
    case token
}

class AuthRepositoryImpl: AuthRepository {

    private var keychainWrapper: KeychainWrapper
    var data: AuthCredentials {
        get {
            let login = keychainWrapper.string(forKey: AuthRepositoryKeys.login.rawValue)
            let password = keychainWrapper.string(forKey: AuthRepositoryKeys.password.rawValue)
            let token = keychainWrapper.string(forKey: AuthRepositoryKeys.token.rawValue)
            return AuthCredentials(
                login: login ?? "",
                password: password ?? "",
                token: token ?? "")
        }
        set {
            if newValue.token.isEmpty {
                keychainWrapper.removeObject(forKey: AuthRepositoryKeys.login.rawValue)
                keychainWrapper.removeObject(forKey: AuthRepositoryKeys.password.rawValue)
                keychainWrapper.removeObject(forKey: AuthRepositoryKeys.token.rawValue)
            }
            else {
                keychainWrapper.set(newValue.login, forKey: AuthRepositoryKeys.login.rawValue)
                keychainWrapper.set(newValue.password, forKey: AuthRepositoryKeys.password.rawValue)
                keychainWrapper.set(newValue.token, forKey: AuthRepositoryKeys.token.rawValue)
            }
        }
    }

    init(keychainWrapper: KeychainWrapper) {
        self.keychainWrapper = keychainWrapper
    }
}
