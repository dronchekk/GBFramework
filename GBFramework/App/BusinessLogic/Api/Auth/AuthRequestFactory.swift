//
//  AuthRequestFactory.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import Foundation
import Alamofire

protocol AuthRequestFactory {

    func signIn(login: String, password: String, completionHandler: @escaping (AFDataResponse<AuthSignInResult>) -> Void)
}
