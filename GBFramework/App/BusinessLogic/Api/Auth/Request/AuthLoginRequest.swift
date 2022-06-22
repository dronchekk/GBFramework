//
//  AuthLoginRequest.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import Foundation
import Alamofire

struct AuthLoginRequest: RequestRouter {

    var baseUrl: URL
    let httpMethod: HTTPMethod = .post

    let id: String = NSUUID().uuidString
    let method: String = ApiMethod.authSignIn
    var time: String
    var signature: String

    var login: String
    var password: String
    var token: String

    init(baseUrl: URL, login: String, password: String) {
        self.baseUrl = baseUrl
        self.login = login
        self.password = password
        self.token = ""

        self.time = ""
        self.signature = ""

        self.time = getTime()
        self.signature = getSignature()
    }

    var parameters: Parameters? {
        return [
            "id": id,
            "method": method,
            "params": [
                "time": time,
                "login": login,
                "signature": signature
            ]
        ]
    }
}
