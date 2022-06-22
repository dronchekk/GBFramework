//
//  DataManager.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

class DataManager {
    
    static let shared = DataManager()
    
    var auth: AuthRepository
    
    init() {
        auth = AuthRepositoryImpl(keychainWrapper: KeychainWrapperImpl.standard)
    }
}
