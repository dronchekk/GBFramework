//
//  AuthCredentials.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 20.06.2022.
//

import Foundation

struct AuthCredentials {

    var login = ""
    var password = ""
    var token = ""

    init() {
        self.init(login: "", password: "")
    }

    init(login: String, password: String, token: String = "") {
        self.login = login
        self.password = password
        self.token = token
    }
}
