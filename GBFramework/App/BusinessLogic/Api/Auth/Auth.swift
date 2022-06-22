//
//  Auth.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import Foundation
import Alamofire

class AuthApi: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: Session
    let queue: DispatchQueue
    let baseUrl = URL(string: Config.urlApi)!
    
    init(errorParser: AbstractErrorParser, sessionManager: Session, queue: DispatchQueue = .global(qos: .utility)) {
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
    }
}

// MARK: - Requests
extension AuthApi: AuthRequestFactory {
    
    // MARK: - Login
    func signIn(login: String, password: String, completionHandler: @escaping (AFDataResponse<AuthSignInResult>) -> Void) {
        let request = AuthLoginRequest(
            baseUrl: baseUrl,
            login: login,
            password: password)
        self.request(request: request,
                     completionHandler: completionHandler)
        ActivityHelper.shared.add(request.id)
    }
}
